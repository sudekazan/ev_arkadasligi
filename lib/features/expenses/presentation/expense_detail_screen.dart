import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../household/data/household_repository.dart';
import '../../receipts/data/receipt_repository.dart';
import '../data/expense_repository.dart';

/// Shares, receipt photo and items; edit / delete for the creator or an admin.
class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({super.key, required this.expenseId});

  final String expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final expense = ref.watch(expenseByIdProvider(expenseId));
    final household = ref.watch(currentHouseholdProvider).value;
    final members = ref.watch(memberMapProvider);
    final uid = ref.watch(currentUidProvider);
    if (expense == null || household == null) {
      final loading = ref.watch(expensesProvider).isLoading;
      return Scaffold(
        appBar: AppBar(),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : EmptyState(
                emoji: '🗑️',
                title: l.expenseNotFound,
                message: l.expenseNotFoundBody,
                actionLabel: l.back,
                onAction: () => context.pop(),
              ),
      );
    }
    final canEdit = uid == expense.createdBy || (uid != null && household.isAdmin(uid));

    Future<void> delete() async {
      final ok = await confirm(context,
          title: l.deleteExpense,
          message: l.deleteExpenseBody(expense.description),
          confirmLabel: l.delete,
          destructive: true);
      if (!ok || !context.mounted) return;
      try {
        await ref
            .read(expenseRepositoryProvider)
            .deleteExpense(household.id, expense, actorUid: uid!);
        if (context.mounted) context.pop();
      } catch (e, s) {
        if (context.mounted) showError(context, e, s);
      }
    }

    final shares = expense.shares.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (canEdit) ...[
            IconButton(
              tooltip: l.edit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.pushReplacement(Routes.expenseEdit(expense.id)),
            ),
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: delete,
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${expense.category.emoji}  ${l.categoryName(expense.category)}',
                    style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(expense.description, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                MoneyText(expense.amountMinor,
                    currency: household.currency, style: theme.textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(l.paidByOn(
                  memberDisplayName(context, members, expense.paidBy),
                  DateFormat.yMMMMd(l.localeName).format(expense.date),
                )),
                Text(l.splitTypeLabel(l.splitTypeName(expense.splitType)),
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          SectionHeader(l.shares),
          for (final MapEntry(key: memberId, value: share) in shares)
            ListTile(
              leading: MemberAvatar(emoji: members[memberId]?.avatarEmoji ?? '👤'),
              title: Text(memberDisplayName(context, members, memberId)),
              trailing: MoneyText(share, currency: household.currency),
            ),
          if (expense.note.isNotEmpty) ...[
            SectionHeader(l.note),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(expense.note),
            ),
          ],
          if (expense.receiptItems.isNotEmpty) ...[
            SectionHeader(l.receiptItems),
            for (final item in expense.receiptItems)
              ListTile(
                dense: true,
                title: Text(item.name),
                trailing: MoneyText(item.amountMinor, currency: household.currency),
              ),
          ],
          if (expense.receiptPath != null) ...[
            SectionHeader(l.receipt),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ReceiptImage(path: expense.receiptPath!),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReceiptImage extends ConsumerWidget {
  const _ReceiptImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(receiptUrlProvider(path));
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: url.when(
        data: (u) => Image.network(
          u,
          semanticLabel: context.l10n.receipt,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        ),
        loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text(errorMessage(context.l10n, e)),
      ),
    );
  }
}
