import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Notification categories a user can switch off; mirrored in functions.
abstract final class NotificationKind {
  static const newExpense = 'newExpense';
  static const reminders = 'reminders';
  static const chores = 'chores';
  static const bills = 'bills';
  static const all = [newExpense, reminders, bills, chores];
}

/// `users/{uid}`; only the owner reads it.
@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    @JsonKey(includeToJson: false) required String id,
    @Default('') String displayName,
    @Default('🙂') String avatarEmoji,
    String? iban,
    @Default('tr') String locale,
    @Default(<String>[]) List<String> householdIds,
    @Default(<String>[]) List<String> fcmTokens,
    @Default(<String, bool>{}) Map<String, bool> notificationPrefs,
    @JsonKey(includeToJson: false) @NullableTimestampConverter() DateTime? proUntil,
    @TimestampConverter() required DateTime createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  bool get hasOwnPro => proUntil != null && proUntil!.isAfter(DateTime.now());

  bool notificationsEnabled(String kind) => notificationPrefs[kind] ?? true;
}
