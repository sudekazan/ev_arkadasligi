import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

/// Build-time configuration from `--dart-define-from-file=env/<name>.json`.
///
/// Without a Firebase project id the app runs against the local emulators
/// with the `demo-evkasa` demo project, which needs no real credentials.
abstract final class FirebaseEnv {
  static const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _senderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const _bucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const _androidApiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const _androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const _iosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const _iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const iosClientId = String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
  static const revenueCatAndroidKey = String.fromEnvironment('REVENUECAT_ANDROID_KEY');
  static const revenueCatIosKey = String.fromEnvironment('REVENUECAT_IOS_KEY');
  static const _emulatorHost = String.fromEnvironment('EMULATOR_HOST');

  static const isDemo = projectId == '';
  static const useEmulator =
      bool.fromEnvironment('USE_EMULATOR', defaultValue: isDemo) || isDemo;

  static const demoProjectId = 'demo-evkasa';

  /// Android emulators reach the host machine through 10.0.2.2; a physical
  /// phone needs the Mac's LAN address via EMULATOR_HOST.
  static String get emulatorHost {
    if (_emulatorHost.isNotEmpty) return _emulatorHost;
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }

  static FirebaseOptions get options {
    if (isDemo) {
      return FirebaseOptions(
        // Not a real key: native SDKs only validate its shape (39 chars, "A…").
        apiKey: 'AIzaSydemoEvkasaEmulatorOnlyNotAKey0000',
        appId: Platform.isIOS
            ? '1:123456789012:ios:0123456789abcdef'
            : '1:123456789012:android:0123456789abcdef',
        messagingSenderId: '123456789012',
        projectId: demoProjectId,
        storageBucket: '$demoProjectId.appspot.com',
        iosBundleId: 'com.sudekazan.evarkadasligi',
      );
    }
    return FirebaseOptions(
      apiKey: Platform.isIOS ? _iosApiKey : _androidApiKey,
      appId: Platform.isIOS ? _iosAppId : _androidAppId,
      messagingSenderId: _senderId,
      projectId: projectId,
      storageBucket: _bucket.isEmpty ? '$projectId.firebasestorage.app' : _bucket,
      iosClientId: iosClientId.isEmpty ? null : iosClientId,
      iosBundleId: 'com.sudekazan.evarkadasligi',
    );
  }
}
