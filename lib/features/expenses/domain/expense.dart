import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/money/balance_calculator.dart';
import '../../../core/money/split_calculator.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

enum ExpenseCategory {
  rent,
  electricity,
  water,
  gas,
  internet,
  groceries,
  cleaning,
  homeGoods,
  other;

  String get emoji => switch (this) {
        rent => '🏠',
        electricity => '💡',
        water => '🚰',
        gas => '🔥',
        internet => '🌐',
        groceries => '🛒',
        cleaning => '🧽',
        homeGoods => '🛋️',
        other => '📦',
      };
}

enum ExpenseStatus {
  @JsonValue('final')
  finalized,
  pendingAmount,
}

@freezed
abstract class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({required String name, required int amountMinor}) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);
}

/// `households/{hid}/expenses/{eid}`.
@freezed
abstract class Expense with _$Expense {
  const Expense._();

  @JsonSerializable(explicitToJson: true)
  const factory Expense({
    @JsonKey(includeToJson: false) required String id,
    required String description,
    required int amountMinor,
    required String paidBy,
    @TimestampConverter() required DateTime date,
    @JsonKey(unknownEnumValue: ExpenseCategory.other)
    @Default(ExpenseCategory.other)
    ExpenseCategory category,
    @JsonKey(unknownEnumValue: SplitType.equal) @Default(SplitType.equal) SplitType splitType,

    /// Raw user input per uid (see [SplitCalculator.compute]); only used to
    /// refill the edit form.
    @Default(<String, int>{}) Map<String, int> splitInput,

    /// Computed shares in minor units; always add up to [amountMinor].
    @Default(<String, int>{}) Map<String, int> shares,
    @Default(ExpenseStatus.finalized) ExpenseStatus status,
    String? recurringId,
    String? receiptPath,
    @Default(<ReceiptItem>[]) List<ReceiptItem> receiptItems,
    @Default('') String note,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  bool get isPending => status == ExpenseStatus.pendingAmount;

  LedgerExpense toLedger() => LedgerExpense(
        paidBy: paidBy,
        amountMinor: amountMinor,
        shares: shares,
        isFinal: !isPending,
      );
}

/// `households/{hid}/settlements/{sid}`.
@freezed
abstract class Settlement with _$Settlement {
  const Settlement._();

  const factory Settlement({
    @JsonKey(includeToJson: false) required String id,
    required String fromUid,
    required String toUid,
    required int amountMinor,
    @TimestampConverter() required DateTime date,
    @Default('') String note,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

  LedgerSettlement toLedger() =>
      LedgerSettlement(fromUid: fromUid, toUid: toUid, amountMinor: amountMinor);
}
