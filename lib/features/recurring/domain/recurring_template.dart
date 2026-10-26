import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/money/split_calculator.dart';
import '../../expenses/domain/expense.dart';

part 'recurring_template.freezed.dart';
part 'recurring_template.g.dart';

const freeRecurringLimit = 3;

enum RecurrenceFrequency { monthly, weekly }

/// `households/{hid}/recurring/{rid}`: produces an expense on each due date
/// via the `runRecurring` function.
@freezed
abstract class RecurringTemplate with _$RecurringTemplate {
  const RecurringTemplate._();

  const factory RecurringTemplate({
    @JsonKey(includeToJson: false) required String id,
    required String description,

    /// 0 for variable-amount templates.
    @Default(0) int amountMinor,
    required String paidBy,
    @JsonKey(unknownEnumValue: ExpenseCategory.other)
    @Default(ExpenseCategory.other)
    ExpenseCategory category,
    @JsonKey(unknownEnumValue: SplitType.equal) @Default(SplitType.equal) SplitType splitType,
    @Default(<String, int>{}) Map<String, int> splitInput,
    @Default('') String note,
    @Default(RecurrenceFrequency.monthly) RecurrenceFrequency frequency,
    int? dayOfMonth,
    int? dayOfWeek,
    @Default(true) bool fixedAmount,
    @TimestampConverter() required DateTime nextRunAt,
    @Default(true) bool active,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
  }) = _RecurringTemplate;

  factory RecurringTemplate.fromJson(Map<String, dynamic> json) =>
      _$RecurringTemplateFromJson(json);
}

/// First run date on or after [from] (local time). Mirrors functions/src/dates.ts;
/// months shorter than [dayOfMonth] use their last day.
DateTime firstRunDate({
  required RecurrenceFrequency frequency,
  int? dayOfMonth,
  int? dayOfWeek,
  required DateTime from,
}) {
  final today = DateTime(from.year, from.month, from.day);
  if (frequency == RecurrenceFrequency.weekly) {
    final delta = ((dayOfWeek ?? 1) - today.weekday + 7) % 7;
    return today.add(Duration(days: delta));
  }
  DateTime candidate(int year, int month) {
    final last = DateTime(year, month + 1, 0).day;
    final d = (dayOfMonth ?? 1) > last ? last : (dayOfMonth ?? 1);
    return DateTime(year, month, d);
  }

  final thisMonth = candidate(today.year, today.month);
  return thisMonth.isBefore(today) ? candidate(today.year, today.month + 1) : thisMonth;
}
