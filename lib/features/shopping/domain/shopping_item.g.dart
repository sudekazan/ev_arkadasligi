// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) =>
    _ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String?,
      addedBy: json['addedBy'] as String,
      done: json['done'] as bool? ?? false,
      doneBy: json['doneBy'] as String?,
      doneAt: const NullableTimestampConverter().fromJson(json['doneAt']),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$ShoppingItemToJson(_ShoppingItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'addedBy': instance.addedBy,
      'done': instance.done,
      'doneBy': instance.doneBy,
      'doneAt': const NullableTimestampConverter().toJson(instance.doneAt),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
