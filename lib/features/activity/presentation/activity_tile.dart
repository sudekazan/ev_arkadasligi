import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../household/data/household_repository.dart';
import '../domain/activity_event.dart';

class ActivityTile extends ConsumerWidget {
  const ActivityTile({super.key, required this.event, required this.currency});

  final ActivityEvent event;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final members = ref.watch(memberMapProvider);
    String name(String uid) => memberDisplayName(context, members, uid);
    String amount(String key) => formatMoney(context, event.intParam(key), currency);
    final actor = name(event.actorUid);

    final (IconData icon, String text) = switch (event.type) {
      ActivityType.householdCreated => (Icons.cottage_outlined, l.activityHouseholdCreated(actor)),
      ActivityType.memberJoined => (Icons.person_add_alt, l.activityMemberJoined(actor)),
      ActivityType.memberLeft => (Icons.logout, l.activityMemberLeft(actor)),
      ActivityType.memberRemoved =>
        (Icons.person_remove_outlined, l.activityMemberRemoved(actor, name(event.refId ?? ''))),
      ActivityType.expenseAdded => (
          Icons.receipt_long_outlined,
          l.activityExpenseAdded(actor, event.param('description'), amount('amountMinor'))
        ),
      ActivityType.expenseEdited =>
        (Icons.edit_outlined, l.activityExpenseEdited(actor, event.param('description'))),
      ActivityType.expenseDeleted => (
          Icons.delete_outline,
          l.activityExpenseDeleted(actor, event.param('description'), amount('amountMinor'))
        ),
      ActivityType.settlementAdded => (
          Icons.payments_outlined,
          l.activitySettlementAdded(
              name(event.param('fromUid')), name(event.param('toUid')), amount('amountMinor'))
        ),
      ActivityType.settlementDeleted => (
          Icons.money_off,
          l.activitySettlementDeleted(actor, name(event.param('fromUid')),
              name(event.param('toUid')), amount('amountMinor'))
        ),
      ActivityType.recurringCreated => event.params['pending'] == true
          ? (Icons.hourglass_empty, l.activityBillPending(event.param('description')))
          : (
              Icons.repeat,
              l.activityRecurringCreated(event.param('description'), amount('amountMinor'))
            ),
      ActivityType.choreDone => (
          Icons.task_alt,
          l.activityChoreDone(actor, event.param('name'), name(event.param('nextUid')))
        ),
      ActivityType.shoppingConverted =>
        (Icons.shopping_cart_checkout, l.activityShoppingConverted(actor, event.intParam('count'))),
      _ => (Icons.info_outline, l.activityUnknown),
    };

    final now = DateTime.now();
    final sameDay = event.createdAt.year == now.year &&
        event.createdAt.month == now.month &&
        event.createdAt.day == now.day;
    final when = sameDay
        ? DateFormat.Hm(l.localeName).format(event.createdAt)
        : DateFormat.MMMd(l.localeName).add_Hm().format(event.createdAt);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(icon, size: 20),
      ),
      title: Text(text),
      subtitle: Text(when),
    );
  }
}
