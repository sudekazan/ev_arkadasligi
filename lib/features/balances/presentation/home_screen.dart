import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../core/money/debt_simplifier.dart';
import '../../../core/utils/turkish.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../activity/data/activity_repository.dart';
import '../../activity/presentation/activity_tile.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/data/expense_repository.dart';
import '../../expenses/domain/expense.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';
import '../data/balance_providers.dart';

/// Net balance card, simplified debts, pending bills, payments, recent activity.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    final households = ref.watch(myHouseholdsProvider).value ?? const [];
    if (household == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final transfers = ref.watch(simplifiedDebtsProvider);
    final pending = ref.watch(pendingBillsProvider);
    final settlements = ref.watch(settlementsProvider).value ?? const [];
    final activity = ref.watch(recentActivityProvider).value ?? const [];
    final expenses = ref.watch(expensesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: households.length > 1
            ? _HouseholdSwitcher(current: household, households: households)
            : Text(household.name),
        actions: [
          IconButton(
            tooltip: l.activity,
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.activity),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-expense-home',
        onPressed: () => context.push(Routes.expenseNew),
        icon: const Icon(Icons.add),
        label: Text(l.addExpense),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _BalanceCard(household: household, transfers: transfers),
          ),
          if (expenses.isEmpty && !ref.watch(balancesLoadingProvider))
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(l.homeEmptyTitle, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(l.homeEmptyBody, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () => context.push(Routes.houseSettings),
                        child: Text(l.inviteHousemates),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (transfers.isNotEmpty) ...[
            SectionHeader(l.whoOwesWhom),
            for (final t in transfers) _TransferTile(transfer: t, household: household),
          ],
          if (pending.isNotEmpty) ...[
            SectionHeader(l.pendingBills),
            for (final e in pending) _PendingBillTile(expense: e),
          ],
          if (settlements.isNotEmpty) ...[
            SectionHeader(l.recentPayments),
            for (final s in settlements.take(3)) _SettlementTile(settlement: s, household: household),
          ],
          SectionHeader(
            l.recentActivity,
            trailing: TextButton(
              onPressed: () => context.push(Routes.activity),
              child: Text(l.seeAll),
            ),
          ),
          if (activity.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l.noActivityBody),
            ),
          for (final a in activity) ActivityTile(event: a, currency: household.currency),
        ],
      ),
    );
  }
}

class _HouseholdSwitcher extends ConsumerWidget {
  const _HouseholdSwitcher({required this.current, required this.households});

  final Household current;
  final List<Household> households;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: context.l10n.switchHousehold,
      onSelected: (hid) => ref.read(selectedHouseholdProvider.notifier).select(hid),
      itemBuilder: (_) => [
        for (final h in households)
          CheckedPopupMenuItem(value: h.id, checked: h.id == current.id, child: Text(h.name)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(current.name, overflow: TextOverflow.ellipsis)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard({required this.household, required this.transfers});

  final Household household;
  final List<Transfer> transfers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    final net = ref.watch(myNetBalanceProvider);
    final members = ref.watch(memberMapProvider);
    final loading = ref.watch(balancesLoadingProvider);
    String name(String id) => memberDisplayName(context, members, id);
    String money(int v) => formatMoney(context, v, household.currency);
    final turkish = l.localeName.startsWith('tr');

    final mine = transfers.where((t) => t.fromUid == uid).toList();
    final toMe = transfers.where((t) => t.toUid == uid).toList();
    final String headline;
    if (net < 0) {
      headline = mine.length == 1
          ? l.youOweOne(turkish ? Turkish.dative(name(mine.first.toUid)) : name(mine.first.toUid),
              money(-net))
          : l.youOweTotal(money(-net));
    } else if (net > 0) {
      headline = toMe.length == 1
          ? l.owesYouOne(name(toMe.first.fromUid), money(net))
          : l.theyOweYouTotal(money(net));
    } else {
      headline = l.allSettled;
    }
    final status = net < 0 ? l.statusOwe : (net > 0 ? l.statusOwed : l.statusSettled);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: loading
            ? const SizedBox(height: 96, child: Center(child: CircularProgressIndicator()))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                  const SizedBox(height: 4),
                  MoneyText(
                    net.abs(),
                    currency: household.currency,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: net == 0
                          ? theme.colorScheme.onPrimaryContainer
                          : context.moneyColors.forBalance(net),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(headline,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                ],
              ),
      ),
    );
  }
}

class _TransferTile extends ConsumerStatefulWidget {
  const _TransferTile({required this.transfer, required this.household});

  final Transfer transfer;
  final Household household;

  @override
  ConsumerState<_TransferTile> createState() => _TransferTileState();
}

class _TransferTileState extends ConsumerState<_TransferTile> {
  bool _sending = false;

  Future<void> _remind() async {
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      await ref
          .read(householdRepositoryProvider)
          .sendReminder(widget.household.id, widget.transfer.fromUid);
      if (mounted) showMessage(context, l.reminderSent);
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = widget.transfer;
    final uid = ref.watch(currentUidProvider);
    final members = ref.watch(memberMapProvider);
    String name(String id) => id == uid ? l.you : memberDisplayName(context, members, id);
    final amount = formatMoney(context, t.amountMinor, widget.household.currency);

    Widget? action;
    if (t.fromUid == uid) {
      action = FilledButton.tonal(
        onPressed: () => context.push(
            '${Routes.settle}?from=${t.fromUid}&to=${t.toUid}&amount=${t.amountMinor}'),
        child: Text(l.pay),
      );
    } else if (t.toUid == uid) {
      action = OutlinedButton(
        onPressed: _sending ? null : _remind,
        child: Text(l.remind),
      );
    }
    final color = t.fromUid == uid
        ? context.moneyColors.owe
        : (t.toUid == uid ? context.moneyColors.owed : null);
    return ListTile(
      leading: MemberAvatar(emoji: members[t.fromUid]?.avatarEmoji ?? '👤'),
      title: Text(l.transferLine(name(t.fromUid), name(t.toUid))),
      subtitle: Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      trailing: action,
      onTap: t.fromUid != uid && t.toUid != uid
          ? () => context.push(
              '${Routes.settle}?from=${t.fromUid}&to=${t.toUid}&amount=${t.amountMinor}')
          : null,
    );
  }
}

class _PendingBillTile extends StatelessWidget {
  const _PendingBillTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListTile(
      leading: CircleAvatar(child: ExcludeSemantics(child: Text(expense.category.emoji))),
      title: Text(expense.description),
      subtitle: Text(DateFormat.yMMMd(l.localeName).format(expense.date)),
      trailing: FilledButton.tonal(
        onPressed: () => context.push(Routes.expenseEdit(expense.id)),
        child: Text(l.enterAmount),
      ),
    );
  }
}

class _SettlementTile extends ConsumerWidget {
  const _SettlementTile({required this.settlement, required this.household});

  final Settlement settlement;
  final Household household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(currentUidProvider);
    final members = ref.watch(memberMapProvider);
    final s = settlement;
    String name(String id) => id == uid ? l.you : memberDisplayName(context, members, id);
    final canDelete = uid == s.fromUid || uid == s.toUid || (uid != null && household.isAdmin(uid));

    Future<void> delete() async {
      final ok = await confirm(
        context,
        title: l.disputePayment,
        message: l.disputePaymentBody(formatMoney(context, s.amountMinor, household.currency)),
        confirmLabel: l.delete,
        destructive: true,
      );
      if (!ok) return;
      try {
        await ref.read(expenseRepositoryProvider).deleteSettlement(household.id, s, actorUid: uid!);
      } catch (e, st) {
        if (context.mounted) showError(context, e, st);
      }
    }

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.payments_outlined)),
      title: Text(l.transferLine(name(s.fromUid), name(s.toUid))),
      subtitle: Text(
          '${formatMoney(context, s.amountMinor, household.currency)} · ${DateFormat.MMMd(l.localeName).format(s.date)}'),
      trailing: canDelete
          ? IconButton(
              tooltip: l.disputePayment,
              icon: const Icon(Icons.undo),
              onPressed: delete,
            )
          : null,
    );
  }
}
