/// IBAN normalization and ISO 13616 mod-97 validation.
abstract final class Iban {
  static String normalize(String input) => input.replaceAll(RegExp(r'\s'), '').toUpperCase();

  /// Groups of four for display: "TR33 0006 1005 …".
  static String format(String input) {
    final n = normalize(input);
    final buffer = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(n[i]);
    }
    return buffer.toString();
  }

  static bool isValid(String input) {
    final n = normalize(input);
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$').hasMatch(n)) return false;
    if (n.startsWith('TR') && n.length != 26) return false;
    final rearranged = n.substring(4) + n.substring(0, 4);
    var remainder = 0;
    for (final unit in rearranged.codeUnits) {
      final value = unit >= 65 ? unit - 55 : unit - 48; // A=10 … Z=35
      remainder = value >= 10
          ? (remainder * 100 + value) % 97
          : (remainder * 10 + value) % 97;
    }
    return remainder == 1;
  }
}
