/// How an expense is divided between participants.
enum SplitType {
  equal,
  exact,
  percent,
  shares;

  static SplitType fromName(String? name) =>
      SplitType.values.firstWhere((t) => t.name == name, orElse: () => equal);
}

enum SplitError {
  noParticipants,
  invalidAmount,
  negativeValue,

  /// Exact amounts do not add up to the total; see [SplitFailure.difference].
  exactSumMismatch,

  /// Percentages do not add up to 100%; difference is in basis points.
  percentSumMismatch,
}

sealed class SplitResult {
  const SplitResult();
}

final class SplitSuccess extends SplitResult {
  const SplitSuccess(this.shares);

  /// uid → minor units; the values always add up to the expense amount.
  final Map<String, int> shares;
}

final class SplitFailure extends SplitResult {
  const SplitFailure(this.error, {this.difference = 0});

  final SplitError error;

  /// Target minus entered sum: positive means missing, negative means excess.
  /// Minor units for [SplitError.exactSumMismatch], basis points for
  /// [SplitError.percentSumMismatch].
  final int difference;
}

/// Pure split logic; see PLAN.md "Bölüşme, yuvarlama ve bakiye algoritması".
abstract final class SplitCalculator {
  static const percentTotal = 10000;

  /// [input] holds the raw value per participant: ignored for [SplitType.equal],
  /// minor units for exact, basis points for percent and weights for shares.
  static SplitResult compute({
    required SplitType type,
    required int amountMinor,
    required Map<String, int> input,
  }) {
    if (amountMinor <= 0) return const SplitFailure(SplitError.invalidAmount);
    if (input.isEmpty) return const SplitFailure(SplitError.noParticipants);
    if (input.values.any((v) => v < 0)) {
      return const SplitFailure(SplitError.negativeValue);
    }
    switch (type) {
      case SplitType.equal:
        return SplitSuccess(allocate(amountMinor, {for (final uid in input.keys) uid: 1}));
      case SplitType.exact:
        final sum = input.values.fold(0, (a, b) => a + b);
        if (sum != amountMinor) {
          return SplitFailure(SplitError.exactSumMismatch, difference: amountMinor - sum);
        }
        return SplitSuccess(_sorted(input));
      case SplitType.percent:
        final sum = input.values.fold(0, (a, b) => a + b);
        if (sum != percentTotal) {
          return SplitFailure(SplitError.percentSumMismatch, difference: percentTotal - sum);
        }
        return SplitSuccess(allocate(amountMinor, input));
      case SplitType.shares:
        if (input.values.every((v) => v == 0)) {
          return const SplitFailure(SplitError.noParticipants);
        }
        return SplitSuccess(allocate(amountMinor, input));
    }
  }

  /// Largest-remainder allocation of [amount] in proportion to [weights].
  ///
  /// Each share is floored, then the leftover minor units go one by one to the
  /// largest fractional remainders; ties go to the alphabetically first uid.
  /// Participants with weight 0 are left out.
  static Map<String, int> allocate(int amount, Map<String, int> weights) {
    final uids = weights.keys.where((u) => weights[u]! > 0).toList()..sort();
    if (uids.isEmpty) throw ArgumentError('no positive weights');
    final total = BigInt.from(uids.fold(0, (s, u) => s + weights[u]!));
    final big = BigInt.from(amount);

    final floors = <String, BigInt>{};
    final remainders = <String, BigInt>{};
    var left = big;
    for (final uid in uids) {
      final product = big * BigInt.from(weights[uid]!);
      floors[uid] = product ~/ total;
      remainders[uid] = product.remainder(total);
      left -= floors[uid]!;
    }
    final order = [...uids]
      ..sort((a, b) {
        final byRemainder = remainders[b]!.compareTo(remainders[a]!);
        return byRemainder != 0 ? byRemainder : a.compareTo(b);
      });
    for (final uid in order) {
      if (left == BigInt.zero) break;
      floors[uid] = floors[uid]! + BigInt.one;
      left -= BigInt.one;
    }
    return {for (final uid in uids) uid: floors[uid]!.toInt()};
  }

  static Map<String, int> _sorted(Map<String, int> m) {
    final keys = m.keys.toList()..sort();
    return {for (final k in keys) k: m[k]!};
  }
}
