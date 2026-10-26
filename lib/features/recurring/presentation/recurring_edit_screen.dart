import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/money/money.dart';
import '../../../core/money/split_calculator.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/domain/expense.dart';
import '../../expenses/presentation/split_editor.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';
import '../data/recurring_repository.dart';
import '../domain/recurring_template.dart';

/// Template: expense fields + frequency, day and fixed / variable amount.
class RecurringEditScreen extends ConsumerStatefulWidget {
  const RecurringEditScreen({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<RecurringEditScreen> createState() => _RecurringEditScreenState();
}

class _RecurringEditScreenState extends ConsumerState<RecurringEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  SplitController? _split;
  RecurringTemplate? _existing;
  String? _paidBy;
  ExpenseCategory _category = ExpenseCategory.rent;
  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;
  int _dayOfMonth = 1;
  int _dayOfWeek = DateTime.monday;
  bool _fixed = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _note.dispose();
    _split?.dispose();
    super.dispose();
  }

  bool _ensureInitialized(List<Member> members, List<RecurringTemplate>? templates) {
    if (_split != null) return true;
    if (members.isEmpty || (widget.templateId != null && templates == null)) return false;
    final locale = context.l10n.localeName;
    final split = SplitController(memberIds: [for (final m in members) m.id]);
    final t = widget.templateId == null
        ? null
        : templates!.where((t) => t.id == widget.templateId).firstOrNull;
    if (t != null) {
      _existing = t;
      _description.text = t.description;
      if (t.amountMinor > 0) _amount.text = Money.toInput(t.amountMinor, locale: locale);
      _note.text = t.note;
      _paidBy = t.paidBy;
      _category = t.category;
      _frequency = t.frequency;
      _dayOfMonth = t.dayOfMonth ?? 1;
      _dayOfWeek = t.dayOfWeek ?? DateTime.monday;
      _fixed = t.fixedAmount;
      split.load(t.splitType, t.splitInput, locale: locale);
    } else {
      _paidBy = ref.read(currentUidProvider);
      split.applyRentWeights(members);
    }
    _split = split;
    return true;
  }

  /// Variable templates store only ratios: exact amounts are not allowed and
  /// percentages must add up to 100%.
  String? _splitProblem(int? amount) {
    final l = context.l10n;
    final split = _split!;
    if (split.participants.isEmpty) return l.splitNoParticipants;
    if (_fixed) {
      if ((amount ?? 0) <= 0) return l.enterValidAmount;
      return split.compute(amount!) is SplitSuccess ? null : l.fixSplitFirst;
    }
    if (split.type == SplitType.exact) return l.variableNoExact;
    // Any positive amount validates percentages and weights.
    return split.compute(10000) is SplitSuccess ? null : l.fixSplitFirst;
  }

  Future<void> _save(Household household) async {
    if (!_formKey.currentState!.validate()) return;
    final amount = _fixed ? Money.parse(_amount.text) : 0;
    final problem = _splitProblem(amount);
    if (problem != null) {
      showMessage(context, problem);
      return;
    }
    final repo = ref.read(recurringRepositoryProvider);
    final now = ref.read(clockProvider)();
    final dayChanged = _existing == null ||
        _existing!.frequency != _frequency ||
        _existing!.dayOfMonth != _dayOfMonth ||
        _existing!.dayOfWeek != _dayOfWeek;
    final template = RecurringTemplate(
      id: _existing?.id ?? repo.newId(household.id),
      description: _description.text.trim(),
      amountMinor: amount ?? 0,
      paidBy: _paidBy!,
      category: _category,
      splitType: _split!.type,
      splitInput: _split!.input()!,
      note: _note.text.trim(),
      frequency: _frequency,
      dayOfMonth: _frequency == RecurrenceFrequency.monthly ? _dayOfMonth : null,
      dayOfWeek: _frequency == RecurrenceFrequency.weekly ? _dayOfWeek : null,
      fixedAmount: _fixed,
      nextRunAt: dayChanged
          ? firstRunDate(
              frequency: _frequency,
              dayOfMonth: _dayOfMonth,
              dayOfWeek: _dayOfWeek,
              from: now,
            )
          : _existing!.nextRunAt,
      active: _existing?.active ?? true,
      createdBy: _existing?.createdBy ?? ref.read(currentUidProvider)!,
      createdAt: _existing?.createdAt ?? now,
    );
    setState(() => _saving = true);
    try {
      await repo.save(household.id, template);
      if (mounted) context.pop();
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete(Household household) async {
    final l = context.l10n;
    final ok = await confirm(context,
        title: l.deleteRecurring,
        message: l.deleteRecurringBody(_existing!.description),
        confirmLabel: l.delete,
        destructive: true);
    if (!ok) return;
    await ref.read(recurringRepositoryProvider).delete(household.id, _existing!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    final members = ref.watch(activeMembersProvider);
    final templates = ref.watch(recurringTemplatesProvider).value;
    if (household == null || !_ensureInitialized(members, templates)) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final amount = Money.parse(_amount.text);
    final weekdays = DateFormat.EEEE(l.localeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l.addRecurring : l.editRecurring),
        actions: [
          if (_existing != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(household),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            TextFormField(
              controller: _description,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.description, hintText: l.recurringHint),
              validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.fixedAmount),
              subtitle: Text(_fixed ? l.fixedAmountHelp : l.variableAmountHelp),
              value: _fixed,
              onChanged: (v) => setState(() => _fixed = v),
            ),
            if (_fixed)
              AmountField(
                controller: _amount,
                currency: household.currency,
                label: l.amount,
                validator: (v) => (Money.parse(v ?? '') ?? 0) > 0 ? null : l.enterValidAmount,
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _paidBy,
              decoration: InputDecoration(labelText: l.paidBy),
              items: [
                for (final m in members)
                  DropdownMenuItem(value: m.id, child: Text('${m.avatarEmoji}  ${m.displayName}')),
              ],
              onChanged: (v) => setState(() => _paidBy = v),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ExpenseCategory.values)
                  ChoiceChip(
                    avatar: ExcludeSemantics(child: Text(c.emoji)),
                    label: Text(l.categoryName(c)),
                    selected: _category == c,
                    onSelected: (_) {
                      setState(() => _category = c);
                      if (c == ExpenseCategory.rent) _split!.applyRentWeights(members);
                    },
                  ),
              ],
            ),
            SectionHeader(l.schedule),
            SegmentedButton<RecurrenceFrequency>(
              segments: [
                for (final f in RecurrenceFrequency.values)
                  ButtonSegment(value: f, label: Text(l.recurrenceName(f))),
              ],
              selected: {_frequency},
              onSelectionChanged: (s) => setState(() => _frequency = s.first),
            ),
            const SizedBox(height: 12),
            if (_frequency == RecurrenceFrequency.monthly)
              DropdownButtonFormField<int>(
                initialValue: _dayOfMonth,
                decoration: InputDecoration(labelText: l.dayOfMonth, helperText: l.dayOfMonthHelp),
                items: [
                  for (var d = 1; d <= 31; d++) DropdownMenuItem(value: d, child: Text('$d')),
                ],
                onChanged: (v) => setState(() => _dayOfMonth = v ?? 1),
              )
            else
              DropdownButtonFormField<int>(
                initialValue: _dayOfWeek,
                decoration: InputDecoration(labelText: l.dayOfWeek),
                items: [
                  // 2024-01-01 was a Monday.
                  for (var d = 1; d <= 7; d++)
                    DropdownMenuItem(value: d, child: Text(weekdays.format(DateTime(2024, 1, d)))),
                ],
                onChanged: (v) => setState(() => _dayOfWeek = v ?? 1),
              ),
            SectionHeader(l.split),
            SplitEditor(
              controller: _split!,
              members: members,
              currency: household.currency,
              amountMinor: _fixed ? (amount ?? 0) : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              maxLength: 500,
              decoration: InputDecoration(labelText: l.noteOptional),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : () => _save(household),
            child: Text(l.save),
          ),
        ),
      ),
    );
  }
}
