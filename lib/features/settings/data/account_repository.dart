import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../../pro/data/pro_service.dart';
import 'notification_service.dart';

class AccountRepository {
  AccountRepository(this._functions, this._auth, this._notifications, this._pro);

  final FirebaseFunctions _functions;
  final AuthRepository _auth;
  final NotificationService _notifications;
  final ProService _pro;

  Future<void> signOut() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) await _notifications.unregister(uid);
    await _pro.logOut();
    await _auth.signOut();
  }

  /// Store requirement: removes the user from households and deletes the account.
  Future<void> deleteAccount() async {
    await _functions.httpsCallable('deleteAccount').call<Object?>();
    await _pro.logOut();
    await _auth.signOut();
  }
}

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(
    ref.watch(functionsProvider),
    ref.watch(authRepositoryProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(proServiceProvider),
  ),
);
