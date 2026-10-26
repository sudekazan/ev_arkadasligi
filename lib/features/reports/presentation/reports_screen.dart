import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/data/expense_repository.dart';
import '../../expenses/domain/expense.dart';
import '../../household/data/household_repository.dart';
import '../../pro/data/pro_service.dart';

/// Monthly summary by category. Free: the current month; Pro: all history.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late DateTime _month = _monthOf(ref.read(clockProvider)());

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);

  void _shift(int delta, bool isPro) {
    final target = DateTime(_month.year, _month.month + delta);
    final current = _monthOf(ref.read(clockProvider)());
    if (target.isAfter(current)) return;
    if (!isPro && target.isBefore(current)) {
      context.push('${Routes.pro}?source=reports');
      return;
    }
    setState(() => _month = target);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final isPro = ref.watch(householdIsProProvider);
    final household = ref.watch(currentHouseholdProvider).value;
    final uid = ref.watch(currentUidProvider);
    final all = ref.watch(expensesProvider).value ?? const <Expense>[];
    final currency = household?.currency ?? 'TRY';
    final inMonth = all
        .where((e) => !e.isPending && e.date.year == _month.year && e.date.month == _month.month)
        .toList();
    final total = inMonth.fold(0, (s, e) => s + e.amountMinor);
    final myTotal = inMonth.fold(0, (s, e) => s + (e.shares[uid] ?? 0));
    final byCategory = <ExpenseCategory, int>{};
    for (final e in inMonth) {
      byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amountMinor;
    }
    final rows = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final isCurrent = _month == _monthOf(ref.read(clockProvider)());

    return Scaffold(
      appBar: AppBar(title: Text(l.reports)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.previousMonth,
                icon: Icon(isPro ? Icons.chevron_left : Icons.lock_outline),
                onPressed: () => _shift(-1, isPro),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(l.localeName).format(_month),
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                tooltip: l.nextMonth,
                icon: const Icon(Icons.chevron_right),
                onPressed: isCurrent ? null : () => _shift(1, isPro),
              ),
            ],
          ),
          if (!isPro)
            Text(l.reportsFreeLimit, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatCard(label: l.householdTotal, minor: total, currency: currency)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: l.myShareTotal, minor: myTotal, currency: currency)),
            ],
          ),
          const SizedBox(height: 16),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(l.noExpensesThisMonth, textAlign: TextAlign.center),
            ),
          for (final MapEntry(key: category, value: amount) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(child: Text(category.emoji)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(l.categoryName(category))),
                      MoneyText(amount, currency: currency),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : amount / total,
                      minHeight: 8,
                      semanticsLabel: l.categoryName(category),
                      semanticsValue: '${(amount * 100 / total).round()}%',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.minor, required this.currency});

  final String label;
  final int minor;
  final String currency;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: MoneyText(minor,
                    currency: currency, style: Theme.of(context).textTheme.titleLarge),
              ),
            ],
          ),
        ),
      );
}
