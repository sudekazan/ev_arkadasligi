// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Household _$HouseholdFromJson(Map<String, dynamic> json) => _Household(
  id: json['id'] as String,
  name: json['name'] as String,
  currency: json['currency'] as String? ?? 'TRY',
  createdBy: json['createdBy'] as String,
  adminIds:
      (json['adminIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  inviteCode: json['inviteCode'] as String? ?? '',
  proUntil: const NullableTimestampConverter().fromJson(json['proUntil']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$HouseholdToJson(_Household instance) =>
    <String, dynamic>{
      'name': instance.name,
      'currency': instance.currency,
      'createdBy': instance.createdBy,
      'adminIds': instance.adminIds,
      'memberIds': instance.memberIds,
      'inviteCode': instance.inviteCode,
      'proUntil': const NullableTimestampConverter().toJson(instance.proUntil),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  displayName: json['displayName'] as String? ?? '',
  avatarEmoji: json['avatarEmoji'] as String? ?? '🙂',
  iban: json['iban'] as String?,
  rentWeight: (json['rentWeight'] as num?)?.toInt() ?? 1,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt']),
  active: json['active'] as bool? ?? true,
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'avatarEmoji': instance.avatarEmoji,
  'iban': instance.iban,
  'rentWeight': instance.rentWeight,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'active': instance.active,
  'deleted': instance.deleted,
};
