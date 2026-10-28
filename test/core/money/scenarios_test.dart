import 'dart:math';

import 'package:evarkadasligi/core/money/balance_calculator.dart';
import 'package:evarkadasligi/core/money/debt_simplifier.dart';
import 'package:evarkadasligi/core/money/money.dart';
import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

/// PLAN.md test scenarios T1–T10. A, B, C are uids in alphabetical order.
void main() {
  Map<String, int> shares(SplitType type, int amount, Map<String, int> input) {
    final result = SplitCalculator.compute(type: type, amountMinor: amount, input: input);
    expect(result, isA<SplitSuccess>());
    return (result as SplitSuccess).shares;
  }

  LedgerExpense expense(String paidBy, int amount, SplitType type, Map<String, int> input,
          {bool isFinal = true}) =>
      LedgerExpense(
        paidBy: paidBy,
        amountMinor: amount,
        shares: isFinal ? shares(type, amount, input) : const {},
        isFinal: isFinal,
      );

  final equalABC = {'A': 1, 'B': 1, 'C': 1};
  List<LedgerExpense> t6Expenses() => [
    expense('A', 90000, SplitType.equal, equalABC),
    expense('B', 30000, SplitType.equal, equalABC),
  ];

  test('T1: 100,00 equal between A, B, C', () {
    expect(shares(SplitType.equal, 10000, equalABC), {'A': 3334, 'B': 3333, 'C': 3333});
  });

  test('T2: 15.000,00 rent by weights 3/2/2', () {
    expect(
      shares(SplitType.shares, 1500000, {'A': 3, 'B': 2, 'C': 2}),
      {'A': 642857, 'B': 428572, 'C': 428571},
    );
  });

  test('T3: 250,00 by percent 50/30/20', () {
    expect(
      shares(SplitType.percent, 25000, {'A': 5000, 'B': 3000, 'C': 2000}),
      {'A': 12500, 'B': 7500, 'C': 5000},
    );
  });

  test('T4: 100,01 by percent 33,33/33,33/33,34', () {
    expect(
      shares(SplitType.percent, 10001, {'A': 3333, 'B': 3333, 'C': 3334}),
      {'A': 3333, 'B': 3333, 'C': 3335},
    );
  });

  test('T5: exact amounts 10,00 short are rejected', () {
    final result = SplitCalculator.compute(
      type: SplitType.exact,
      amountMinor: 30000,
      input: {'A': 10000, 'B': 15000, 'C': 4000},
    );
    expect(result, isA<SplitFailure>());
    final failure = result as SplitFailure;
    expect(failure.error, SplitError.exactSumMismatch);
    expect(failure.difference, 1000);
    expect(Money.format(failure.difference, currency: 'TRY', locale: 'tr'), '10,00 ₺');
  });

  test('T6: nets and simplified transfers', () {
    final nets = BalanceCalculator.nets(t6Expenses(), const []);
    expect(nets, {'A': 50000, 'B': -10000, 'C': -40000});
    expect(DebtSimplifier.simplify(nets), const [
      Transfer(fromUid: 'C', toUid: 'A', amountMinor: 40000),
      Transfer(fromUid: 'B', toUid: 'A', amountMinor: 10000),
    ]);
  });

  test('T7: T6 + C pays A 400,00', () {
    final nets = BalanceCalculator.nets(t6Expenses(), const [
      LedgerSettlement(fromUid: 'C', toUid: 'A', amountMinor: 40000),
    ]);
    expect(nets, {'A': 10000, 'B': -10000, 'C': 0});
    expect(DebtSimplifier.simplify(nets), const [
      Transfer(fromUid: 'B', toUid: 'A', amountMinor: 10000),
    ]);
  });

  test('T8: chained exact expenses collapse into one transfer', () {
    final nets = BalanceCalculator.nets([
      expense('B', 5000, SplitType.exact, {'A': 5000}),
      expense('C', 5000, SplitType.exact, {'B': 5000}),
    ], const []);
    expect(nets, {'A': -5000, 'B': 0, 'C': 5000});
    expect(DebtSimplifier.simplify(nets), const [
      Transfer(fromUid: 'A', toUid: 'C', amountMinor: 5000),
    ]);
  });

  test('T9: pending-amount bills do not affect balances', () {
    final withPending = [
      ...t6Expenses(),
      const LedgerExpense(paidBy: 'C', amountMinor: 0, shares: {}, isFinal: false),
      // A draft that already carries numbers must still be ignored.
      const LedgerExpense(
          paidBy: 'C', amountMinor: 999, shares: {'A': 999}, isFinal: false),
    ];
    expect(
      BalanceCalculator.nets(withPending, const []),
      BalanceCalculator.nets(t6Expenses(), const []),
    );
  });

  test('unbalanced expenses written around the app do not move balances', () {
    final withForged = [
      ...t6Expenses(),
      // Shares larger than the amount, negative shares, no shares at all.
      const LedgerExpense(paidBy: 'A', amountMinor: 1000, shares: {'B': 1000000}),
      const LedgerExpense(paidBy: 'A', amountMinor: 1000, shares: {'A': 2000, 'B': -1000}),
      const LedgerExpense(paidBy: 'A', amountMinor: 1000, shares: {}),
      const LedgerExpense(paidBy: 'A', amountMinor: 0, shares: {'A': 0}),
    ];
    expect(
      BalanceCalculator.nets(withForged, const []),
      BalanceCalculator.nets(t6Expenses(), const []),
    );
  });

  test('T10: random 200-expense household keeps every kuruş', () {
    final random = Random(20261026);
    final uids = ['ayse', 'burak', 'cem', 'deniz', 'ece', 'fatma'];
    final expenses = <LedgerExpense>[];
    for (var i = 0; i < 200; i++) {
      final amount = 1 + random.nextInt(5000000);
      final participants = uids.where((_) => random.nextBool()).toList();
      if (participants.isEmpty) participants.add(uids[random.nextInt(uids.length)]);
      final type = SplitType.values[random.nextInt(SplitType.values.length)];
      final Map<String, int> input;
      switch (type) {
        case SplitType.equal:
          input = {for (final u in participants) u: 1};
        case SplitType.shares:
          input = {for (final u in participants) u: 1 + random.nextInt(5)};
        case SplitType.percent:
          var left = SplitCalculator.percentTotal;
          input = {};
          for (var j = 0; j < participants.length; j++) {
            final last = j == participants.length - 1;
            final v = last ? left : random.nextInt(left + 1);
            input[participants[j]] = v;
            left -= v;
          }
        case SplitType.exact:
          var left = amount;
          input = {};
          for (var j = 0; j < participants.length; j++) {
            final last = j == participants.length - 1;
            final v = last ? left : random.nextInt(left + 1);
            input[participants[j]] = v;
            left -= v;
          }
      }
      final result = SplitCalculator.compute(type: type, amountMinor: amount, input: input);
      final s = (result as SplitSuccess).shares;
      expect(s.values.fold(0, (a, b) => a + b), amount, reason: 'expense $i ($type)');
      expenses.add(LedgerExpense(
        paidBy: uids[random.nextInt(uids.length)],
        amountMinor: amount,
        shares: s,
      ));
    }
    final settlements = [
      for (var i = 0; i < 30; i++)
        LedgerSettlement(
          fromUid: uids[i % uids.length],
          toUid: uids[(i + 1) % uids.length],
          amountMinor: 1 + random.nextInt(100000),
        ),
    ];
    final nets = BalanceCalculator.nets(expenses, settlements);
    expect(nets.values.fold(0, (a, b) => a + b), 0);

    final transfers = DebtSimplifier.simplify(nets);
    expect(transfers.length, lessThan(uids.length));
    final after = Map<String, int>.of(nets);
    for (final t in transfers) {
      after[t.fromUid] = after[t.fromUid]! + t.amountMinor;
      after[t.toUid] = after[t.toUid]! - t.amountMinor;
    }
    expect(after.values.every((v) => v == 0), isTrue);
  });
}
