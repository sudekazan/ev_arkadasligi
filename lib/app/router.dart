import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/activity/presentation/activity_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_repository.dart';
import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/balances/presentation/home_screen.dart';
import '../features/balances/presentation/settle_screen.dart';
import '../features/expenses/presentation/expense_detail_screen.dart';
import '../features/expenses/presentation/expense_edit_screen.dart';
import '../features/expenses/presentation/expenses_screen.dart';
import '../features/household/presentation/house_screen.dart';
import '../features/household/presentation/house_settings_screen.dart';
import '../features/household/presentation/household_onboarding_screen.dart';
import '../features/household/presentation/invite_share_screen.dart';
import '../features/pro/presentation/pro_screen.dart';
import '../features/recurring/presentation/recurring_edit_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/settings/data/settings_controller.dart';
import '../features/settings/presentation/account_screen.dart';
import '../features/settings/presentation/profile_edit_screen.dart';
import 'shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Routes from PLAN.md "Ekranlar ve akışlar".
abstract final class Routes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const auth = '/auth';
  static const onboardingHousehold = '/onboarding/household';
  static const onboardingInvite = '/onboarding/invite';
  static const home = '/home';
  static const expenses = '/expenses';
  static const expenseNew = '/expenses/new';
  static String expenseEdit(String id) => '/expenses/edit/$id';
  static String expenseDetail(String id) => '/expenses/$id';
  static const settle = '/settle';
  static const house = '/house';
  static const houseSettings = '/house/settings';
  static const recurringNew = '/house/recurring/new';
  static String recurringEdit(String id) => '/house/recurring/$id';
  static const activity = '/activity';
  static const account = '/account';
  static const profile = '/account/profile';
  static const pro = '/pro';
  static const reports = '/reports';
}

const _publicRoutes = {Routes.welcome, Routes.auth};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(authStateProvider, (_, _) => refresh.value++)
    ..listen(userProfileProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final auth = ref.read(authStateProvider);
    if (auth.isLoading && !auth.hasValue) return Routes.splash;
    final user = auth.value;
    if (user == null) {
      if (_publicRoutes.contains(loc)) return null;
      return ref.read(onceFlagsProvider).isSet(OnceFlags.seenWelcome)
          ? Routes.auth
          : Routes.welcome;
    }
    final profile = ref.read(userProfileProvider).value;
    if (profile == null || profile.id != user.uid) {
      return loc == Routes.splash ? null : Routes.splash;
    }
    if (profile.householdIds.isEmpty) {
      if (loc == Routes.onboardingHousehold || loc.startsWith(Routes.account)) return null;
      return Routes.onboardingHousehold;
    }
    final addingAnother = state.uri.queryParameters['add'] == '1';
    if (_publicRoutes.contains(loc) ||
        loc == Routes.splash ||
        (loc == Routes.onboardingHousehold && !addingAnother)) {
      return Routes.home;
    }
    return null;
  }

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: Routes.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: Routes.onboardingHousehold,
        builder: (_, state) =>
            HouseholdOnboardingScreen(addAnother: state.uri.queryParameters['add'] == '1'),
      ),
      GoRoute(
        path: Routes.onboardingInvite,
        builder: (_, state) => InviteShareScreen(code: state.uri.queryParameters['code'] ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.expenses,
              builder: (_, _) => const ExpensesScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) =>
                      ExpenseEditScreen(draft: state.extra as ExpenseDraft?),
                ),
                GoRoute(
                  path: 'edit/:id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => ExpenseEditScreen(expenseId: state.pathParameters['id']),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => ExpenseDetailScreen(expenseId: state.pathParameters['id']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.house,
              builder: (_, _) => const HouseScreen(),
              routes: [
                GoRoute(
                  path: 'settings',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const HouseSettingsScreen(),
                ),
                GoRoute(
                  path: 'recurring/new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const RecurringEditScreen(),
                ),
                GoRoute(
                  path: 'recurring/:id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => RecurringEditScreen(templateId: state.pathParameters['id']),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.account,
              builder: (_, _) => const AccountScreen(),
              routes: [
                GoRoute(
                  path: 'profile',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const ProfileEditScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.settle,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return SettleScreen(
            fromUid: q['from'],
            toUid: q['to'],
            amountMinor: int.tryParse(q['amount'] ?? ''),
          );
        },
      ),
      GoRoute(path: Routes.activity, builder: (_, _) => const ActivityScreen()),
      GoRoute(
        path: Routes.pro,
        builder: (_, state) => ProScreen(source: state.uri.queryParameters['source'] ?? 'account'),
      ),
      GoRoute(path: Routes.reports, builder: (_, _) => const ReportsScreen()),
    ],
  );
});
