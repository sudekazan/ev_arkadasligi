import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../household/data/household_repository.dart';
import '../../household/domain/household.dart';
import '../data/chore_repository.dart';
import '../domain/chore.dart';

/// Chores with a rotation; "Tamamlandı" passes the turn on.
class ChoresTab extends ConsumerWidget {
  const ChoresTab({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, [Chore? chore]) async {
    final members = ref.read(activeMembersProvider);
    final result = await showModalBottomSheet<Chore>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ChoreForm(chore: chore, members: members, now: ref.read(clockProvider)()),
    );
    final hid = ref.read(currentHouseholdIdProvider);
    if (result == null || hid == null) return;
    try {
      await ref.read(choreRepositoryProvider).save(hid, result);
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-chore',
        tooltip: l.addChore,
        onPressed: () => _edit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        value: ref.watch(choresProvider),
        data: (chores) => chores.isEmpty
            ? EmptyState(
                emoji: '🧹',
                title: l.emptyChoresTitle,
                message: l.emptyChoresBody,
                actionLabel: l.addChore,
                onAction: () => _edit(context, ref),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  for (final c in chores)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ChoreCard(chore: c, onEdit: () => _edit(context, ref, c)),
                    ),
                ],
              ),
      ),
    );
  }
}

class _ChoreCard extends ConsumerWidget {
  const _ChoreCard({required this.chore, required this.onEdit});

  final Chore chore;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    final members = ref.watch(memberMapProvider);
    final now = ref.watch(clockProvider)();
    final current = chore.currentUid;
    final due = chore.isDue(now);
    final dueText = DateFormat.MMMEd(l.localeName).format(chore.nextDueAt);
    final currentName = current == null
        ? '-'
        : (current == uid ? l.you : memberDisplayName(context, members, current));

    Future<void> complete() async {
      final hid = ref.read(currentHouseholdIdProvider);
      if (hid == null || uid == null) return;
      try {
        await ref.read(choreRepositoryProvider).complete(hid, chore, uid: uid, now: now);
        final next = chore.completed(now).currentUid;
        if (context.mounted && next != null) {
          showMessage(context, l.choreDoneNext(memberDisplayName(context, members, next)));
        }
      } catch (e, s) {
        if (context.mounted) showError(context, e, s);
      }
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(chore.name, style: theme.textTheme.titleMedium)),
                  Text(l.choreFrequencyName(chore.frequency), style: theme.textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MemberAvatar(emoji: members[current]?.avatarEmoji ?? '👤', radius: 14),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l.whoseTurn(currentName))),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                due ? l.choreDueToday(dueText) : l.choreDueOn(dueText),
                style: TextStyle(color: due ? context.moneyColors.owe : theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: complete,
                  icon: const Icon(Icons.check),
                  label: Text(l.markDone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoreForm extends ConsumerStatefulWidget {
  const _ChoreForm({required this.chore, required this.members, required this.now});

  final Chore? chore;
  final List<Member> members;
  final DateTime now;

  @override
  ConsumerState<_ChoreForm> createState() => _ChoreFormState();
}

class _ChoreFormState extends ConsumerState<_ChoreForm> {
  late final _name = TextEditingController(text: widget.chore?.name ?? '');
  late ChoreFrequency _frequency = widget.chore?.frequency ?? ChoreFrequency.weekly;
  late final List<String> _rotation = [
    ...?widget.chore?.rotation.where((u) => widget.members.any((m) => m.id == u)),
  ];
  late DateTime _due = widget.chore?.nextDueAt ??
      DateTime(widget.now.year, widget.now.month, widget.now.day);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await confirm(context,
        title: l.deleteChore, message: l.deleteChoreBody(widget.chore!.name),
        confirmLabel: l.delete, destructive: true);
    if (!ok || !mounted) return;
    final hid = ref.read(currentHouseholdIdProvider);
    if (hid != null) await ref.read(choreRepositoryProvider).delete(hid, widget.chore!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final valid = _name.text.trim().isNotEmpty && _rotation.isNotEmpty;
    final byId = {for (final m in widget.members) m.id: m};
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.chore == null ? l.addChore : l.editChore,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              autofocus: widget.chore == null,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.choreName, hintText: l.choreNameHint),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ChoreFrequency>(
              segments: [
                for (final f in ChoreFrequency.values)
                  ButtonSegment(value: f, label: Text(l.choreFrequencyName(f))),
              ],
              selected: {_frequency},
              onSelectionChanged: (s) => setState(() => _frequency = s.first),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l.firstDueDate),
              subtitle: Text(DateFormat.yMMMEd(l.localeName).format(_due)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _due,
                  firstDate: DateTime(widget.now.year - 1),
                  lastDate: DateTime(widget.now.year + 2),
                );
                if (picked != null) setState(() => _due = picked);
              },
            ),
            Text(l.rotationOrder, style: Theme.of(context).textTheme.labelLarge),
            Text(l.rotationHelp, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in widget.members)
                  FilterChip(
                    avatar: ExcludeSemantics(child: Text(m.avatarEmoji)),
                    label: Text(_rotation.contains(m.id)
                        ? '${_rotation.indexOf(m.id) + 1}. ${m.displayName}'
                        : m.displayName),
                    selected: _rotation.contains(m.id),
                    onSelected: (v) =>
                        setState(() => v ? _rotation.add(m.id) : _rotation.remove(m.id)),
                  ),
              ],
            ),
            if (_rotation.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_rotation.map((u) => byId[u]?.displayName ?? '?').join(' → ')),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: !valid
                  ? null
                  : () => Navigator.pop(
                        context,
                        Chore(
                          id: widget.chore?.id ?? '',
                          name: _name.text.trim(),
                          frequency: _frequency,
                          rotation: _rotation,
                          currentIndex: widget.chore == null
                              ? 0
                              : widget.chore!.currentIndex % _rotation.length,
                          nextDueAt: _due,
                        ),
                      ),
              child: Text(l.save),
            ),
            if (widget.chore != null)
              TextButton(
                onPressed: _delete,
                child: Text(l.deleteChore,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }
}
