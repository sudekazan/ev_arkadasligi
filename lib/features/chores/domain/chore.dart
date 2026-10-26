import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';

part 'chore.freezed.dart';
part 'chore.g.dart';

enum ChoreFrequency {
  daily(1),
  weekly(7),
  biweekly(14);

  const ChoreFrequency(this.days);

  final int days;
}

/// `households/{hid}/chores/{id}`.
@freezed
abstract class Chore with _$Chore {
  const Chore._();

  const factory Chore({
    @JsonKey(includeToJson: false) required String id,
    required String name,
    @Default(ChoreFrequency.weekly) ChoreFrequency frequency,
    @Default(<String>[]) List<String> rotation,
    @Default(0) int currentIndex,
    @TimestampConverter() required DateTime nextDueAt,
  }) = _Chore;

  factory Chore.fromJson(Map<String, dynamic> json) => _$ChoreFromJson(json);

  String? get currentUid => rotation.isEmpty ? null : rotation[currentIndex % rotation.length];

  String? get nextUid =>
      rotation.isEmpty ? null : rotation[(currentIndex + 1) % rotation.length];

  /// State after the current person marks it done at [now]: the turn moves on
  /// and the due date advances by one period from today.
  Chore completed(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return copyWith(
      currentIndex: rotation.isEmpty ? 0 : (currentIndex + 1) % rotation.length,
      nextDueAt: today.add(Duration(days: frequency.days)),
    );
  }

  bool isDue(DateTime now) =>
      !nextDueAt.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59));
}

/// `households/{hid}/choreLogs/{id}`.
@freezed
abstract class ChoreLog with _$ChoreLog {
  const factory ChoreLog({
    @JsonKey(includeToJson: false) required String id,
    required String choreId,
    required String doneBy,
    @TimestampConverter() required DateTime doneAt,
  }) = _ChoreLog;

  factory ChoreLog.fromJson(Map<String, dynamic> json) => _$ChoreLogFromJson(json);
}
