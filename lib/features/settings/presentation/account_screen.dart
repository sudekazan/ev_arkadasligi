import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../core/firebase/firebase_env.dart';
import '../../../core/utils/iban.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/labels.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../expenses/data/expense_repository.dart';
import '../../household/data/household_repository.dart';
import '../../pro/data/pro_service.dart';
import '../../reports/data/csv_export.dart';
import '../data/account_repository.dart';
import '../data/settings_controller.dart';

/// Hosted on Firebase Hosting (hosting/public).
String get _hostingBase =>
    'https://${FirebaseEnv.isDemo ? FirebaseEnv.demoProjectId : FirebaseEnv.projectId}.web.app';
String get _privacyUrl => '$_hostingBase/privacy';
String get _termsUrl => '$_hostingBase/terms';

/// Profile, language, theme, notifications, Pro, export, sign out, deletion.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    if (!ref.read(householdIsProProvider)) {
      await context.push('${Routes.pro}?source=csv_export');
      return;
    }
    final household = ref.read(currentHouseholdProvider).value;
    if (household == null) return;
    final csv = expensesToCsv(
      expenses: ref.read(expensesProvider).value ?? const [],
      members: ref.read(memberMapProvider),
      header: [l.date, l.description, l.category, l.amount, l.paidBy, l.shares, l.note],
      categoryLabel: l.categoryName,
      deletedUserLabel: l.deletedUser,
    );
    final bytes = utf8.encode('﻿$csv'); // BOM so Excel reads UTF-8.
    await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(bytes, mimeType: 'text/csv', name: 'odeselim-${household.name}.csv')],
      fileNameOverrides: ['odeselim.csv'],
      subject: l.csvSubject(household.name),
    ));
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await confirm(context,
        title: l.deleteAccount, message: l.deleteAccountBody, confirmLabel: l.deleteAccount,
        destructive: true);
    if (!ok || !context.mounted) return;
    try {
      await ref.read(accountRepositoryProvider).deleteAccount();
    } catch (e, s) {
      if (context.mounted) showError(context, e, s);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profile = ref.watch(userProfileProvider).value;
    final settings = ref.watch(settingsProvider);
    final email = ref.watch(authStateProvider).value?.email;
    final isPro = ref.watch(householdIsProProvider);
    final hasHousehold = ref.watch(currentHouseholdIdProvider) != null;
    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final userRepo = ref.read(userRepositoryProvider);

    Future<void> setLocale(String? code) async {
      await ref.read(settingsProvider.notifier).setLocale(code);
      final effective = code ?? WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      await userRepo.setLocale(profile.id, effective == 'en' ? 'en' : 'tr');
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.tabAccount)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          ListTile(
            leading: MemberAvatar(emoji: profile.avatarEmoji, radius: 24),
            title: Text(profile.displayName),
            subtitle: Text([
              ?email,
              if (profile.iban != null && profile.iban!.isNotEmpty) Iban.format(profile.iban!),
            ].join('\n')),
            isThreeLine: profile.iban != null && profile.iban!.isNotEmpty,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.profile),
          ),
          if (hasHousehold)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: ListTile(
                  leading: const Text('✨', style: TextStyle(fontSize: 28)),
                  title: Text(isPro ? l.proActive : l.goPro),
                  subtitle: Text(isPro ? l.proActiveBody : l.goProBody),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('${Routes.pro}?source=account'),
                ),
              ),
            ),
          SectionHeader(l.preferences),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: DropdownButton<String?>(
              value: settings.localeCode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: null, child: Text(l.systemDefault)),
                const DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                const DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: setLocale,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l.theme),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l.systemDefault)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l.themeDark)),
              ],
              onChanged: (m) => ref.read(settingsProvider.notifier).setThemeMode(m ?? ThemeMode.system),
            ),
          ),
          SectionHeader(l.notifications),
          for (final kind in NotificationKind.all)
            SwitchListTile(
              secondary: Icon(switch (kind) {
                NotificationKind.newExpense => Icons.receipt_long_outlined,
                NotificationKind.reminders => Icons.payments_outlined,
                NotificationKind.bills => Icons.hourglass_empty,
                _ => Icons.cleaning_services_outlined,
              }),
              title: Text(switch (kind) {
                NotificationKind.newExpense => l.notifyNewExpense,
                NotificationKind.reminders => l.notifyReminders,
                NotificationKind.bills => l.notifyBills,
                _ => l.notifyChores,
              }),
              value: profile.notificationsEnabled(kind),
              onChanged: (v) => userRepo.setNotificationPref(profile.id, kind, v),
            ),
          SectionHeader(l.data),
          if (hasHousehold) ...[
            ListTile(
              leading: const Icon(Icons.pie_chart_outline),
              title: Text(l.reports),
              onTap: () => context.push(Routes.reports),
            ),
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: Text(l.exportCsv),
              subtitle: isPro ? null : Text(l.proFeature),
              onTap: () => _exportCsv(context, ref),
            ),
          ],
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            onTap: () => launchUrl(Uri.parse(_privacyUrl)),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsOfUse),
            onTap: () => launchUrl(Uri.parse(_termsUrl)),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l.signOut),
            onTap: () => ref.read(accountRepositoryProvider).signOut(),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
            title: Text(l.deleteAccount, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () => _deleteAccount(context, ref),
          ),
        ],
      ),
    );
  }
}
