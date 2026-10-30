import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/feedback.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_repository.dart';
import '../features/settings/data/notification_service.dart';
import '../features/settings/data/settings_controller.dart';

/// Bottom navigation with the four tabs: Ana sayfa, Giderler, Ev, Hesap.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  StreamSubscription<Object?>? _messages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setUpNotifications());
  }

  Future<void> _setUpNotifications() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    // Push texts are written in the profile language, so follow the app's.
    final lang = appLanguageFor(Localizations.localeOf(context).languageCode);
    final profile = await ref.read(userProfileProvider.future);
    if (profile != null && profile.locale != lang) {
      unawaited(ref.read(userRepositoryProvider).setLocale(uid, lang));
    }
    if (!mounted) return;
    final service = ref.read(notificationServiceProvider);
    final flags = ref.read(onceFlagsProvider);
    if (!flags.isSet(OnceFlags.askedNotifications)) {
      flags.set(OnceFlags.askedNotifications);
      await service.requestPermission();
    }
    await service.register(uid);
    if (!mounted) return; // register can wait several seconds for APNs on iOS.
    _messages =service.foregroundMessages.listen((m) {
      final body = m.notification?.body;
      if (body != null && mounted) showMessage(context, body);
    });
  }

  @override
  void dispose() {
    unawaited(_messages?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.shell.currentIndex,
        onDestinationSelected: (i) =>
            widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l.tabExpenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.cottage_outlined),
            selectedIcon: const Icon(Icons.cottage),
            label: l.tabHouse,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l.tabAccount,
          ),
        ],
      ),
    );
  }
}
