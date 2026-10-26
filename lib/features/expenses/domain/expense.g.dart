// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) => _ReceiptItem(
  name: json['name'] as String,
  amountMinor: (json['amountMinor'] as num).toInt(),
);

Map<String, dynamic> _$ReceiptItemToJson(_ReceiptItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amountMinor': instance.amountMinor,
    };

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  description: json['description'] as String,
  amountMinor: (json['amountMinor'] as num).toInt(),
  paidBy: json['paidBy'] as String,
  date: const TimestampConverter().fromJson(json['date']),
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
  shares:
      (json['shares'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  status:
      $enumDecodeNullable(_$ExpenseStatusEnumMap, json['status']) ??
      ExpenseStatus.finalized,
  recurringId: json['recurringId'] as String?,
  receiptPath: json['receiptPath'] as String?,
  receiptItems:
      (json['receiptItems'] as List<dynamic>?)
          ?.map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReceiptItem>[],
  note: json['note'] as String? ?? '',
  createdBy: json['createdBy'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'description': instance.description,
  'amountMinor': instance.amountMinor,
  'paidBy': instance.paidBy,
  'date': const TimestampConverter().toJson(instance.date),
  'category': _$ExpenseCategoryEnumMap[instance.category]!,
  'splitType': _$SplitTypeEnumMap[instance.splitType]!,
  'splitInput': instance.splitInput,
  'shares': instance.shares,
  'status': _$ExpenseStatusEnumMap[instance.status]!,
  'recurringId': instance.recurringId,
  'receiptPath': instance.receiptPath,
  'receiptItems': instance.receiptItems.map((e) => e.toJson()).toList(),
  'note': instance.note,
  'createdBy': instance.createdBy,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
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

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.finalized: 'final',
  ExpenseStatus.pendingAmount: 'pendingAmount',
};

_Settlement _$SettlementFromJson(Map<String, dynamic> json) => _Settlement(
  id: json['id'] as String,
  fromUid: json['fromUid'] as String,
  toUid: json['toUid'] as String,
  amountMinor: (json['amountMinor'] as num).toInt(),
  date: const TimestampConverter().fromJson(json['date']),
  note: json['note'] as String? ?? '',
  createdBy: json['createdBy'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$SettlementToJson(_Settlement instance) =>
    <String, dynamic>{
      'fromUid': instance.fromUid,
      'toUid': instance.toUid,
      'amountMinor': instance.amountMinor,
      'date': const TimestampConverter().toJson(instance.date),
      'note': instance.note,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
