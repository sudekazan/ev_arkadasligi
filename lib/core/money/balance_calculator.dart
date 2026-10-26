/// Minimal view of an expense for balance purposes.
class LedgerExpense {
  const LedgerExpense({
    required this.paidBy,
    required this.amountMinor,
    required this.shares,
    this.isFinal = true,
  });

  final String paidBy;
  final int amountMinor;
  final Map<String, int> shares;

  /// False for "tutar bekleniyor" drafts, which do not affect balances.
  final bool isFinal;
}

/// Minimal view of a settlement ("ödeme yapıldı" record).
class LedgerSettlement {
  const LedgerSettlement({
    required this.fromUid,
    required this.toUid,
    required this.amountMinor,
  });

  final String fromUid;
  final String toUid;
  final int amountMinor;
}

abstract final class BalanceCalculator {
  /// Net balance per uid: paid expenses − own shares + settlements sent −
  /// settlements received. Positive means others owe this person.
  /// The values always add up to zero.
  static Map<String, int> nets(
    Iterable<LedgerExpense> expenses,
    Iterable<LedgerSettlement> settlements,
  ) {
    final net = <String, int>{};
    void add(String uid, int value) => net[uid] = (net[uid] ?? 0) + value;

    for (final e in expenses) {
      if (!e.isFinal) continue;
      add(e.paidBy, e.amountMinor);
      e.shares.forEach((uid, share) => add(uid, -share));
    }
    for (final s in settlements) {
      add(s.fromUid, s.amountMinor);
      add(s.toUid, -s.amountMinor);
    }
    return net;
  }
}
