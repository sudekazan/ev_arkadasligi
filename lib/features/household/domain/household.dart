import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';

part 'household.freezed.dart';
part 'household.g.dart';

const maxHouseholdMembers = 12;

/// `households/{hid}`.
@freezed
abstract class Household with _$Household {
  const Household._();

  const factory Household({
    @JsonKey(includeToJson: false) required String id,
    required String name,
    @Default('TRY') String currency,
    required String createdBy,
    @Default(<String>[]) List<String> adminIds,
    @Default(<String>[]) List<String> memberIds,
    @Default('') String inviteCode,
    @NullableTimestampConverter() DateTime? proUntil,
    @TimestampConverter() required DateTime createdAt,
  }) = _Household;

  factory Household.fromJson(Map<String, dynamic> json) => _$HouseholdFromJson(json);

  bool get isPro => proUntil != null && proUntil!.isAfter(DateTime.now());

  bool isAdmin(String uid) => adminIds.contains(uid);
}

/// `households/{hid}/members/{uid}`: public profile within the household.
@freezed
abstract class Member with _$Member {
  const Member._();

  const factory Member({
    @JsonKey(includeToJson: false) required String id,
    @Default('') String displayName,
    @Default('🙂') String avatarEmoji,
    String? iban,
    @Default(1) int rentWeight,
    @TimestampConverter() required DateTime joinedAt,
    @Default(true) bool active,
    @Default(false) bool deleted,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
