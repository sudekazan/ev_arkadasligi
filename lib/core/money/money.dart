import 'package:intl/intl.dart';

/// Formatting and parsing of amounts kept as integer minor units (kuruş).
///
/// Amounts never pass through `double`: formatting splits the integer into
/// whole and fractional parts, and parsing reads digits directly.
abstract final class Money {
  static const supportedCurrencies = ['TRY', 'EUR', 'USD', 'GBP'];

  static String symbolFor(String currency) => switch (currency) {
        'TRY' => '₺',
        'EUR' => '€',
        'USD' => r'$',
        'GBP' => '£',
        _ => currency,
      };

  /// `1234567` → "12.345,67 ₺" (tr) or "₺12,345.67" (en).
  static String format(
    int minor, {
    required String currency,
    required String locale,
    bool showPlus = false,
  }) {
    final abs = minor.abs();
    final whole = NumberFormat.decimalPattern(locale).format(abs ~/ 100);
    final decimalSep = NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;
    final cents = (abs % 100).toString().padLeft(2, '0');
    final number = '$whole$decimalSep$cents';
    final sign = minor < 0 ? '−' : (showPlus && minor > 0 ? '+' : '');
    final symbol = symbolFor(currency);
    return locale.startsWith('tr')
        ? '$sign$number $symbol'
        : '$sign$symbol$number';
  }

  /// Formats hundredths without a currency, e.g. basis points 3333 → "33,33".
  static String formatHundredths(int value, {required String locale}) {
    final decimalSep = NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;
    final whole = NumberFormat.decimalPattern(locale).format(value.abs() ~/ 100);
    final frac = value.abs() % 100;
    final sign = value < 0 ? '−' : '';
    if (frac == 0) return '$sign$whole';
    return '$sign$whole$decimalSep${frac.toString().padLeft(2, '0')}';
  }

  /// Parses user input into hundredths: "1.234,5" → 123450, "12" → 1200.
  ///
  /// Both `,` and `.` are accepted as decimal separators. When both appear the
  /// last one is the decimal separator; a single separator followed by exactly
  /// three digits is read as a thousands separator. Returns null for invalid
  /// input or more than two decimals.
  static int? parse(String input) {
    var s = input.replaceAll(RegExp(r'[\s₺€$£]'), '');
    if (s.isEmpty || !RegExp(r'^[\d.,]+$').hasMatch(s)) return null;

    final lastDot = s.lastIndexOf('.');
    final lastComma = s.lastIndexOf(',');
    final lastSep = lastDot > lastComma ? lastDot : lastComma;
    var fraction = '';
    if (lastSep >= 0) {
      final tail = s.substring(lastSep + 1);
      final bothUsed = lastDot >= 0 && lastComma >= 0;
      final sepChar = s[lastSep];
      final singleUse = sepChar.allMatches(s).length == 1;
      final isDecimal = bothUsed || (singleUse && tail.length != 3);
      if (isDecimal) {
        if (tail.length > 2) return null;
        fraction = tail;
        s = s.substring(0, lastSep);
      }
    }
    final whole = s.replaceAll(RegExp(r'[.,]'), '');
    if (whole.isEmpty && fraction.isEmpty) return null;
    if (whole.length > 13) return null;
    final wholeValue = whole.isEmpty ? 0 : int.parse(whole);
    final fracValue = fraction.isEmpty ? 0 : int.parse(fraction.padRight(2, '0'));
    return wholeValue * 100 + fracValue;
  }

  /// Text for an input field: 123450 → "1234,50" (tr) / "1234.50" (en).
  static String toInput(int minor, {required String locale}) {
    final sep = locale.startsWith('tr') ? ',' : '.';
    final cents = minor % 100;
    if (cents == 0) return '${minor ~/ 100}';
    return '${minor ~/ 100}$sep${cents.toString().padLeft(2, '0')}';
  }
}
