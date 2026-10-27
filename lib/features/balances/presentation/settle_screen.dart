import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/data/expense_repository.dart';
import '../../expenses/domain/expense.dart';
import '../../household/data/household_repository.dart';
import '../data/balance_providers.dart';

/// "Ödeme yapıldı": from, to, amount (suggested amount prefilled), IBAN copy.
class SettleScreen extends ConsumerStatefulWidget {
  const SettleScreen({super.key, this.fromUid, this.toUid, this.amountMinor});

  final String? fromUid;
  final String? toUid;
  final int? amountMinor;

  @override
  ConsumerState<SettleScreen> createState() => _SettleScreenState();
}

class _SettleScreenState extends ConsumerState<SettleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String? _from;
  String? _to;
  bool _saving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  /// The simplified-debt amount between the selected pair, if any.
  int? _suggested() {
    for (final t in ref.read(simplifiedDebtsProvider)) {
      if (t.fromUid == _from && t.toUid == _to) return t.amountMinor;
    }
    return null;
  }

  void _refillSuggested() {
    final s = _suggested();
    if (s != null) _amount.text = Money.toInput(s, locale: context.l10n.localeName);
  }

  Future<void> _save(String hid) async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUidProvider)!;
    final now = ref.read(clockProvider)();
    setState(() => _saving = true);
    try {
      await ref.read(expenseRepositoryProvider).addSettlement(
            hid,
            Settlement(
              id: '',
              fromUid: _from!,
              toUid: _to!,
              amountMinor: Money.parse(_amount.text)!,
              date: now,
              note: _note.text.trim(),
              createdBy: uid,
              createdAt: now,
            ),
          );
      if (mounted) {
        showMessage(context, context.l10n.paymentRecorded);
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
    final uid = ref.watch(currentUidProvider);
    // The suggested amount is filled once, so wait for balances to load.
    final loading = ref.watch(balancesLoadingProvider);
    if (household == null || members.isEmpty || uid == null || loading) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    if (!_initialized) {
      _initialized = true;
      _from = widget.fromUid ?? uid;
      _to = widget.toUid ?? members.firstWhere((m) => m.id != _from, orElse: () => members.first).id;
      final amount = widget.amountMinor ?? _suggested();
      if (amount != null) _amount.text = Money.toInput(amount, locale: l.localeName);
    }
    final isAdmin = household.isAdmin(uid);
    final recipient = ref.watch(memberMapProvider)[_to];
    final iban = recipient?.iban;

    DropdownButtonFormField<String> picker(String label, String? value, ValueChanged<String?> onChanged) =>
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(labelText: label),
          items: [
            for (final m in members)
              DropdownMenuItem(
                value: m.id,
                child: Text('${m.avatarEmoji}  ${m.id == uid ? l.youSuffix(m.displayName) : m.displayName}'),
              ),
          ],
          onChanged: onChanged,
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.recordPayment)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            picker(l.from, _from, (v) => setState(() {
                  _from = v;
                  _refillSuggested();
                })),
            const SizedBox(height: 12),
            picker(l.to, _to, (v) => setState(() {
                  _to = v;
                  _refillSuggested();
                })),
            const SizedBox(height: 24),
            AmountField(
              controller: _amount,
              currency: household.currency,
              large: true,
              validator: (v) {
                if ((Money.parse(v ?? '') ?? 0) <= 0) return l.enterValidAmount;
                if (_from == _to) return l.samePersonError;
                if (!isAdmin && _from != uid && _to != uid) return l.paymentMustInvolveYou;
                return null;
              },
            ),
            Text(l.partialPaymentHint,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            if (iban != null && iban.isNotEmpty)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_outlined),
                  title: Text(l.recipientIban(recipient!.displayName)),
                  subtitle: SelectableText(iban),
                  trailing: IconButton(
                    tooltip: l.copyIban,
                    icon: const Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: iban.replaceAll(' ', '')));
                      if (context.mounted) showMessage(context, l.ibanCopied);
                    },
                  ),
                ),
              )
            else if (recipient != null)
              Text(l.noIbanYet(recipient.displayName), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              maxLength: 200,
              decoration: InputDecoration(labelText: l.noteOptional),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : () => _save(household.id),
            child: _saving
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l.markAsPaid),
          ),
        ),
      ),
    );
  }
}
