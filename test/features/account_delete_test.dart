import 'package:evarkadasligi/core/firebase/app_error.dart';
import 'package:evarkadasligi/features/auth/data/auth_repository.dart';
import 'package:evarkadasligi/features/auth/data/user_repository.dart';
import 'package:evarkadasligi/features/auth/domain/app_user.dart';
import 'package:evarkadasligi/features/pro/data/pro_service.dart';
import 'package:evarkadasligi/features/settings/data/account_repository.dart';
import 'package:evarkadasligi/features/settings/presentation/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

class FakeAccountRepository implements AccountRepository {
  FakeAccountRepository(this.firstError);

  final Object? firstError;
  final calls = <bool>[];

  @override
  Future<void> deleteAccount({bool force = false}) async {
    calls.add(force);
    if (calls.length == 1 && firstError != null) throw firstError!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserRepository implements UserRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final profile = AppUser(
    id: 'a',
    displayName: 'Ayşe',
    createdAt: testNow,
  );

  Future<FakeAccountRepository> open(WidgetTester tester, Object? firstError) async {
    final account = FakeAccountRepository(firstError);
    await pumpScreen(
      tester,
      const AccountScreen(),
      uid: 'a',
      members: [member('a', 'Ayşe')],
      repo: FakeExpenseRepository(),
      overrides: [
        accountRepositoryProvider.overrideWithValue(account),
        userRepositoryProvider.overrideWithValue(FakeUserRepository()),
        userProfileProvider.overrideWith((ref) => Stream.value(profile)),
        authStateProvider.overrideWith((ref) => const Stream.empty()),
        ownEntitlementProvider.overrideWith((ref) => Stream.value(false)),
      ],
    );
    return account;
  }

  Future<void> startDelete(WidgetTester tester) async {
    final l = l10nOf(tester);
    final tile = find.text(l.deleteAccount);
    await tester.scrollUntilVisible(tile, 200);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, l.deleteAccount));
    await tester.pumpAndSettle();
  }

  testWidgets('shows households with a balance before deleting', (tester) async {
    final account = await open(
      tester,
      const AppException(AppErrorCode.balanceNotZero, details: {
        'households': [
          {'name': 'Moda', 'balanceMinor': -25000, 'currency': 'TRY'},
        ],
      }),
    );
    final l = l10nOf(tester);

    await startDelete(tester);

    expect(find.text(l.deleteAccountBalanceTitle), findsOneWidget);
    expect(find.textContaining('Moda'), findsOneWidget);
    expect(account.calls, [false]);

    await tester.tap(find.text(l.deleteAnyway));
    await tester.pumpAndSettle();

    expect(account.calls, [false, true]);
  });

  testWidgets('cancel leaves the account alone', (tester) async {
    final account = await open(
      tester,
      const AppException(AppErrorCode.balanceNotZero, details: {
        'households': [
          {'name': 'Moda', 'balanceMinor': 500, 'currency': 'TRY'},
        ],
      }),
    );
    final l = l10nOf(tester);

    await startDelete(tester);
    await tester.tap(find.text(l.cancel));
    await tester.pumpAndSettle();

    expect(account.calls, [false]);
  });

  testWidgets('falls back to the generic error when the list is missing', (tester) async {
    final account = await open(tester, const AppException(AppErrorCode.balanceNotZero));
    final l = l10nOf(tester);

    await startDelete(tester);

    expect(find.text(l.deleteAccountBalanceTitle), findsNothing);
    expect(find.text(l.errorBalanceNotZero), findsOneWidget);
    expect(account.calls, [false]);
  });
}
