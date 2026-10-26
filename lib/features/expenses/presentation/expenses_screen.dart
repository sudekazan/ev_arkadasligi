import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';
import '../data/expense_repository.dart';
import '../domain/expense.dart';

/// Expenses grouped by month, with category / person filters and search.
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _search = TextEditingController();
  ExpenseCategory? _category;
  String? _person;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Expense> _filter(List<Expense> all) {
    final q = _search.text.trim().toLowerCase();
    return all.where((e) {
      if (_category != null && e.category != _category) return false;
      if (_person != null && e.paidBy != _person && !e.shares.containsKey(_person)) return false;
      if (q.isNotEmpty && !e.description.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    final expensesAsync = ref.watch(expensesProvider);
    final members = ref.watch(memberMapProvider);
    final active = ref.watch(activeMembersProvider);
    final filtering = _category != null || _person != null || _search.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabExpenses),
        actions: [
          IconButton(
            tooltip: l.reports,
            icon: const Icon(Icons.pie_chart_outline),
            onPressed: () => context.push(Routes.reports),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-expense-list',
        onPressed: () => context.push(Routes.expenseNew),
        icon: const Icon(Icons.add),
        label: Text(l.addExpense),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: l.searchExpenses,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (_) => setState(() {}),
              trailing: [
                if (_search.text.isNotEmpty)
                  IconButton(
                    tooltip: l.clear,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(_search.clear),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterMenu<ExpenseCategory>(
                  label: _category == null ? l.allCategories : l.categoryName(_category!),
                  selected: _category != null,
                  options: {for (final c in ExpenseCategory.values) c: '${c.emoji}  ${l.categoryName(c)}'},
                  onSelected: (c) => setState(() => _category = c),
                  clearLabel: l.allCategories,
                ),
                const SizedBox(width: 8),
                _FilterMenu<String>(
                  label: _person == null ? l.everyone : memberDisplayName(context, members, _person!),
                  selected: _person != null,
                  options: {for (final m in active) m.id: '${m.avatarEmoji}  ${m.displayName}'},
                  onSelected: (p) => setState(() => _person = p),
                  clearLabel: l.everyone,
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncBody(
              value: expensesAsync,
              data: (all) {
                if (household == null) return const SizedBox.shrink();
                if (all.isEmpty) {
                  return EmptyState(
                    emoji: '🧾',
                    title: l.noExpensesTitle,
                    message: l.noExpensesBody,
                    actionLabel: l.addExpense,
                    onAction: () => context.push(Routes.expenseNew),
                  );
                }
                final list = _filter(all);
                if (list.isEmpty && filtering) {
                  return EmptyState(
                    emoji: '🔍',
                    title: l.noResultsTitle,
                    message: l.noResultsBody,
                    actionLabel: l.clearFilters,
                    onAction: () => setState(() {
                      _category = null;
                      _person = null;
                      _search.clear();
                    }),
                  );
                }
                return _GroupedList(expenses: list, household: household, members: members);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterMenu<T> extends StatelessWidget {
  const _FilterMenu({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
    required this.clearLabel,
  });

  final String label;
  final bool selected;
  final Map<T, String> options;
  final ValueChanged<T?> onSelected;
  final String clearLabel;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(onPressed: () => onSelected(null), child: Text(clearLabel)),
        for (final MapEntry(:key, :value) in options.entries)
          MenuItemButton(onPressed: () => onSelected(key), child: Text(value)),
      ],
      builder: (context, controller, _) => FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => controller.isOpen ? controller.close() : controller.open(),
        avatar: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

class _GroupedList extends ConsumerWidget {
  const _GroupedList({required this.expenses, required this.household, required this.members});

  final List<Expense> expenses;
  final Household household;
  final Map<String, Member> members;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final monthFormat = DateFormat.yMMMM(l.localeName);
    final groups = <DateTime, List<Expense>>{};
    for (final e in expenses) {
      groups.putIfAbsent(DateTime(e.date.year, e.date.month), () => []).add(e);
    }
    final months = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: months.length,
      itemBuilder: (context, i) {
        final month = months[i];
        final items = groups[month]!;
        final total = items.where((e) => !e.isPending).fold(0, (s, e) => s + e.amountMinor);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              monthFormat.format(month),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MoneyText(total, currency: household.currency,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            ),
            for (final e in items) ExpenseTile(expense: e, household: household, members: members),
          ],
        );
      },
    );
  }
}

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({super.key, required this.expense, required this.household, required this.members});

  final Expense expense;
  final Household household;
  final Map<String, Member> members;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(currentUidProvider);
    final theme = Theme.of(context);
    final myShare = expense.shares[uid];
    final date = DateFormat.MMMd(l.localeName).format(expense.date);
    final payer = memberDisplayName(context, members, expense.paidBy);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: ExcludeSemantics(child: Text(expense.category.emoji)),
      ),
      title: Text(expense.description, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(expense.isPending ? l.pendingAmount : l.paidByOn(payer, date)),
      trailing: expense.isPending
          ? Chip(label: Text(l.enterAmount))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MoneyText(expense.amountMinor,
                    currency: household.currency, style: theme.textTheme.titleSmall),
                if (myShare != null)
                  Text(
                    l.yourShare(formatMoney(context, myShare, household.currency)),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
      onTap: () => context.push(
        expense.isPending ? Routes.expenseEdit(expense.id) : Routes.expenseDetail(expense.id),
      ),
    );
  }
}
