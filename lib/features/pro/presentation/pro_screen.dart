import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/firebase/app_error.dart';
import '../../../core/widgets/feedback.dart';
import '../../household/data/household_repository.dart';
import '../data/pro_service.dart';

final _packagesProvider = FutureProvider.autoDispose<List<Package>>(
  (ref) => ref.watch(proServiceProvider).packages(),
);

/// Benefits, monthly / annual packages (prices from the store), restore.
class ProScreen extends ConsumerStatefulWidget {
  const ProScreen({super.key, required this.source});

  /// Where the paywall was opened from, for `paywall_viewed`.
  final String source;

  @override
  ConsumerState<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends ConsumerState<ProScreen> {
  bool _busy = false;
  String? _selected;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).paywallViewed(widget.source);
  }

  Future<void> _purchase(Package package) async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final active = await ref.read(proServiceProvider).purchase(package);
      if (active) {
        ref.read(analyticsProvider).purchaseCompleted(package.storeProduct.identifier);
        if (mounted) {
          showMessage(context, l.proWelcome);
          context.pop();
        }
      }
    } catch (e, s) {
      if (!mounted) return;
      if (errorCodeOf(e) == AppErrorCode.cancelled) return;
      if (kDebugMode) debugPrint('purchase failed: $e');
      reportError(e, s);
      showMessage(context, l.storeUnavailable);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final active = await ref.read(proServiceProvider).restore();
      if (mounted) showMessage(context, active ? l.restoreSuccess : l.restoreNothing);
    } catch (e) {
      if (kDebugMode) debugPrint('restore failed: $e');
      if (mounted) showMessage(context, l.storeUnavailable);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final isPro = ref.watch(householdIsProProvider);
    final household = ref.watch(currentHouseholdProvider).value;
    final packages = ref.watch(_packagesProvider);
    final benefits = [
      ('🏠', l.proBenefitHouseholds),
      ('🔁', l.proBenefitRecurring),
      ('🧾', l.proBenefitReceipts(ProLimits.proReceiptScans)),
      ('📊', l.proBenefitReports),
      ('📤', l.proBenefitCsv),
      ('👨‍👩‍👧', l.proBenefitShared),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l.close,
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        children: [
          const ExcludeSemantics(
              child: Text('✨', style: TextStyle(fontSize: 56), textAlign: TextAlign.center)),
          Text(l.proTitle, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.proSubtitle, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            l.proFreeForever,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 24),
          for (final (emoji, text) in benefits)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ExcludeSemantics(child: Text(emoji, style: const TextStyle(fontSize: 24))),
              title: Text(text),
            ),
          const SizedBox(height: 16),
          if (isPro)
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified),
                title: Text(l.proActive),
                subtitle: Text(l.proActiveFor(household?.name ?? '')),
              ),
            )
          else
            packages.when(
              data: (list) {
                _selected ??= list.first.identifier;
                final selected = list.firstWhere((p) => p.identifier == _selected);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final p in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _PackageCard(
                          package: p,
                          selected: p.identifier == _selected,
                          onTap: () => setState(() => _selected = p.identifier),
                        ),
                      ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _busy ? null : () => _purchase(selected),
                      child: Text(selected.packageType == PackageType.annual
                          ? l.startTrial
                          : l.subscribe),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) {
                if (kDebugMode) debugPrint('offerings failed: $e');
                return Column(
                  children: [
                    Text(l.storeUnavailable, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => ref.invalidate(_packagesProvider),
                      child: Text(l.retry),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 8),
          TextButton(onPressed: _busy ? null : _restore, child: Text(l.restorePurchases)),
          Text(l.subscriptionTerms,
              style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.selected, required this.onTap});

  final Package package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final annual = package.packageType == PackageType.annual;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(annual ? l.planAnnual : l.planMonthly, style: theme.textTheme.titleMedium),
                    if (annual) Text(l.trialDays(7), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(package.storeProduct.priceString, style: theme.textTheme.titleMedium),
                  if (annual)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(l.savePercent(40),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.onPrimary)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
