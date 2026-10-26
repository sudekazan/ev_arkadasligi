import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/data/auth_repository.dart';
import '../../expenses/domain/expense.dart';
import '../../expenses/presentation/expense_edit_screen.dart';
import '../../household/data/household_repository.dart';
import '../data/shopping_repository.dart';
import '../domain/shopping_item.dart';

/// Realtime shared list; bought items can be turned into a groceries expense.
class ShoppingTab extends ConsumerStatefulWidget {
  const ShoppingTab({super.key});

  @override
  ConsumerState<ShoppingTab> createState() => _ShoppingTabState();
}

class _ShoppingTabState extends ConsumerState<ShoppingTab> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final Set<String> _deselected = {};

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _input.text.trim();
    final hid = ref.read(currentHouseholdIdProvider);
    final uid = ref.read(currentUidProvider);
    if (text.isEmpty || hid == null || uid == null) return;
    _input.clear();
    _focus.requestFocus();
    try {
      await ref.read(shoppingRepositoryProvider).add(hid, name: text, uid: uid);
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    }
  }

  void _convert(List<ShoppingItem> bought) {
    final selected = bought.where((i) => !_deselected.contains(i.id)).toList();
    if (selected.isEmpty) return;
    final l = context.l10n;
    context.push(
      Routes.expenseNew,
      extra: ExpenseDraft(
        description: l.groceriesDescription,
        category: ExpenseCategory.groceries,
        note: selected.map((i) => i.quantity == null ? i.name : '${i.name} (${i.quantity})').join(', '),
        shoppingItemIds: [for (final i in selected) i.id],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hid = ref.watch(currentHouseholdIdProvider);
    final uid = ref.watch(currentUidProvider);
    final members = ref.watch(memberMapProvider);
    final repo = ref.read(shoppingRepositoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _input,
            focusNode: _focus,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l.addShoppingItemHint,
              suffixIcon: IconButton(
                tooltip: l.add,
                icon: const Icon(Icons.add),
                onPressed: _add,
              ),
            ),
            onSubmitted: (_) => _add(),
          ),
        ),
        Expanded(
          child: AsyncBody(
            value: ref.watch(shoppingItemsProvider),
            data: (items) {
              if (items.isEmpty) {
                return EmptyState(
                  emoji: '🛒',
                  title: l.emptyShoppingTitle,
                  message: l.emptyShoppingBody,
                  actionLabel: l.addFirstItem,
                  onAction: _focus.requestFocus,
                );
              }
              final open = items.where((i) => !i.done).toList();
              final bought = items.where((i) => i.done).toList();
              final selectedCount = bought.where((i) => !_deselected.contains(i.id)).length;
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  for (final item in open)
                    _ItemTile(
                      item: item,
                      subtitle: l.addedBy(memberDisplayName(context, members, item.addedBy)),
                      onToggle: () => repo.setDone(hid!, item.id, done: true, uid: uid!),
                      onDelete: () => repo.delete(hid!, item.id),
                    ),
                  if (bought.isNotEmpty) ...[
                    SectionHeader(l.boughtItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l.boughtItemsHelp, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    for (final item in bought)
                      CheckboxListTile(
                        value: !_deselected.contains(item.id),
                        onChanged: (v) => setState(
                            () => v == true ? _deselected.remove(item.id) : _deselected.add(item.id)),
                        title: Text(
                          item.name,
                          style: const TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        subtitle: item.doneBy == null
                            ? null
                            : Text(l.boughtBy(memberDisplayName(context, members, item.doneBy!))),
                        secondary: IconButton(
                          tooltip: l.markNotBought,
                          icon: const Icon(Icons.undo),
                          onPressed: () => repo.setDone(hid!, item.id, done: false, uid: uid!),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton.icon(
                        onPressed: selectedCount == 0 ? null : () => _convert(bought),
                        icon: const Icon(Icons.receipt_long),
                        label: Text(l.addAsExpense(selectedCount)),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.subtitle,
    required this.onToggle,
    required this.onDelete,
  });

  final ShoppingItem item;
  final String subtitle;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => onDelete(),
      child: CheckboxListTile(
        value: false,
        onChanged: (_) => onToggle(),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(item.quantity == null ? item.name : '${item.name} · ${item.quantity}'),
        subtitle: Text(subtitle),
        secondary: IconButton(
          tooltip: l.delete,
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
