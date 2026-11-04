import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/firebase/firebase_env.dart';
import 'core/firebase/firebase_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A release build without the prod config would silently talk to emulators.
  if (kReleaseMode && FirebaseEnv.isDemo) {
    throw StateError('Release build is missing --dart-define-from-file=env/prod.json');
  }
  await bootstrapFirebase();
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      // Firestore streams surface errors (e.g. permission) instead of retrying.
      retry: (_, _) => null,
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const EvKasaApp(),
    ),
  );
}
