// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringTemplate _$RecurringTemplateFromJson(Map<String, dynamic> json) =>
    _RecurringTemplate(
      id: json['id'] as String,
      description: json['description'] as String,
      amountMinor: (json['amountMinor'] as num?)?.toInt() ?? 0,
      paidBy: json['paidBy'] as String,
      category:
          $enumDecodeNullable(
            _$ExpenseCategoryEnumMap,
            json['category'],
            unknownValue: ExpenseCategory.other,
          ) ??
          ExpenseCategory.other,
      splitType:
          $enumDecodeNullable(
            _$SplitTypeEnumMap,
            json['splitType'],
            unknownValue: SplitType.equal,
          ) ??
          SplitType.equal,
      splitInput:
          (json['splitInput'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      note: json['note'] as String? ?? '',
      frequency:
          $enumDecodeNullable(
            _$RecurrenceFrequencyEnumMap,
            json['frequency'],
          ) ??
          RecurrenceFrequency.monthly,
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      fixedAmount: json['fixedAmount'] as bool? ?? true,
      nextRunAt: const TimestampConverter().fromJson(json['nextRunAt']),
      active: json['active'] as bool? ?? true,
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$RecurringTemplateToJson(_RecurringTemplate instance) =>
    <String, dynamic>{
      'description': instance.description,
      'amountMinor': instance.amountMinor,
      'paidBy': instance.paidBy,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'splitType': _$SplitTypeEnumMap[instance.splitType]!,
      'splitInput': instance.splitInput,
      'note': instance.note,
      'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
      'dayOfMonth': instance.dayOfMonth,
      'dayOfWeek': instance.dayOfWeek,
      'fixedAmount': instance.fixedAmount,
      'nextRunAt': const TimestampConverter().toJson(instance.nextRunAt),
      'active': instance.active,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.rent: 'rent',
  ExpenseCategory.electricity: 'electricity',
  ExpenseCategory.water: 'water',
  ExpenseCategory.gas: 'gas',
  ExpenseCategory.internet: 'internet',
  ExpenseCategory.groceries: 'groceries',
  ExpenseCategory.cleaning: 'cleaning',
  ExpenseCategory.homeGoods: 'homeGoods',
  ExpenseCategory.other: 'other',
};

const _$SplitTypeEnumMap = {
  SplitType.equal: 'equal',
  SplitType.exact: 'exact',
  SplitType.percent: 'percent',
  SplitType.shares: 'shares',
};

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.monthly: 'monthly',
  RecurrenceFrequency.weekly: 'weekly',
};
