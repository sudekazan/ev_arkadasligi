import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/converters.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

/// `households/{hid}/shoppingItems/{id}`.
@freezed
abstract class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    @JsonKey(includeToJson: false) required String id,
    required String name,
    String? quantity,
    required String addedBy,
    @Default(false) bool done,
    String? doneBy,
    @NullableTimestampConverter() DateTime? doneAt,
    @TimestampConverter() required DateTime createdAt,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);
}
