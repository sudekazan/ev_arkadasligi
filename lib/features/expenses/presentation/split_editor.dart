import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/money/money.dart';
import '../../../core/money/split_calculator.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../household/domain/household.dart';

/// Holds the split form state: type, participants and per-person raw input.
class SplitController extends ChangeNotifier {
  SplitController({required List<String> memberIds}) : participants = {...memberIds};

  SplitType type = SplitType.equal;
  Set<String> participants;
  final Map<String, TextEditingController> _fields = {};

  TextEditingController field(String uid) =>
      _fields.putIfAbsent(uid, () => TextEditingController()..addListener(notifyListeners));

  void setType(SplitType value) {
    type = value;
    notifyListeners();
  }

  void toggle(String uid, bool selected) {
    selected ? participants.add(uid) : participants.remove(uid);
    notifyListeners();
  }

  /// Refills the form from a stored `splitInput`.
  void load(SplitType value, Map<String, int> input, {required String locale}) {
    type = value;
    participants = input.keys.toSet();
    for (final MapEntry(key: uid, value: v) in input.entries) {
      field(uid).text = switch (value) {
        SplitType.equal => '',
        SplitType.exact => Money.toInput(v, locale: locale),
        SplitType.percent => Money.toInput(v, locale: locale),
        SplitType.shares => '$v',
      };
    }
    notifyListeners();
  }

  /// Rent: weights by default "kira payı" of each member.
  void applyRentWeights(List<Member> members) {
    type = SplitType.shares;
    participants = {for (final m in members) if (m.rentWeight > 0) m.id};
    for (final m in members) {
      field(m.id).text = '${m.rentWeight}';
    }
    notifyListeners();
  }

  /// Raw input for [SplitCalculator.compute]; null when a field is not a number.
  Map<String, int>? input() {
    final sorted = participants.toList()..sort();
    final result = <String, int>{};
    for (final uid in sorted) {
      final text = field(uid).text.trim();
      final int? value = switch (type) {
        SplitType.equal => 1,
        SplitType.exact || SplitType.percent => text.isEmpty ? 0 : Money.parse(text),
        SplitType.shares => text.isEmpty ? 0 : int.tryParse(text),
      };
      if (value == null) return null;
      result[uid] = value;
    }
    return result;
  }

  SplitResult compute(int amountMinor) {
    final raw = input();
    if (raw == null) return const SplitFailure(SplitError.negativeValue);
    return SplitCalculator.compute(type: type, amountMinor: amountMinor, input: raw);
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }
}

/// Split type chips, participant rows and the live validation line.
class SplitEditor extends StatelessWidget {
  const SplitEditor({
    super.key,
    required this.controller,
    required this.members,
    required this.currency,
    required this.amountMinor,
  });

  final SplitController controller;
  final List<Member> members;
  final String currency;

  /// Null for variable-amount templates (only the ratio is stored).
  final int? amountMinor;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final amount = amountMinor ?? 0;
        final result = amount > 0 ? controller.compute(amount) : null;
        final shares = result is SplitSuccess ? result.shares : const <String, int>{};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in SplitType.values)
                  ChoiceChip(
                    label: Text(l.splitTypeName(t)),
                    selected: controller.type == t,
                    onSelected: (_) => controller.setType(t),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            for (final m in members)
              _ParticipantRow(
                member: m,
                controller: controller,
                currency: currency,
                shareMinor: shares[m.id],
              ),
            const SizedBox(height: 8),
            _StatusLine(
              controller: controller,
              result: result,
              currency: currency,
              hasAmount: amountMinor != null,
            ),
          ],
        );
      },
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({
    required this.member,
    required this.controller,
    required this.currency,
    required this.shareMinor,
  });

  final Member member;
  final SplitController controller;
  final String currency;
  final int? shareMinor;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final selected = controller.participants.contains(member.id);
    final type = controller.type;
    Widget? input;
    if (selected && type != SplitType.equal) {
      input = SizedBox(
        width: 110,
        child: TextField(
          controller: controller.field(member.id),
          keyboardType: TextInputType.numberWithOptions(decimal: type != SplitType.shares),
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            isDense: true,
            suffixText: switch (type) {
              SplitType.exact => Money.symbolFor(currency),
              SplitType.percent => '%',
              _ => l.sharesSuffix,
            },
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            semanticLabel: member.displayName,
            onChanged: (v) => controller.toggle(member.id, v ?? false),
          ),
          MemberAvatar(emoji: member.avatarEmoji, radius: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.displayName, overflow: TextOverflow.ellipsis),
                if (selected && shareMinor != null)
                  MoneyText(
                    shareMinor!,
                    currency: currency,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          ?input,
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.controller,
    required this.result,
    required this.currency,
    required this.hasAmount,
  });

  final SplitController controller;
  final SplitResult? result;
  final String currency;
  final bool hasAmount;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = l.localeName;
    String? text;
    var isError = false;
    if (controller.participants.isEmpty) {
      text = l.splitNoParticipants;
      isError = true;
    } else if (controller.type == SplitType.percent && (!hasAmount || result != null)) {
      final sum = (controller.input() ?? const {}).values.fold(0, (a, b) => a + b);
      final ok = sum == SplitCalculator.percentTotal;
      text = l.percentTotal(Money.formatHundredths(sum, locale: locale));
      isError = !ok;
    }
    if (result case SplitFailure(:final error, :final difference)) {
      isError = true;
      text = switch (error) {
        SplitError.exactSumMismatch => difference > 0
            ? l.splitMissing(Money.format(difference, currency: currency, locale: locale))
            : l.splitExcess(Money.format(-difference, currency: currency, locale: locale)),
        SplitError.percentSumMismatch =>
          l.percentTotal(Money.formatHundredths(SplitCalculator.percentTotal - difference, locale: locale)),
        SplitError.noParticipants => l.splitNoParticipants,
        SplitError.negativeValue => l.splitInvalidNumber,
        SplitError.invalidAmount => null,
      };
      if (text == null) isError = false;
    }
    if (text == null) return const SizedBox.shrink();
    final color = isError ? context.moneyColors.owe : Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline, size: 18, color: color),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(color: color))),
        ],
      ),
    );
  }
}
