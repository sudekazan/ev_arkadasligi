import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/expenses/presentation/expense_edit_screen.dart';
import 'package:evarkadasligi/features/settings/data/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  final members = [member('a', 'Ayşe'), member('b', 'Burak'), member('c', 'Cem')];

  Future<FakeExpenseRepository> open(WidgetTester tester, {bool proIntroShown = true}) async {
    final repo = FakeExpenseRepository();
    await pumpScreen(
      tester,
      const ExpenseEditScreen(),
      uid: 'a',
      members: members,
      repo: repo,
      prefs: {OnceFlags.proIntroShown: proIntroShown},
    );
    return repo;
  }

  Finder saveButton(WidgetTester tester) =>
      find.widgetWithText(FilledButton, l10nOf(tester).save);

  testWidgets('saves an equal split with the remainder kuruş to the first uid', (tester) async {
    final repo = await open(tester);
    final l = l10nOf(tester);

    await tester.enterText(find.byType(TextFormField).first, '100');
    await tester.enterText(find.widgetWithText(TextFormField, l.description), 'Market');
    await tester.pumpAndSettle();
    await tester.tap(saveButton(tester));
    await tester.pumpAndSettle();

    expect(repo.savedExpenses, hasLength(1));
    final e = repo.savedExpenses.single;
    expect(e.amountMinor, 10000);
    expect(e.description, 'Market');
    expect(e.paidBy, 'a');
    expect(e.createdBy, 'a');
    expect(e.splitType, SplitType.equal);
    expect(e.status, ExpenseStatus.finalized);
    expect(e.shares, {'a': 3334, 'b': 3333, 'c': 3333});
    // Back on the previous screen.
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('save stays disabled without an amount', (tester) async {
    final repo = await open(tester);

    await tester.enterText(find.widgetWithText(TextFormField, l10nOf(tester).description), 'Market');
    await tester.pumpAndSettle();

    expect(tester.widget<FilledButton>(saveButton(tester)).onPressed, isNull);
    expect(repo.savedExpenses, isEmpty);
  });

  testWidgets('a missing description blocks saving', (tester) async {
    final repo = await open(tester);
    final l = l10nOf(tester);

    await tester.enterText(find.byType(TextFormField).first, '50');
    await tester.pumpAndSettle();
    await tester.tap(saveButton(tester));
    await tester.pumpAndSettle();

    expect(find.text(l.requiredField), findsOneWidget);
    expect(repo.savedExpenses, isEmpty);
  });

  testWidgets('the first expense opens the Pro intro once', (tester) async {
    final repo = await open(tester, proIntroShown: false);
    final l = l10nOf(tester);

    await tester.enterText(find.byType(TextFormField).first, '30');
    await tester.enterText(find.widgetWithText(TextFormField, l.description), 'Ekmek');
    await tester.pumpAndSettle();
    await tester.tap(saveButton(tester));
    await tester.pumpAndSettle();

    expect(repo.savedExpenses, hasLength(1));
    expect(find.text('PRO'), findsOneWidget);
  });
}
