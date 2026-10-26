import 'package:flutter/material.dart';

/// "Para ve denge": a single green seed colour.
const _seed = Color(0xFF2E7D5B);

/// Semantic colours for amounts. Colour never carries meaning alone; amounts
/// always come with "borçlusun" / "alacaklısın" text.
@immutable
class MoneyColors extends ThemeExtension<MoneyColors> {
  const MoneyColors({required this.owe, required this.owed, required this.settled});

  final Color owe;
  final Color owed;
  final Color settled;

  Color forBalance(int minor) => minor < 0 ? owe : (minor > 0 ? owed : settled);

  @override
  MoneyColors copyWith({Color? owe, Color? owed, Color? settled}) => MoneyColors(
        owe: owe ?? this.owe,
        owed: owed ?? this.owed,
        settled: settled ?? this.settled,
      );

  @override
  MoneyColors lerp(MoneyColors? other, double t) {
    if (other == null) return this;
    return MoneyColors(
      owe: Color.lerp(owe, other.owe, t)!,
      owed: Color.lerp(owed, other.owed, t)!,
      settled: Color.lerp(settled, other.settled, t)!,
    );
  }
}

ThemeData _build(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  final dark = brightness == Brightness.dark;
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    extensions: [
      MoneyColors(
        owe: dark ? const Color(0xFFFF8A80) : const Color(0xFFC62828),
        owed: dark ? const Color(0xFF81C995) : const Color(0xFF1B7A3D),
        settled: scheme.onSurfaceVariant,
      ),
    ],
  );
}

final lightTheme = _build(Brightness.light);
final darkTheme = _build(Brightness.dark);

extension ThemeX on BuildContext {
  MoneyColors get moneyColors => Theme.of(this).extension<MoneyColors>()!;
}
