import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/balance_calculator.dart';
import '../../../core/money/debt_simplifier.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/data/expense_repository.dart';
import '../../household/data/household_repository.dart';

/// Net balance per uid for the current household; every current member is
/// present, with 0 when settled.
final netBalancesProvider = Provider<Map<String, int>>((ref) {
  final expenses = ref.watch(expensesProvider).value ?? const [];
  final settlements = ref.watch(settlementsProvider).value ?? const [];
  final memberIds = ref.watch(currentHouseholdProvider).value?.memberIds ?? const [];
  final nets = BalanceCalculator.nets(
    expenses.map((e) => e.toLedger()),
    settlements.map((s) => s.toLedger()),
  );
  return {for (final uid in memberIds) uid: 0, ...nets};
});

final simplifiedDebtsProvider = Provider<List<Transfer>>(
  (ref) => DebtSimplifier.simplify(ref.watch(netBalancesProvider)),
);

final myNetBalanceProvider = Provider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  return ref.watch(netBalancesProvider)[uid] ?? 0;
});

/// Whether balances are still loading (so the home card can show a skeleton).
final balancesLoadingProvider = Provider<bool>(
  (ref) => ref.watch(expensesProvider).isLoading || ref.watch(settlementsProvider).isLoading,
);
