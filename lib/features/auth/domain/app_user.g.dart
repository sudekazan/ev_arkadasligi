// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  displayName: json['displayName'] as String? ?? '',
  avatarEmoji: json['avatarEmoji'] as String? ?? '🙂',
  iban: json['iban'] as String?,
  locale: json['locale'] as String? ?? 'tr',
  householdIds:
      (json['householdIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  notificationPrefs:
      (json['notificationPrefs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const <String, bool>{},
  proUntil: const NullableTimestampConverter().fromJson(json['proUntil']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'avatarEmoji': instance.avatarEmoji,
  'iban': instance.iban,
  'locale': instance.locale,
  'householdIds': instance.householdIds,
  'fcmTokens': instance.fcmTokens,
  'notificationPrefs': instance.notificationPrefs,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};
