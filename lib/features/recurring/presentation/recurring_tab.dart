import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../household/data/household_repository.dart';
import '../../pro/data/pro_service.dart';
import '../data/recurring_repository.dart';

class RecurringTab extends ConsumerWidget {
  const RecurringTab({super.key});

  void _add(BuildContext context, WidgetRef ref) {
    final active = (ref.read(recurringTemplatesProvider).value ?? const [])
        .where((t) => t.active)
        .length;
    if (active >= ProLimits.freeRecurring && !ref.read(householdIsProProvider)) {
      ref.read(analyticsProvider).limitReached('recurring');
      context.push('${Routes.pro}?source=recurring_limit');
      return;
    }
    context.push(Routes.recurringNew);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final household = ref.watch(currentHouseholdProvider).value;
    final isPro = ref.watch(householdIsProProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-recurring',
        tooltip: l.addRecurring,
        onPressed: () => _add(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        value: ref.watch(recurringTemplatesProvider),
        data: (templates) {
          if (templates.isEmpty || household == null) {
            return EmptyState(
              emoji: '🔁',
              title: l.emptyRecurringTitle,
              message: l.emptyRecurringBody,
              actionLabel: l.addRecurring,
              onAction: () => _add(context, ref),
            );
          }
          final activeCount = templates.where((t) => t.active).length;
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (!isPro)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(l.recurringFreeUsage(activeCount, ProLimits.freeRecurring),
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              for (final t in templates)
                ListTile(
                  leading: CircleAvatar(child: ExcludeSemantics(child: Text(t.category.emoji))),
                  title: Text(t.description),
                  subtitle: Text([
                    l.recurrenceName(t.frequency),
                    l.nextRun(DateFormat.yMMMd(l.localeName).format(t.nextRunAt)),
                    if (!t.fixedAmount) l.variableAmount,
                  ].join(' · ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (t.fixedAmount)
                        MoneyText(t.amountMinor, currency: household.currency),
                      Switch(
                        value: t.active,
                        onChanged: (v) {
                          if (v && activeCount >= ProLimits.freeRecurring && !isPro) {
                            context.push('${Routes.pro}?source=recurring_limit');
                            return;
                          }
                          ref.read(recurringRepositoryProvider).setActive(household.id, t.id, v);
                        },
                      ),
                    ],
                  ),
                  onTap: () => context.push(Routes.recurringEdit(t.id)),
                ),
            ],
          );
        },
      ),
    );
  }
}
