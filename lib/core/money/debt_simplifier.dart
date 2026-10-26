/// A suggested payment from [fromUid] to [toUid].
class Transfer {
  const Transfer({
    required this.fromUid,
    required this.toUid,
    required this.amountMinor,
  });

  final String fromUid;
  final String toUid;
  final int amountMinor;

  @override
  bool operator ==(Object other) =>
      other is Transfer &&
      other.fromUid == fromUid &&
      other.toUid == toUid &&
      other.amountMinor == amountMinor;

  @override
  int get hashCode => Object.hash(fromUid, toUid, amountMinor);

  @override
  String toString() => 'Transfer($fromUid → $toUid: $amountMinor)';
}

abstract final class DebtSimplifier {
  /// Greedy settlement plan: the largest debtor pays the largest creditor the
  /// smaller of the two amounts, until every balance is zero. Ties are broken
  /// by alphabetical uid.
  static List<Transfer> simplify(Map<String, int> nets) {
    final balances = Map<String, int>.of(nets)..removeWhere((_, v) => v == 0);
    final transfers = <Transfer>[];

    String pick(bool Function(int) test, int Function(int, int) compare) {
      final candidates = balances.keys.where((u) => test(balances[u]!)).toList()
        ..sort((a, b) {
          final c = compare(balances[a]!, balances[b]!);
          return c != 0 ? c : a.compareTo(b);
        });
      return candidates.first;
    }

    while (balances.values.any((v) => v < 0) && balances.values.any((v) => v > 0)) {
      final debtor = pick((v) => v < 0, (a, b) => a.compareTo(b));
      final creditor = pick((v) => v > 0, (a, b) => b.compareTo(a));
      final debt = -balances[debtor]!;
      final credit = balances[creditor]!;
      final amount = debt < credit ? debt : credit;
      transfers.add(Transfer(fromUid: debtor, toUid: creditor, amountMinor: amount));
      balances[debtor] = balances[debtor]! + amount;
      balances[creditor] = balances[creditor]! - amount;
      balances.removeWhere((_, v) => v == 0);
    }
    return transfers;
  }
}
