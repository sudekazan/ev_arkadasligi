import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/firebase/app_error.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../pro/data/pro_service.dart';
import '../data/household_repository.dart';

/// "Ev oluştur" or "Kodla katıl". With [addAnother] it is opened from the
/// household switcher and enforces the free one-household limit up front.
class HouseholdOnboardingScreen extends ConsumerStatefulWidget {
  const HouseholdOnboardingScreen({super.key, this.addAnother = false});

  final bool addAnother;

  @override
  ConsumerState<HouseholdOnboardingScreen> createState() => _HouseholdOnboardingScreenState();
}

class _HouseholdOnboardingScreenState extends ConsumerState<HouseholdOnboardingScreen> {
  final _createKey = GlobalKey<FormState>();
  final _joinKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  String _currency = 'TRY';
  bool _join = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    super.dispose();
  }

  bool _checkLimit() {
    final households = ref.read(userProfileProvider).value?.householdIds ?? const [];
    if (households.length >= ProLimits.freeHouseholds && !ref.read(userHasProProvider)) {
      ref.read(analyticsProvider).limitReached('households');
      context.push('${Routes.pro}?source=household_limit');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    final key = _join ? _joinKey : _createKey;
    if (!key.currentState!.validate() || !_checkLimit()) return;
    setState(() => _busy = true);
    final repo = ref.read(householdRepositoryProvider);
    final analytics = ref.read(analyticsProvider);
    try {
      if (_join) {
        final hid = await repo.join(_code.text);
        analytics.memberJoined();
        await ref.read(selectedHouseholdProvider.notifier).select(hid);
        if (mounted) context.go(Routes.home);
      } else {
        final (hid, code) = await repo.create(name: _name.text.trim(), currency: _currency);
        analytics.householdCreated();
        await ref.read(selectedHouseholdProvider.notifier).select(hid);
        if (mounted) context.go('${Routes.onboardingInvite}?code=$code');
      }
    } catch (e, s) {
      if (!mounted) return;
      if (errorCodeOf(e) == AppErrorCode.householdLimit) {
        await context.push('${Routes.pro}?source=household_limit');
      } else {
        showError(context, e, s);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addAnother ? l.addHousehold : l.appName),
        automaticallyImplyLeading: widget.addAnother,
        actions: [
          if (!widget.addAnother)
            TextButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: Text(l.signOut),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.onboardingTitle, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(l.onboardingBody,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                          value: false, icon: const Icon(Icons.add_home), label: Text(l.createHousehold)),
                      ButtonSegment(
                          value: true, icon: const Icon(Icons.vpn_key), label: Text(l.joinWithCode)),
                    ],
                    selected: {_join},
                    onSelectionChanged: (s) => setState(() => _join = s.first),
                  ),
                  const SizedBox(height: 24),
                  if (_join)
                    Form(
                      key: _joinKey,
                      child: TextFormField(
                        controller: _code,
                        autofocus: true,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                        ],
                        style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 8),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: l.inviteCode),
                        validator: (v) => (v ?? '').trim().length == 6 ? null : l.inviteCodeLength,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    )
                  else
                    Form(
                      key: _createKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _name,
                            autofocus: true,
                            maxLength: 60,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: l.householdName,
                              hintText: l.householdNameHint,
                            ),
                            validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _currency,
                            decoration: InputDecoration(labelText: l.currency),
                            items: [
                              for (final c in Money.supportedCurrencies)
                                DropdownMenuItem(value: c, child: Text('$c (${Money.symbolFor(c)})')),
                            ],
                            onChanged: (v) => setState(() => _currency = v ?? 'TRY'),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox.square(
                            dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_join ? l.join : l.createHousehold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
