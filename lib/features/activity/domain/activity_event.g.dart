// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityEvent _$ActivityEventFromJson(Map<String, dynamic> json) =>
    _ActivityEvent(
      id: json['id'] as String,
      type: json['type'] as String,
      actorUid: json['actorUid'] as String,
      refId: json['refId'] as String?,
      params:
          json['params'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$ActivityEventToJson(_ActivityEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'actorUid': instance.actorUid,
      'refId': instance.refId,
      'params': instance.params,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
