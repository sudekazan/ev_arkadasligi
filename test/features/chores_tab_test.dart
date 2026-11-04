import 'package:evarkadasligi/features/chores/domain/chore.dart';
import 'package:evarkadasligi/features/chores/presentation/chores_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  final members = [member('a', 'Ayşe'), member('b', 'Burak')];

  Chore chore(List<String> rotation) => Chore(
        id: 'c1',
        name: 'Bulaşık',
        rotation: rotation,
        nextDueAt: testNow,
      );

  Future<void> open(WidgetTester tester, Chore c) => pumpScreen(
        tester,
        const ChoresTab(),
        uid: 'a',
        members: members,
        repo: FakeExpenseRepository(),
        chores: [c],
        withAppTheme: true,
      );

  FilledButton doneButton(WidgetTester tester) => tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(l10nOf(tester).markDone),
          matching: find.byWidgetPredicate((w) => w is FilledButton),
        ),
      );

  testWidgets('done button is disabled when nobody is in the rotation', (tester) async {
    await open(tester, chore(const []));

    expect(find.text('Bulaşık'), findsOneWidget);
    expect(doneButton(tester).onPressed, isNull);
  });

  testWidgets('done button is enabled when someone has the turn', (tester) async {
    await open(tester, chore(const ['a', 'b']));

    expect(doneButton(tester).onPressed, isNotNull);
  });
}
