// "Ev oluştur → gider ekle → bakiye gör" against the local emulators:
//   firebase emulators:start --project demo-evkasa
//   flutter test integration_test -d <simulator>
import 'package:evarkadasligi/l10n/app_localizations.dart';
import 'package:evarkadasligi/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntil(WidgetTester tester, Finder finder,
      {Duration timeout = const Duration(seconds: 30)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw TestFailure('Timed out waiting for $finder');
  }

  testWidgets('create household, add expense, see balance', (tester) async {
    // main() routes errors to Crashlytics; hand them back to the test binding.
    final onError = FlutterError.onError;
    await app.main();
    FlutterError.onError = onError;
    await tester.pump(const Duration(seconds: 2));
    final l = AppLocalizations.of(tester.element(find.byType(Scaffold).first));

    // Welcome is only shown on the first launch; wait past the splash first.
    await pumpUntil(
      tester,
      find.byWidgetPredicate((w) => w is Text && (w.data == l.skip || w.data == l.register)),
    );
    if (find.text(l.skip).evaluate().isNotEmpty) {
      await tester.tap(find.text(l.skip));
    }
    await pumpUntil(tester, find.text(l.register));

    await tester.tap(find.text(l.register).first);
    await tester.pumpAndSettle();
    final email = 'test${DateTime.now().millisecondsSinceEpoch}@evkasa.test';
    await tester.enterText(find.widgetWithText(TextFormField, l.yourName), 'Ayşe');
    await tester.enterText(find.widgetWithText(TextFormField, l.email), email);
    await tester.enterText(find.widgetWithText(TextFormField, l.password), 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, l.register));

    await pumpUntil(tester, find.text(l.onboardingTitle));
    await tester.enterText(find.widgetWithText(TextFormField, l.householdName), 'Test Evi');
    await tester.tap(find.widgetWithText(FilledButton, l.createHousehold));

    await pumpUntil(tester, find.text(l.continueToHome));
    await tester.tap(find.text(l.continueToHome));
    await pumpUntil(tester, find.text(l.statusSettled));

    await tester.tap(find.widgetWithText(FloatingActionButton, l.addExpense).first);
    await pumpUntil(tester, find.widgetWithText(TextFormField, l.description));
    await tester.enterText(find.byType(TextFormField).first, '250');
    await tester.enterText(find.widgetWithText(TextFormField, l.description), 'Market');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, l.save));

    // The Pro intro is shown once after the first expense.
    await pumpUntil(tester, find.byTooltip(l.close));
    await tester.tap(find.byTooltip(l.close));

    await pumpUntil(tester, find.textContaining('Market'));
    expect(find.text(l.statusSettled), findsOneWidget);
    expect(find.textContaining('Market'), findsWidgets);
  });
}
