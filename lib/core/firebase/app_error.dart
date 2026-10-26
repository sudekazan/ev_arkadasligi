import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// User-facing error categories; each maps to a translated message.
enum AppErrorCode {
  network,
  permission,
  notFound,
  invalidCredentials,
  emailInUse,
  weakPassword,
  invalidEmail,
  tooManyRequests,
  cancelled,
  requiresRecentLogin,
  householdLimit,
  householdFull,
  inviteInvalid,
  balanceNotZero,
  receiptQuota,
  receiptUnreadable,
  reminderAlreadySent,
  nothingOwed,
  unknown,
}

/// Thrown by repositories for flows the user deliberately aborted.
class CancelledException implements Exception {
  const CancelledException();
}

class AppException implements Exception {
  const AppException(this.code, {this.details});

  final AppErrorCode code;
  final Map<String, Object?>? details;

  @override
  String toString() => 'AppException($code, $details)';
}

AppErrorCode errorCodeOf(Object error) {
  if (error is AppException) return error.code;
  if (error is CancelledException) return AppErrorCode.cancelled;
  if (error is FirebaseFunctionsException) {
    return switch (error.message) {
      'household-limit' => AppErrorCode.householdLimit,
      'household-full' => AppErrorCode.householdFull,
      'invite-code-invalid' => AppErrorCode.inviteInvalid,
      'balance-not-zero' => AppErrorCode.balanceNotZero,
      'receipt-quota' => AppErrorCode.receiptQuota,
      'receipt-unreadable' => AppErrorCode.receiptUnreadable,
      'reminder-already-sent' => AppErrorCode.reminderAlreadySent,
      'nothing-owed' => AppErrorCode.nothingOwed,
      _ => switch (error.code) {
          'unavailable' || 'deadline-exceeded' => AppErrorCode.network,
          'permission-denied' || 'unauthenticated' => AppErrorCode.permission,
          'not-found' => AppErrorCode.notFound,
          _ => AppErrorCode.unknown,
        },
    };
  }
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'wrong-password' || 'user-not-found' || 'invalid-credential' =>
        AppErrorCode.invalidCredentials,
      'email-already-in-use' => AppErrorCode.emailInUse,
      'weak-password' => AppErrorCode.weakPassword,
      'invalid-email' => AppErrorCode.invalidEmail,
      'too-many-requests' => AppErrorCode.tooManyRequests,
      'network-request-failed' => AppErrorCode.network,
      'requires-recent-login' => AppErrorCode.requiresRecentLogin,
      'web-context-canceled' || 'canceled' => AppErrorCode.cancelled,
      _ => AppErrorCode.unknown,
    };
  }
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' || 'unauthorized' => AppErrorCode.permission,
      'unavailable' => AppErrorCode.network,
      'not-found' || 'object-not-found' => AppErrorCode.notFound,
      _ => AppErrorCode.unknown,
    };
  }
  return AppErrorCode.unknown;
}

/// Sends unexpected errors to Crashlytics; technical details never reach the UI.
void reportError(Object error, [StackTrace? stack]) {
  if (kDebugMode) debugPrint('EvKasa error: $error\n$stack');
  final code = errorCodeOf(error);
  if (code == AppErrorCode.cancelled || code == AppErrorCode.network) return;
  if (Firebase.apps.isEmpty) return;
  unawaited(FirebaseCrashlytics.instance.recordError(error, stack));
}
