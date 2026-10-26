import '../../../core/money/money.dart';
import '../../expenses/domain/expense.dart';
import '../../household/domain/household.dart';

/// Builds a CSV of all expenses. Amounts are written as plain decimals with a
/// dot ("1234.50") so spreadsheets in any locale can read them.
String expensesToCsv({
  required List<Expense> expenses,
  required Map<String, Member> members,
  required List<String> header,
  required String Function(ExpenseCategory) categoryLabel,
  required String deletedUserLabel,
}) {
  String name(String uid) {
    final m = members[uid];
    if (m == null || m.deleted) return deletedUserLabel;
    return m.displayName;
  }

  String cell(String v) {
    final needsQuotes = v.contains(RegExp(r'[",\n;]'));
    final escaped = v.replaceAll('"', '""');
    return needsQuotes ? '"$escaped"' : escaped;
  }

  String amount(int minor) => Money.toInput(minor, locale: 'en').contains('.')
      ? Money.toInput(minor, locale: 'en')
      : '${Money.toInput(minor, locale: 'en')}.00';

  final rows = <String>[header.map(cell).join(',')];
  final sorted = [...expenses]..sort((a, b) => a.date.compareTo(b.date));
  for (final e in sorted.where((e) => !e.isPending)) {
    final shares = (e.shares.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
        .map((s) => '${name(s.key)}: ${amount(s.value)}')
        .join('; ');
    rows.add([
      e.date.toIso8601String().substring(0, 10),
      e.description,
      categoryLabel(e.category),
      amount(e.amountMinor),
      name(e.paidBy),
      shares,
      e.note,
    ].map(cell).join(','));
  }
  return '${rows.join('\n')}\n';
}
