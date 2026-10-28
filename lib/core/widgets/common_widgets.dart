import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../features/household/domain/household.dart';
import '../money/money.dart';
import 'feedback.dart';

/// Empty state: one explanation and a single action, as PLAN.md requires.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String emoji;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Text(emoji, style: const TextStyle(fontSize: 56))),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.emoji, this.radius = 20});

  final String emoji;
  final double radius;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(emoji, style: TextStyle(fontSize: radius)),
        ),
      );
}

/// Renders an [AsyncValue] with shared loading and error states.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({super.key, required this.value, required this.data});

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(errorMessage(context.l10n, e), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            ?trailing,
          ],
        ),
      );
}

/// Formatted amount coloured by sign; [semanticsLabel] carries the meaning.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.minor, {
    super.key,
    required this.currency,
    this.style,
    this.colored = false,
    this.showPlus = false,
  });

  final int minor;
  final String currency;
  final TextStyle? style;
  final bool colored;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    final text = Money.format(
      minor,
      currency: currency,
      locale: context.l10n.localeName,
      showPlus: showPlus,
    );
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: colored ? context.moneyColors.forBalance(minor) : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Large amount input that only accepts digits and separators.
class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    required this.currency,
    this.label,
    this.autofocus = false,
    this.large = false,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String currency;
  final String? label;
  final bool autofocus;
  final bool large;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // The iOS decimal keypad has no Done key; tapping elsewhere closes it.
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textAlign: large ? TextAlign.center : TextAlign.start,
      style: large
          ? theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600)
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0',
        suffixText: Money.symbolFor(currency),
        border: large ? InputBorder.none : null,
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

/// Display name for a uid, including people who left or deleted their account.
String memberDisplayName(BuildContext context, Map<String, Member> members, String uid) {
  final l = context.l10n;
  final m = members[uid];
  if (m == null) return l.unknownMember;
  if (m.deleted) return l.deletedUser;
  return m.displayName.isEmpty ? l.unknownMember : m.displayName;
}

String formatMoney(BuildContext context, int minor, String currency, {bool showPlus = false}) =>
    Money.format(minor, currency: currency, locale: context.l10n.localeName, showPlus: showPlus);
