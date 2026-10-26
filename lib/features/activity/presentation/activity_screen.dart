import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../household/data/household_repository.dart';
import '../data/activity_repository.dart';
import 'activity_tile.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final currency = ref.watch(currentHouseholdProvider).value?.currency ?? 'TRY';
    return Scaffold(
      appBar: AppBar(title: Text(l.activity)),
      body: AsyncBody(
        value: ref.watch(allActivityProvider),
        data: (events) => events.isEmpty
            ? EmptyState(
                emoji: '📰',
                title: l.noActivityTitle,
                message: l.noActivityBody,
                actionLabel: l.back,
                onAction: () => Navigator.of(context).maybePop(),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (_, i) => ActivityTile(event: events[i], currency: currency),
              ),
      ),
    );
  }
}
