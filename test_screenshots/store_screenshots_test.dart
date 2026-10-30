// Renders the App Store screenshots for every language with sample data.
//
//   flutter test test_screenshots --update-goldens
//
// Images land in test_screenshots/out/<language>/ at 1320×2868 (6.9" iPhone).
// Runs on GitHub (see .github/workflows/screenshots.yml); no simulator needed.
import 'dart:io';

import 'package:evarkadasligi/app/theme.dart';
import 'package:evarkadasligi/core/firebase/firebase_providers.dart';
import 'package:evarkadasligi/features/activity/data/activity_repository.dart';
import 'package:evarkadasligi/features/auth/data/auth_repository.dart';
import 'package:evarkadasligi/features/balances/presentation/home_screen.dart';
import 'package:evarkadasligi/features/chores/data/chore_repository.dart';
import 'package:evarkadasligi/features/expenses/data/expense_repository.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/expenses/presentation/expense_detail_screen.dart';
import 'package:evarkadasligi/features/expenses/presentation/expense_edit_screen.dart';
import 'package:evarkadasligi/features/expenses/presentation/expenses_screen.dart';
import 'package:evarkadasligi/features/household/data/household_repository.dart';
import 'package:evarkadasligi/features/household/presentation/house_screen.dart';
import 'package:evarkadasligi/features/pro/data/pro_service.dart';
import 'package:evarkadasligi/features/settings/data/settings_controller.dart';
import 'package:evarkadasligi/features/shopping/data/shopping_repository.dart';
import 'package:evarkadasligi/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_data.dart';

/// 6.9" iPhone: 1320×2868 pixels at 3×.
const _canvas = Size(440, 956);
const _phoneInsets = EdgeInsets.only(top: 62, bottom: 34);

enum _Shot { home, rent, receipt, shopping, chores, expenses }

void main() {
  setUpAll(() async {
    await _loadFonts();
    await initializeDateFormatting();
  });

  for (final data in storeData) {
    for (final shot in _Shot.values) {
      testWidgets('${data.locale} ${shot.index + 1} ${shot.name}', (tester) async {
        tester.view.physicalSize = _canvas * 3;
        // Golden images are captured at 1 pixel per logical pixel.
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        // flutter_test draws elevation as black outlines unless shadows are on.
        debugDisableShadows = false;

        await _pump(tester, data, shot);
        await _prepare(tester, shot, data);

        await expectLater(
          find.byKey(_frameKey),
          matchesGoldenFile('out/${data.locale}/${shot.index + 1}_${shot.name}.png'),
        );
        debugDefaultTargetPlatformOverride = null;
        debugDisableShadows = true;
      });
    }
  }
}

const _frameKey = ValueKey('store-frame');

/// Families that cover what Roboto lacks: emoji and symbols such as →.
final _fallback = <String>[];

final _theme = lightTheme.copyWith(
  platform: TargetPlatform.iOS,
  textTheme: lightTheme.textTheme.apply(fontFamilyFallback: _fallback),
  primaryTextTheme: lightTheme.primaryTextTheme.apply(fontFamilyFallback: _fallback),
);

Future<void> _pump(WidgetTester tester, StoreData data, _Shot shot) async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({
    OnceFlags.proIntroShown: true,
    OnceFlags.receiptAiConsent: true,
  });
  final prefs = await SharedPreferences.getInstance();

  final Widget screen = switch (shot) {
    _Shot.home => const HomeScreen(),
    _Shot.rent => ExpenseEditScreen(
      draft: ExpenseDraft(category: ExpenseCategory.rent, description: data.texts[0]),
    ),
    // The read receipt: line items under the filled-in expense.
    _Shot.receipt => const ExpenseDetailScreen(expenseId: 'e4'),
    _Shot.shopping || _Shot.chores => const HouseScreen(),
    _Shot.expenses => const ExpensesScreen(),
  };
  final tab = switch (shot) {
    _Shot.home => 0,
    _Shot.expenses => 1,
    _Shot.shopping || _Shot.chores => 2,
    _Shot.rent || _Shot.receipt => null,
  };

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => _PhoneShell(tab: tab, child: screen),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        clockProvider.overrideWithValue(() => shotNow),
        currentUidProvider.overrideWithValue(me),
        currentHouseholdIdProvider.overrideWithValue('h1'),
        currentHouseholdProvider.overrideWith((ref) => Stream.value(data.household)),
        myHouseholdsProvider.overrideWith((ref) => Stream.value([data.household])),
        membersProvider.overrideWith((ref) => Stream.value(data.members)),
        expensesProvider.overrideWith((ref) => Stream.value(data.expenses)),
        settlementsProvider.overrideWith((ref) => Stream.value(data.settlements)),
        recentActivityProvider.overrideWith((ref) => Stream.value(data.activity)),
        shoppingItemsProvider.overrideWith((ref) => Stream.value(data.shoppingItems)),
        choresProvider.overrideWith((ref) => Stream.value(data.choreList)),
        ownEntitlementProvider.overrideWith((ref) => Stream.value(false)),
        // Screens read these in build; nothing is written while screenshotting.
        shoppingRepositoryProvider.overrideWithValue(_FakeShopping()),
        choreRepositoryProvider.overrideWithValue(_FakeChores()),
      ],
      child: _StoreFrame(
        caption: data.captions[shot.index],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: _theme,
          locale: Locale(data.locale),
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
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeShopping implements ShoppingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChores implements ChoreRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Brings each screen into the state the caption describes.
Future<void> _prepare(WidgetTester tester, _Shot shot, StoreData data) async {
  final l = AppLocalizations.of(tester.element(find.byType(Scaffold).last));
  switch (shot) {
    case _Shot.rent:
      await tester.enterText(find.byType(TextFormField).first, '${data.rent}');
      FocusManager.instance.primaryFocus?.unfocus();
    case _Shot.chores:
      await tester.tap(find.text(l.chores));
    case _:
      break;
  }
  await tester.pumpAndSettle();
}

/// The app's bottom navigation, drawn around tab screens.
class _PhoneShell extends StatelessWidget {
  const _PhoneShell({required this.tab, required this.child});

  final int? tab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (tab == null) return child;
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab!,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l.tabExpenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.cottage_outlined),
            selectedIcon: const Icon(Icons.cottage),
            label: l.tabHouse,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l.tabAccount,
          ),
        ],
      ),
    );
  }
}

/// Store image: a headline on the brand colour above the phone screen.
class _StoreFrame extends StatelessWidget {
  const _StoreFrame({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = lightTheme.colorScheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        key: _frameKey,
        // Laid out at phone size, drawn 3× so the image is 1320×2868.
        child: FittedBox(
          child: SizedBox.fromSize(
            size: _canvas,
            child: ColoredBox(
              color: scheme.primary,
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                        child: Text(
                          caption,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 34,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(44)),
                        child: OverflowBox(
                          alignment: Alignment.topCenter,
                          maxHeight: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            child: SizedBox.fromSize(
                              size: _canvas,
                              child: _Phone(child: child),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A phone-sized screen with an iOS-style status bar.
class _Phone extends StatelessWidget {
  const _Phone({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = MediaQueryData(size: _canvas, devicePixelRatio: 3, padding: _phoneInsets);
    return MediaQuery(
      data: base.copyWith(viewPadding: _phoneInsets),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          const Positioned(left: 0, right: 0, top: 0, height: 54, child: _StatusBar()),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    return const Padding(
      padding: EdgeInsets.fromLTRB(46, 20, 34, 0),
      child: Row(
        children: [
          Text('9:41', style: style),
          Spacer(),
          Icon(Icons.signal_cellular_alt, size: 18, color: Colors.black),
          SizedBox(width: 5),
          Icon(Icons.wifi, size: 18, color: Colors.black),
          SizedBox(width: 5),
          RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.battery_full, size: 22, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

/// Test runs draw text with a placeholder font unless real fonts are loaded.
/// Roboto ships with the Flutter SDK; it stands in for the iOS system font.
Future<void> _loadFonts() async {
  final root = Platform.resolvedExecutable
      .split('${Platform.pathSeparator}bin${Platform.pathSeparator}cache')
      .first;
  final dir = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String file) async =>
      ByteData.sublistView(await File('$dir/$file').readAsBytes());

  const weights = ['Light', 'Regular', 'Medium', 'Bold'];
  for (final family in [
    'Roboto',
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
    '.SF UI Text',
    '.SF UI Display',
  ]) {
    final loader = FontLoader(family);
    for (final w in weights) {
      loader.addFont(read('Roboto-$w.ttf'));
    }
    await loader.load();
  }
  await (FontLoader('MaterialIcons')..addFont(read('MaterialIcons-Regular.otf'))).load();

  // System fonts: macOS (local runs and the macOS GitHub runner) or Linux.
  const fallbacks = {
    'Emoji': [
      '/System/Library/Fonts/Apple Color Emoji.ttc',
      '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf',
    ],
    'Symbols': [
      '/System/Library/Fonts/Supplemental/Arial Unicode.ttf',
      '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
    ],
  };
  for (final MapEntry(key: family, value: paths) in fallbacks.entries) {
    final path = paths.where((p) => File(p).existsSync()).firstOrNull;
    if (path == null) continue;
    final bytes = ByteData.sublistView(await File(path).readAsBytes());
    await (FontLoader(family)..addFont(Future.value(bytes))).load();
    _fallback.add(family);
  }
}
