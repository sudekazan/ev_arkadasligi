import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/household/data/household_repository.dart';
import 'package:evarkadasligi/features/household/presentation/house_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

class FakeHouseholdRepository implements HouseholdRepository {
  final updates = <({String name, String currency})>[];

  @override
  Future<void> update(
    String hid, {
    required String name,
    required String currency,
  }) async {
    updates.add((name: name, currency: currency));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final members = [member('a', 'Ayşe'), member('b', 'Burak')];
  final expense = Expense(
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
  );

  Future<FakeHouseholdRepository> openEditDialog(
    WidgetTester tester, {
    required List<Expense> expenses,
  }) async {
    final households = FakeHouseholdRepository();
    await pumpScreen(
      tester,
      const HouseSettingsScreen(),
      uid: 'a',
      members: members,
      repo: FakeExpenseRepository(),
      expenses: expenses,
      overrides: [
        myHouseholdsProvider.overrideWith((ref) => Stream.value(const [])),
        householdRepositoryProvider.overrideWithValue(households),
      ],
    );
    await tester.tap(find.byTooltip(l10nOf(tester).editHousehold));
    await tester.pumpAndSettle();
    return households;
  }

  DropdownButtonFormField<String> currencyField(WidgetTester tester) =>
      tester.widget(find.byType(DropdownButtonFormField<String>));

  testWidgets('currency is locked once the household has an expense', (
    tester,
  ) async {
    await openEditDialog(tester, expenses: [expense]);
    final l = l10nOf(tester);

    expect(currencyField(tester).onChanged, isNull);
    expect(find.text(l.currencyLockedHint), findsOneWidget);
    // The name stays editable.
    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).enabled,
      isNot(false),
    );
  });

  testWidgets('currency can be changed while the household has no expenses', (
    tester,
  ) async {
    await openEditDialog(tester, expenses: const []);
    final l = l10nOf(tester);

    expect(currencyField(tester).onChanged, isNotNull);
    expect(find.text(l.currencyLockedHint), findsNothing);
  });

  testWidgets('the name can still be saved while the currency is locked', (
    tester,
  ) async {
    final households = await openEditDialog(tester, expenses: [expense]);
    final l = l10nOf(tester);

    await tester.enterText(find.byType(TextField), 'Yeni Ev');
    await tester.tap(find.widgetWithText(FilledButton, l.save));
    await tester.pumpAndSettle();

    expect(households.updates, [(name: 'Yeni Ev', currency: 'TRY')]);
  });
}
