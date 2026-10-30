import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';

@immutable
class AppSettings {
  const AppSettings({this.themeMode = ThemeMode.system, this.localeCode});

  final ThemeMode themeMode;

  /// null follows the device language.
  final String? localeCode;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);
}

/// Device-level preferences. The language is also written to the profile so
/// push notifications use it.
class SettingsController extends Notifier<AppSettings> {
  static const _themeKey = 'themeMode';
  static const _localeKey = 'localeCode';

  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == prefs.getString(_themeKey),
        orElse: () => ThemeMode.system,
      ),
      localeCode: prefs.getString(_localeKey),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AppSettings(themeMode: mode, localeCode: state.localeCode);
    await ref.read(sharedPreferencesProvider).setString(_themeKey, mode.name);
  }

  Future<void> setLocale(String? code) async {
    state = AppSettings(themeMode: state.themeMode, localeCode: code);
    final prefs = ref.read(sharedPreferencesProvider);
    if (code == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, code);
    }
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// One-time flags stored on the device.
class OnceFlags {
  OnceFlags(this._ref);

  final Ref _ref;

  static const seenWelcome = 'seenWelcome';
  static const proIntroShown = 'proIntroShown';
  static const askedNotifications = 'askedNotifications';
  static const receiptAiConsent = 'receiptAiConsent';

  bool isSet(String key) => _ref.read(sharedPreferencesProvider).getBool(key) ?? false;

  void set(String key) => unawaited(_ref.read(sharedPreferencesProvider).setBool(key, true));
}

final onceFlagsProvider = Provider<OnceFlags>(OnceFlags.new);
