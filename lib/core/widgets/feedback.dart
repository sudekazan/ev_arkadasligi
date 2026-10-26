import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../firebase/app_error.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String errorMessage(AppLocalizations l, Object error) => switch (errorCodeOf(error)) {
      AppErrorCode.network => l.errorNetwork,
      AppErrorCode.permission => l.errorPermission,
      AppErrorCode.notFound => l.errorNotFound,
      AppErrorCode.invalidCredentials => l.errorInvalidCredentials,
      AppErrorCode.emailInUse => l.errorEmailInUse,
      AppErrorCode.weakPassword => l.errorWeakPassword,
      AppErrorCode.invalidEmail => l.errorInvalidEmail,
      AppErrorCode.tooManyRequests => l.errorTooManyRequests,
      AppErrorCode.cancelled => l.errorCancelled,
      AppErrorCode.requiresRecentLogin => l.errorRequiresRecentLogin,
      AppErrorCode.householdLimit => l.errorHouseholdLimit,
      AppErrorCode.householdFull => l.errorHouseholdFull,
      AppErrorCode.inviteInvalid => l.errorInviteInvalid,
      AppErrorCode.balanceNotZero => l.errorBalanceNotZero,
      AppErrorCode.receiptQuota => l.errorReceiptQuota,
      AppErrorCode.receiptUnreadable => l.errorReceiptUnreadable,
      AppErrorCode.reminderAlreadySent => l.errorReminderAlreadySent,
      AppErrorCode.nothingOwed => l.errorNothingOwed,
      AppErrorCode.unknown => l.errorUnknown,
    };

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Shows a translated error and reports unexpected ones; cancellations are silent.
void showError(BuildContext context, Object error, [StackTrace? stack]) {
  if (errorCodeOf(error) == AppErrorCode.cancelled) return;
  reportError(error, stack);
  showMessage(context, errorMessage(context.l10n, error));
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
