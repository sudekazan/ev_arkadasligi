import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';

part 'activity_event.freezed.dart';
part 'activity_event.g.dart';

/// Activity types; functions write some of them (see functions/src).
abstract final class ActivityType {
  static const householdCreated = 'householdCreated';
  static const memberJoined = 'memberJoined';
  static const memberLeft = 'memberLeft';
  static const memberRemoved = 'memberRemoved';
  static const expenseAdded = 'expenseAdded';
  static const expenseEdited = 'expenseEdited';
  static const expenseDeleted = 'expenseDeleted';
  static const settlementAdded = 'settlementAdded';
  static const settlementDeleted = 'settlementDeleted';
  static const recurringCreated = 'recurringCreated';
  static const choreDone = 'choreDone';
  static const shoppingConverted = 'shoppingConverted';
}

/// `households/{hid}/activity/{id}`.
@freezed
abstract class ActivityEvent with _$ActivityEvent {
  const ActivityEvent._();

  const factory ActivityEvent({
    @JsonKey(includeToJson: false) required String id,
    required String type,
    required String actorUid,
    String? refId,
    @Default(<String, dynamic>{}) Map<String, dynamic> params,
    @TimestampConverter() required DateTime createdAt,
  }) = _ActivityEvent;

  factory ActivityEvent.fromJson(Map<String, dynamic> json) => _$ActivityEventFromJson(json);

  String param(String key) => params[key]?.toString() ?? '';

  int intParam(String key) => (params[key] as num?)?.toInt() ?? 0;
}
