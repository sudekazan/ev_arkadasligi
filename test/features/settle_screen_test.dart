import 'dart:async';

import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:evarkadasligi/features/balances/presentation/settle_screen.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  const iban = 'TR33 0006 1005 1978 6457 8413 26';
  final members = [member('a', 'Ayşe', iban: iban), member('b', 'Burak')];
  // Ayşe paid 300,00 ₺ split equally, so Burak owes her 150,00 ₺.
  final expenses = [
    Expense(
      id: 'e1',
      description: 'Market',
      amountMinor: 30000,
      paidBy: 'a',
      date: testNow,
      splitType: SplitType.equal,
      shares: const {'a': 15000, 'b': 15000},
      createdBy: 'a',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  Future<FakeExpenseRepository> open(WidgetTester tester) async {
    final repo = FakeExpenseRepository();
    await pumpScreen(
      tester,
      const SettleScreen(),
      uid: 'b',
      members: members,
      repo: repo,
      expenses: expenses,
    );
    return repo;
  }

  Finder amountField() => find.byType(TextFormField).first;

  testWidgets('prefills the simplified debt and records the payment', (tester) async {
    final repo = await open(tester);
    final l = l10nOf(tester);

    expect(tester.widget<TextFormField>(amountField()).controller!.text, '150');

    await tester.tap(find.widgetWithText(FilledButton, l.markAsPaid));
    await tester.pumpAndSettle();

    expect(repo.settlements, hasLength(1));
    final s = repo.settlements.single;
    expect(s.fromUid, 'b');
    expect(s.toUid, 'a');
    expect(s.amountMinor, 15000);
    expect(s.createdBy, 'b');
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('records a partial payment', (tester) async {
    final repo = await open(tester);

    await tester.enterText(amountField(), '40,50');
    await tester.tap(find.widgetWithText(FilledButton, l10nOf(tester).markAsPaid));
    await tester.pumpAndSettle();

    expect(repo.settlements.single.amountMinor, 4050);
  });

  testWidgets('rejects a zero amount', (tester) async {
    final repo = await open(tester);
    final l = l10nOf(tester);

    await tester.enterText(amountField(), '0');
    await tester.tap(find.widgetWithText(FilledButton, l.markAsPaid));
    await tester.pumpAndSettle();

    expect(find.text(l.enterValidAmount), findsOneWidget);
    expect(repo.settlements, isEmpty);
  });

  testWidgets("copies the recipient's IBAN without spaces", (tester) async {
    await open(tester);
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await tester.tap(find.byTooltip(l10nOf(tester).copyIban));
    await tester.pumpAndSettle();

    expect(copied, iban.replaceAll(' ', ''));
  });

  group('deleted member', () {
    final gone = deletedMember('gone');

    Expense expenseOf(String paidBy, Map<String, int> shares) => Expense(
          id: 'g1',
          description: 'Kira',
          amountMinor: shares.values.fold(0, (a, b) => a + b),
          paidBy: paidBy,
          date: testNow,
          splitType: SplitType.equal,
          shares: shares,
          createdBy: 'a',
          createdAt: testNow,
          updatedAt: testNow,
        );

    Future<FakeExpenseRepository> openWith(WidgetTester tester, List<Expense> expenses,
        {String? toUid}) async {
      final repo = FakeExpenseRepository();
      await pumpScreen(
        tester,
        SettleScreen(toUid: toUid),
        uid: 'b',
        members: [...members, gone],
        memberIds: ['a', 'b'],
        repo: repo,
        expenses: expenses,
      );
      return repo;
    }

    testWidgets('deleted member with a balance can be picked as recipient', (tester) async {
      // The deleted user paid 200,00 ₺ split with Burak, so Burak owes them 100,00 ₺.
      final repo = await openWith(tester, [expenseOf('gone', {'gone': 10000, 'b': 10000})], toUid: 'gone');
      final l = l10nOf(tester);

      expect(tester.takeException(), isNull);
      expect(find.textContaining(l.deletedUser), findsOneWidget);
      // The profile is blanked, so no "has not added an IBAN" hint with an empty name.
      expect(find.text(l.noIbanYet('')), findsNothing);
      expect(tester.widget<TextFormField>(amountField()).controller!.text, '100');

      await tester.tap(find.widgetWithText(FilledButton, l.markAsPaid));
      await tester.pumpAndSettle();

      final s = repo.settlements.single;
      expect(s.fromUid, 'b');
      expect(s.toUid, 'gone');
      expect(s.amountMinor, 10000);
    });

    testWidgets('keeps the selected deleted member listed when their balance reaches zero',
        (tester) async {
      final expenses = StreamController<List<Expense>>();
      addTearDown(expenses.close);
      // Burak owes the deleted user 100,00 ₺ ...
      final owed = expenseOf('gone', {'gone': 10000, 'b': 10000});
      expenses.add([owed]);
      await pumpScreen(
        tester,
        const SettleScreen(toUid: 'gone'),
        uid: 'b',
        members: [...members, gone],
        memberIds: ['a', 'b'],
        repo: FakeExpenseRepository(),
        expensesStream: expenses.stream,
      );
      final l = l10nOf(tester);
      expect(find.textContaining(l.deletedUser), findsOneWidget);

      // ... then an expense Burak paid for both evens it out while the screen is open.
      expenses.add([owed, expenseOf('b', {'gone': 10000, 'b': 10000})]);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining(l.deletedUser), findsOneWidget);
    });

    testWidgets('deleted member with a zero balance is not offered', (tester) async {
      // They only paid for themselves, so nobody owes them anything.
      await openWith(tester, [expenseOf('gone', {'gone': 10000})]);
      final l = l10nOf(tester);

      await tester.tap(find.byType(DropdownButtonFormField<String>).last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Ayşe'), findsWidgets); // the menu is open
      expect(find.textContaining(l.deletedUser), findsNothing);
    });
  });
}
