// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chore _$ChoreFromJson(Map<String, dynamic> json) => _Chore(
  id: json['id'] as String,
  name: json['name'] as String,
  frequency:
      $enumDecodeNullable(_$ChoreFrequencyEnumMap, json['frequency']) ??
      ChoreFrequency.weekly,
  rotation:
      (json['rotation'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
  nextDueAt: const TimestampConverter().fromJson(json['nextDueAt']),
);

Map<String, dynamic> _$ChoreToJson(_Chore instance) => <String, dynamic>{
  'name': instance.name,
  'frequency': _$ChoreFrequencyEnumMap[instance.frequency]!,
  'rotation': instance.rotation,
  'currentIndex': instance.currentIndex,
  'nextDueAt': const TimestampConverter().toJson(instance.nextDueAt),
};

const _$ChoreFrequencyEnumMap = {
  ChoreFrequency.daily: 'daily',
  ChoreFrequency.weekly: 'weekly',
  ChoreFrequency.biweekly: 'biweekly',
};

_ChoreLog _$ChoreLogFromJson(Map<String, dynamic> json) => _ChoreLog(
  id: json['id'] as String,
  choreId: json['choreId'] as String,
  doneBy: json['doneBy'] as String,
  doneAt: const TimestampConverter().fromJson(json['doneAt']),
);

Map<String, dynamic> _$ChoreLogToJson(_ChoreLog instance) => <String, dynamic>{
  'choreId': instance.choreId,
  'doneBy': instance.doneBy,
  'doneAt': const TimestampConverter().toJson(instance.doneAt),
};
