import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/data/auth_repository.dart';
import '../../balances/data/balance_providers.dart';
import '../data/household_repository.dart';
import '../domain/household.dart';
import 'invite_share_screen.dart';

/// Members and rent weights, invite code, household switching, leaving.
class HouseSettingsScreen extends ConsumerWidget {
  const HouseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final householdAsync = ref.watch(currentHouseholdProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.houseSettings)),
      body: AsyncBody(
        value: householdAsync,
        data: (household) {
          if (household == null) return const SizedBox.shrink();
          return _Body(household: household);
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.household});

  final Household household;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final name = TextEditingController(text: household.name);
    var currency = household.currency;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l.editHousehold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                maxLength: 60,
                decoration: InputDecoration(labelText: l.householdName),
              ),
              DropdownButtonFormField<String>(
                initialValue: currency,
                decoration: InputDecoration(labelText: l.currency),
                items: [
                  for (final c in Money.supportedCurrencies)
                    DropdownMenuItem(value: c, child: Text('$c (${Money.symbolFor(c)})')),
                ],
                onChanged: (v) => setState(() => currency = v ?? currency),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (saved != true || name.text.trim().isEmpty) return;
    try {
      await ref
          .read(householdRepositoryProvider)
          .update(household.id, name: name.text.trim(), currency: currency);
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  Future<void> _regenerate(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await confirm(context,
        title: l.regenerateCode, message: l.regenerateCodeBody, confirmLabel: l.regenerateCode);
    if (!ok) return;
    try {
      await ref.read(householdRepositoryProvider).regenerateInviteCode(household.id);
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref, Member member) async {
    final l = context.l10n;
    final balance = ref.read(netBalancesProvider)[member.id] ?? 0;
    if (balance != 0) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.cannotRemoveTitle),
          content: Text(l.cannotRemoveBody(
            member.displayName,
            Money.format(balance.abs(), currency: household.currency, locale: l.localeName),
          )),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(context), child: Text(l.ok)),
          ],
        ),
      );
      return;
    }
    final ok = await confirm(context,
        title: l.removeMember,
        message: l.removeMemberBody(member.displayName),
        confirmLabel: l.remove,
        destructive: true);
    if (!ok) return;
    try {
      await ref.read(householdRepositoryProvider).removeMember(household.id, member.id);
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final balance = ref.read(myNetBalanceProvider);
    if (balance != 0) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.cannotLeaveTitle),
          content: Text(l.cannotLeaveBody(
            Money.format(balance.abs(), currency: household.currency, locale: l.localeName),
          )),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(context), child: Text(l.ok)),
          ],
        ),
      );
      return;
    }
    final ok = await confirm(context,
        title: l.leaveHousehold,
        message: l.leaveHouseholdBody(household.name),
        confirmLabel: l.leave,
        destructive: true);
    if (!ok) return;
    try {
      await ref.read(householdRepositoryProvider).leave(household.id);
      if (context.mounted) context.go(Routes.home);
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(currentUidProvider);
    final isAdmin = uid != null && household.isAdmin(uid);
    final members = ref.watch(activeMembersProvider);
    final households = ref.watch(myHouseholdsProvider).value ?? const [];
    final repo = ref.read(householdRepositoryProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ListTile(
          leading: const Icon(Icons.cottage_outlined),
          title: Text(household.name),
          subtitle: Text('${household.currency} (${Money.symbolFor(household.currency)})'),
          trailing: isAdmin
              ? IconButton(
                  tooltip: l.editHousehold,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _edit(context, ref),
                )
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InviteCodeCard(
            code: household.inviteCode,
            onRegenerate: isAdmin ? () => _regenerate(context, ref) : null,
          ),
        ),
        SectionHeader(l.membersCount(members.length, maxHouseholdMembers)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l.rentWeightHelp, style: Theme.of(context).textTheme.bodySmall),
        ),
        for (final m in members)
          ListTile(
            leading: MemberAvatar(emoji: m.avatarEmoji),
            title: Text(m.id == uid ? l.youSuffix(m.displayName) : m.displayName),
            subtitle: Text([
              if (household.isAdmin(m.id)) l.admin,
              l.rentWeightValue(m.rentWeight),
            ].join(' · ')),
            trailing: isAdmin
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l.decreaseRentWeight(m.displayName),
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: m.rentWeight <= 0
                            ? null
                            : () => repo.setRentWeight(household.id, m.id, m.rentWeight - 1),
                      ),
                      IconButton(
                        tooltip: l.increaseRentWeight(m.displayName),
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: m.rentWeight >= 100
                            ? null
                            : () => repo.setRentWeight(household.id, m.id, m.rentWeight + 1),
                      ),
                      if (m.id != uid)
                        IconButton(
                          tooltip: l.removeMember,
                          icon: const Icon(Icons.person_remove_outlined),
                          onPressed: () => _remove(context, ref, m),
                        ),
                    ],
                  )
                : null,
          ),
        SectionHeader(l.myHouseholds),
        for (final h in households)
          ListTile(
            selected: h.id == household.id,
            leading: Icon(h.id == household.id ? Icons.check_circle : Icons.circle_outlined),
            title: Text(h.name),
            subtitle: h.isPro ? Text(l.proBadge) : null,
            onTap: () => ref.read(selectedHouseholdProvider.notifier).select(h.id),
          ),
        ListTile(
          leading: const Icon(Icons.add_home_outlined),
          title: Text(l.addHousehold),
          onTap: () => context.push('${Routes.onboardingHousehold}?add=1'),
        ),
        const Divider(height: 32),
        ListTile(
          leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
          title: Text(l.leaveHousehold,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
          onTap: () => _leave(context, ref),
        ),
      ],
    );
  }
}
