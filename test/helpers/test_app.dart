import 'package:evarkadasligi/core/firebase/firebase_providers.dart';
import 'package:evarkadasligi/features/auth/data/auth_repository.dart';
import 'package:evarkadasligi/features/expenses/data/expense_repository.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/household/data/household_repository.dart';
import 'package:evarkadasligi/features/household/domain/household.dart';
import 'package:evarkadasligi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final testNow = DateTime(2026, 10, 27, 12);

Member member(String id, String name, {String? iban}) =>
    Member(id: id, displayName: name, iban: iban, joinedAt: testNow);

Household household(List<String> memberIds, {String admin = 'a'}) => Household(
      id: 'h1',
      name: 'Test Evi',
      createdBy: admin,
      adminIds: [admin],
      memberIds: memberIds,
      createdAt: testNow,
    );

/// Records writes instead of talking to Firestore.
class FakeExpenseRepository implements ExpenseRepository {
  final savedExpenses = <Expense>[];
  final settlements = <Settlement>[];

  @override
  String newExpenseId(String hid) => 'e${savedExpenses.length + 1}';

  @override
  Future<void> saveExpense(String hid, Expense expense,
      {required String actorUid, Expense? existing}) async {
    savedExpenses.add(expense);
  }

  @override
  Future<void> addSettlement(String hid, Settlement settlement) async {
    settlements.add(settlement);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Pumps [screen] on top of a placeholder home route, with the household
/// data served from memory. A `/pro` route stands in for the paywall.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required String uid,
  required List<Member> members,
  required FakeExpenseRepository repo,
  List<Expense> expenses = const [],
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sharedPrefs = await SharedPreferences.getInstance();
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => context.push('/screen'),
              child: const Text('HOME'),
            ),
          ),
        ),
      ),
      GoRoute(path: '/screen', builder: (_, _) => screen),
      GoRoute(path: '/pro', builder: (_, _) => const Scaffold(body: Text('PRO'))),
    ],
  );
  final overrides = <Override>[
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
    clockProvider.overrideWithValue(() => testNow),
    currentUidProvider.overrideWithValue(uid),
    currentHouseholdIdProvider.overrideWithValue('h1'),
    currentHouseholdProvider
        .overrideWith((ref) => Stream.value(household([for (final m in members) m.id]))),
    membersProvider.overrideWith((ref) => Stream.value(members)),
    expensesProvider.overrideWith((ref) => Stream.value(expenses)),
    settlementsProvider.overrideWith((ref) => Stream.value(const [])),
    expenseRepositoryProvider.overrideWithValue(repo),
  ];
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    ),
  );
  await tester.tap(find.text('HOME'));
  await tester.pumpAndSettle();
}

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).last));
