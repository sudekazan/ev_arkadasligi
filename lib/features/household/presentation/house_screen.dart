import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/widgets/feedback.dart';
import '../../chores/presentation/chores_tab.dart';
import '../../recurring/presentation/recurring_tab.dart';
import '../../shopping/presentation/shopping_tab.dart';
import '../data/household_repository.dart';

/// "Ev" tab: shopping list, chores and recurring expenses.
class HouseScreen extends ConsumerWidget {
  const HouseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(household?.name ?? l.tabHouse),
          actions: [
            IconButton(
              tooltip: l.houseSettings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(Routes.houseSettings),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l.shoppingList),
              Tab(text: l.chores),
              Tab(text: l.recurringExpenses),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ShoppingTab(), ChoresTab(), RecurringTab()],
        ),
      ),
    );
  }
}
