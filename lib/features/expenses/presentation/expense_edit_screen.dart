import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/firebase/app_error.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../../core/money/money.dart';
import '../../../core/money/split_calculator.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';
import '../../receipts/data/receipt_repository.dart';
import '../../settings/data/settings_controller.dart';
import '../../shopping/data/shopping_repository.dart';
import '../data/expense_repository.dart';
import '../domain/expense.dart';
import 'split_editor.dart';

/// Prefilled values for a new expense (shopping list, receipt scan).
class ExpenseDraft {
  const ExpenseDraft({
    this.description,
    this.category,
    this.note,
    this.shoppingItemIds = const [],
    this.startWithReceipt = false,
  });

  final String? description;
  final ExpenseCategory? category;
  final String? note;

  /// Shopping items removed from the list once the expense is saved.
  final List<String> shoppingItemIds;

  /// Opens the receipt picker right away.
  final bool startWithReceipt;
}

class ExpenseEditScreen extends ConsumerStatefulWidget {
  const ExpenseEditScreen({super.key, this.expenseId, this.draft});

  final String? expenseId;
  final ExpenseDraft? draft;

  @override
  ConsumerState<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends ConsumerState<ExpenseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _note = TextEditingController();
  SplitController? _split;
  Expense? _existing;
  String? _paidBy;
  ExpenseCategory _category = ExpenseCategory.other;
  DateTime _date = DateTime.now();
  String? _receiptPath;
  List<ReceiptItem> _receiptItems = const [];
  bool _initialized = false;
  bool _saving = false;
  bool _scanning = false;

  bool get _isEdit => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
    if (widget.draft?.startWithReceipt ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scanReceipt());
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _note.dispose();
    _split?.dispose();
    super.dispose();
  }

  /// Initializes the form once members (and the expense when editing) are loaded.
  bool _ensureInitialized(List<Member> members) {
    if (_initialized) return true;
    if (members.isEmpty) return false;
    final uid = ref.read(currentUidProvider)!;
    final locale = context.l10n.localeName;
    final split = SplitController(memberIds: [for (final m in members) m.id]);
    if (_isEdit) {
      final e = ref.read(expenseByIdProvider(widget.expenseId!));
      if (e == null) return false;
      _existing = e;
      if (e.amountMinor > 0) _amount.text = Money.toInput(e.amountMinor, locale: locale);
      _description.text = e.description;
      _note.text = e.note;
      _paidBy = e.paidBy;
      _category = e.category;
      _date = e.date;
      _receiptPath = e.receiptPath;
      _receiptItems = e.receiptItems;
      if (e.splitInput.isNotEmpty) split.load(e.splitType, e.splitInput, locale: locale);
    } else {
      final d = widget.draft;
      _paidBy = uid;
      _description.text = d?.description ?? '';
      _note.text = d?.note ?? '';
      _category = d?.category ?? ExpenseCategory.other;
      if (_category == ExpenseCategory.rent) split.applyRentWeights(members);
    }
    _split = split;
    _initialized = true;
    return true;
  }

  void _setCategory(ExpenseCategory c, List<Member> members) {
    setState(() => _category = c);
    // Rent uses each member's default "kira payı".
    if (c == ExpenseCategory.rent && !_isEdit) _split!.applyRentWeights(members);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _scanReceipt() async {
    final l = context.l10n;
    final hid = ref.read(currentHouseholdIdProvider);
    if (hid == null) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await ImagePicker().pickImage(source: source, maxWidth: 2000, imageQuality: 80);
    if (file == null || !mounted) return;

    setState(() => _scanning = true);
    final repo = ref.read(receiptRepositoryProvider);
    final analytics = ref.read(analyticsProvider);
    try {
      final path = await repo.upload(hid, file);
      setState(() => _receiptPath = path);
      final r = await repo.scan(hid, path);
      analytics.receiptScanned(success: true);
      if (!mounted) return;
      setState(() {
        if (r.totalMinor != null) {
          _amount.text = Money.toInput(r.totalMinor!, locale: l.localeName);
        }
        if (r.merchant != null && _description.text.isEmpty) _description.text = r.merchant!;
        if (r.date != null) _date = r.date!;
        _receiptItems = r.items;
      });
      showMessage(context, l.receiptScanned);
    } on ReceiptTooLargeException {
      if (mounted) showMessage(context, l.receiptTooLarge);
    } catch (e, s) {
      analytics.receiptScanned(success: false);
      if (!mounted) return;
      if (errorCodeOf(e) == AppErrorCode.receiptQuota) {
        analytics.limitReached('receipt_scans');
        await context.push('${Routes.pro}?source=receipt_limit');
      } else if (_receiptPath != null) {
        // The photo stays attached; the user fills the form by hand.
        showMessage(context, l.receiptScanFailed);
        reportError(e, s);
      } else {
        showError(context, e, s);
      }
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _save(Household household) async {
    final l = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    final amount = Money.parse(_amount.text) ?? 0;
    final result = _split!.compute(amount);
    if (result is! SplitSuccess) {
      showMessage(context, l.fixSplitFirst);
      return;
    }
    final uid = ref.read(currentUidProvider)!;
    final repo = ref.read(expenseRepositoryProvider);
    final now = ref.read(clockProvider)();
    final expense = Expense(
      id: _existing?.id ?? repo.newExpenseId(household.id),
      description: _description.text.trim(),
      amountMinor: amount,
      paidBy: _paidBy!,
      date: _date,
      category: _category,
      splitType: _split!.type,
      splitInput: _split!.input()!,
      shares: result.shares,
      status: ExpenseStatus.finalized,
      recurringId: _existing?.recurringId,
      receiptPath: _receiptPath,
      receiptItems: _receiptItems,
      note: _note.text.trim(),
      createdBy: _existing?.createdBy ?? uid,
      createdAt: _existing?.createdAt ?? now,
      updatedAt: now,
    );
    setState(() => _saving = true);
    try {
      await repo.saveExpense(household.id, expense, actorUid: uid, existing: _existing);
      if (_existing == null) {
        ref.read(analyticsProvider).expenseAdded(expense.splitType.name, expense.category.name);
      }
      final shoppingIds = widget.draft?.shoppingItemIds ?? const [];
      if (shoppingIds.isNotEmpty) {
        await ref
            .read(shoppingRepositoryProvider)
            .markConverted(household.id, shoppingIds, uid: uid, expenseId: expense.id);
      }
      if (!mounted) return;
      final flags = ref.read(onceFlagsProvider);
      if (_existing == null && !flags.isSet(OnceFlags.proIntroShown)) {
        flags.set(OnceFlags.proIntroShown);
        context.pushReplacement('${Routes.pro}?source=first_expense');
      } else {
        context.pop();
      }
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    final members = ref.watch(activeMembersProvider);
    if (_isEdit) ref.watch(expenseByIdProvider(widget.expenseId!));
    if (household == null || !_ensureInitialized(members)) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final memberIds = {for (final m in members) m.id};
    // Past members stay selectable when editing an old expense.
    final payerOptions = [
      ...members,
      if (_paidBy != null && !memberIds.contains(_paidBy))
        ?ref.read(memberMapProvider)[_paidBy],
    ];
    final amount = Money.parse(_amount.text);
    final pending = _existing?.isPending ?? false;
    final dateText = DateFormat.yMMMd(l.localeName).format(_date);

    return Scaffold(
      appBar: AppBar(
        title: Text(pending
            ? l.enterBillAmount
            : _isEdit
                ? l.editExpense
                : l.addExpense),
        actions: [
          IconButton(
            tooltip: l.scanReceipt,
            onPressed: _scanning ? null : _scanReceipt,
            icon: const Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            if (_scanning) ...[
              const LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(l.receiptScanning, textAlign: TextAlign.center),
              ),
            ],
            AmountField(
              controller: _amount,
              currency: household.currency,
              large: true,
              autofocus: !_isEdit && widget.draft?.startWithReceipt != true,
              validator: (v) => (Money.parse(v ?? '') ?? 0) > 0 ? null : l.enterValidAmount,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.description),
              validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _paidBy,
              decoration: InputDecoration(labelText: l.paidBy),
              items: [
                for (final m in payerOptions)
                  DropdownMenuItem(
                    value: m.id,
                    child: Text('${m.avatarEmoji}  ${memberDisplayName(context, ref.read(memberMapProvider), m.id)}'),
                  ),
              ],
              onChanged: (v) => setState(() => _paidBy = v),
            ),
            const SizedBox(height: 16),
            Text(l.category, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ExpenseCategory.values)
                  ChoiceChip(
                    avatar: ExcludeSemantics(child: Text(c.emoji)),
                    label: Text(l.categoryName(c)),
                    selected: _category == c,
                    onSelected: (_) => _setCategory(c, members),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(l.date),
              subtitle: Text(dateText),
              onTap: _pickDate,
            ),
            SectionHeader(l.split),
            SplitEditor(
              controller: _split!,
              members: members,
              currency: household.currency,
              amountMinor: amount ?? 0,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              maxLines: 3,
              minLines: 1,
              maxLength: 500,
              decoration: InputDecoration(labelText: l.noteOptional),
            ),
            if (_receiptPath != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.receipt_outlined),
                title: Text(l.receiptAttached),
                subtitle: _receiptItems.isEmpty ? null : Text(l.receiptItemCount(_receiptItems.length)),
                trailing: IconButton(
                  tooltip: l.removeReceipt,
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _receiptPath = null;
                    _receiptItems = const [];
                  }),
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: _scanning ? null : _scanReceipt,
                icon: const Icon(Icons.document_scanner_outlined),
                label: Text(l.scanReceipt),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Saving stays disabled until the split adds up exactly.
          child: ListenableBuilder(
            listenable: _split!,
            builder: (context, _) {
              final valid = (amount ?? 0) > 0 && _split!.compute(amount!) is SplitSuccess;
              return FilledButton(
                onPressed: !valid || _saving || _scanning ? null : () => _save(household),
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l.save),
              );
            },
          ),
        ),
      ),
    );
  }
}
