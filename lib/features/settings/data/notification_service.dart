import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/app_error.dart';
import '../../auth/data/user_repository.dart';

/// FCM permission, token registration and foreground messages.
///
/// Uses registration tokens (deprecated in firebase_messaging 17 in favour of
/// Installation-ID "direct send"), because the Admin SDK multicast in
/// functions/src/notify.ts targets tokens. Migrate both sides together.
// ignore_for_file: deprecated_member_use
class NotificationService {
  NotificationService(this._users);

  final UserRepository _users;
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _messageSub;
  final _foreground = StreamController<RemoteMessage>.broadcast();

  /// Messages received while the app is open (shown as a snackbar).
  Stream<RemoteMessage> get foregroundMessages => _foreground.stream;

  Future<bool> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e, s) {
      reportError(e, s);
      return false;
    }
  }

  /// Saves the device token on the profile and keeps it fresh.
  Future<void> register(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _users.addFcmToken(uid, token);
      await _tokenSub?.cancel();
      _tokenSub = FirebaseMessaging.instance.onTokenRefresh
          .listen((t) => unawaited(_users.addFcmToken(uid, t)));
      _messageSub ??= FirebaseMessaging.onMessage.listen(_foreground.add);
    } catch (e) {
      // Without APNs / Play services (simulators, demo project) there is no token.
      if (kDebugMode) debugPrint('FCM unavailable: $e');
    }
  }

  Future<void> unregister(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _users.removeFcmToken(uid, token);
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
    await _tokenSub?.cancel();
    _tokenSub = null;
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService(ref.watch(userRepositoryProvider)));
