import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/balance_calculator.dart';
import '../../../core/money/debt_simplifier.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/data/expense_repository.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';

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

/// Who can take part in a recorded payment: current members, plus anyone who
/// is no longer in the household (left, removed or deleted their account) but
/// still has a balance with it. Their past expenses stay, and editing one can
/// change their balance, so the others must be able to settle up with them.
final settleCandidatesProvider = Provider<List<Member>>((ref) {
  final nets = ref.watch(netBalancesProvider);
  final ids = ref.watch(currentHouseholdProvider).value?.memberIds ?? const [];
  final members = ref.watch(membersProvider).value ?? const [];
  return [
    for (final m in members)
      if (ids.contains(m.id) || (nets[m.id] ?? 0) != 0) m,
  ];
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
