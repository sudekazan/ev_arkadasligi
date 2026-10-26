// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptItem {

 String get name; int get amountMinor;
/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemCopyWith<ReceiptItem> get copyWith => _$ReceiptItemCopyWithImpl<ReceiptItem>(this as ReceiptItem, _$identity);

  /// Serializes this ReceiptItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItem&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptItem;
  return Object.hash(runtimeType,_this.name,_this.amountMinor);
}

@override
String toString() {
  final _this = this as ReceiptItem;
  return 'ReceiptItem(name: ${_this.name}, amountMinor: ${_this.amountMinor})';
}


}

/// @nodoc
abstract mixin class $ReceiptItemCopyWith<$Res>  {
  factory $ReceiptItemCopyWith(ReceiptItem value, $Res Function(ReceiptItem) _then) = _$ReceiptItemCopyWithImpl;
@useResult
$Res call({
 String name, int amountMinor
});




}
/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._self, this._then);

  final ReceiptItem _self;
  final $Res Function(ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? amountMinor = null,}) {
  return _then(ReceiptItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItem].
extension ReceiptItemPatterns on ReceiptItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int amountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.name,_that.amountMinor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int amountMinor)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem():
return $default(_that.name,_that.amountMinor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int amountMinor)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.name,_that.amountMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItem implements ReceiptItem {
  const _ReceiptItem({required this.name, required this.amountMinor});
  factory _ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);

@override final  String name;
@override final  int amountMinor;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemCopyWith<_ReceiptItem> get copyWith => __$ReceiptItemCopyWithImpl<_ReceiptItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItem&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,amountMinor);
}

@override
String toString() {
    return 'ReceiptItem(name: $name, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemCopyWith<$Res> implements $ReceiptItemCopyWith<$Res> {
  factory _$ReceiptItemCopyWith(_ReceiptItem value, $Res Function(_ReceiptItem) _then) = __$ReceiptItemCopyWithImpl;
@override @useResult
$Res call({
 String name, int amountMinor
});




}
/// @nodoc
class __$ReceiptItemCopyWithImpl<$Res>
    implements _$ReceiptItemCopyWith<$Res> {
  __$ReceiptItemCopyWithImpl(this._self, this._then);

  final _ReceiptItem _self;
  final $Res Function(_ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? amountMinor = null,}) {
  return _then(_ReceiptItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Expense {

@JsonKey(includeToJson: false) String get id; String get description; int get amountMinor; String get paidBy;@TimestampConverter() DateTime get date;@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory get category;@JsonKey(unknownEnumValue: SplitType.equal) SplitType get splitType;/// Raw user input per uid (see [SplitCalculator.compute]); only used to
/// refill the edit form.
 Map<String, int> get splitInput;/// Computed shares in minor units; always add up to [amountMinor].
 Map<String, int> get shares; ExpenseStatus get status; String? get recurringId; String? get receiptPath; List<ReceiptItem> get receiptItems; String get note; String get createdBy;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Expense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.paidBy, _this.paidBy) || other.paidBy == _this.paidBy)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.splitType, _this.splitType) || other.splitType == _this.splitType)&&const DeepCollectionEquality().equals(other.splitInput, _this.splitInput)&&const DeepCollectionEquality().equals(other.shares, _this.shares)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.recurringId, _this.recurringId) || other.recurringId == _this.recurringId)&&(identical(other.receiptPath, _this.receiptPath) || other.receiptPath == _this.receiptPath)&&const DeepCollectionEquality().equals(other.receiptItems, _this.receiptItems)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Expense;
  return Object.hash(runtimeType,_this.id,_this.description,_this.amountMinor,_this.paidBy,_this.date,_this.category,_this.splitType,const DeepCollectionEquality().hash(_this.splitInput),const DeepCollectionEquality().hash(_this.shares),_this.status,_this.recurringId,_this.receiptPath,const DeepCollectionEquality().hash(_this.receiptItems),_this.note,_this.createdBy,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Expense;
  return 'Expense(id: ${_this.id}, description: ${_this.description}, amountMinor: ${_this.amountMinor}, paidBy: ${_this.paidBy}, date: ${_this.date}, category: ${_this.category}, splitType: ${_this.splitType}, splitInput: ${_this.splitInput}, shares: ${_this.shares}, status: ${_this.status}, recurringId: ${_this.recurringId}, receiptPath: ${_this.receiptPath}, receiptItems: ${_this.receiptItems}, note: ${_this.note}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String description, int amountMinor, String paidBy,@TimestampConverter() DateTime date,@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory category,@JsonKey(unknownEnumValue: SplitType.equal) SplitType splitType, Map<String, int> splitInput, Map<String, int> shares, ExpenseStatus status, String? recurringId, String? receiptPath, List<ReceiptItem> receiptItems, String note, String createdBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? amountMinor = null,Object? paidBy = null,Object? date = null,Object? category = null,Object? splitType = null,Object? splitInput = null,Object? shares = null,Object? status = null,Object? recurringId = freezed,Object? receiptPath = freezed,Object? receiptItems = null,Object? note = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidBy: null == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as SplitType,splitInput: null == splitInput ? _self.splitInput : splitInput // ignore: cast_nullable_to_non_nullable
as Map<String, int>,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as Map<String, int>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseStatus,recurringId: freezed == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,receiptItems: null == receiptItems ? _self.receiptItems : receiptItems // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @TimestampConverter()  DateTime date, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  Map<String, int> shares,  ExpenseStatus status,  String? recurringId,  String? receiptPath,  List<ReceiptItem> receiptItems,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.date,_that.category,_that.splitType,_that.splitInput,_that.shares,_that.status,_that.recurringId,_that.receiptPath,_that.receiptItems,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @TimestampConverter()  DateTime date, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  Map<String, int> shares,  ExpenseStatus status,  String? recurringId,  String? receiptPath,  List<ReceiptItem> receiptItems,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.date,_that.category,_that.splitType,_that.splitInput,_that.shares,_that.status,_that.recurringId,_that.receiptPath,_that.receiptItems,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @TimestampConverter()  DateTime date, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  Map<String, int> shares,  ExpenseStatus status,  String? recurringId,  String? receiptPath,  List<ReceiptItem> receiptItems,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.date,_that.category,_that.splitType,_that.splitInput,_that.shares,_that.status,_that.recurringId,_that.receiptPath,_that.receiptItems,_that.note,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Expense extends Expense {
  const _Expense({@JsonKey(includeToJson: false) required this.id, required this.description, required this.amountMinor, required this.paidBy, @TimestampConverter() required this.date, @JsonKey(unknownEnumValue: ExpenseCategory.other) this.category = ExpenseCategory.other, @JsonKey(unknownEnumValue: SplitType.equal) this.splitType = SplitType.equal,  Map<String, int> splitInput = const <String, int>{},  Map<String, int> shares = const <String, int>{}, this.status = ExpenseStatus.finalized, this.recurringId, this.receiptPath,  List<ReceiptItem> receiptItems = const <ReceiptItem>[], this.note = '', required this.createdBy, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): _splitInput = splitInput,_shares = shares,_receiptItems = receiptItems,super._();
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String description;
@override final  int amountMinor;
@override final  String paidBy;
@override@TimestampConverter() final  DateTime date;
@override@JsonKey(unknownEnumValue: ExpenseCategory.other) final  ExpenseCategory category;
@override@JsonKey(unknownEnumValue: SplitType.equal) final  SplitType splitType;
/// Raw user input per uid (see [SplitCalculator.compute]); only used to
/// refill the edit form.
 final  Map<String, int> _splitInput;
/// Raw user input per uid (see [SplitCalculator.compute]); only used to
/// refill the edit form.
@override@JsonKey() Map<String, int> get splitInput {
  if (_splitInput is EqualUnmodifiableMapView) return _splitInput;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_splitInput);
}

/// Computed shares in minor units; always add up to [amountMinor].
 final  Map<String, int> _shares;
/// Computed shares in minor units; always add up to [amountMinor].
@override@JsonKey() Map<String, int> get shares {
  if (_shares is EqualUnmodifiableMapView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_shares);
}

@override@JsonKey() final  ExpenseStatus status;
@override final  String? recurringId;
@override final  String? receiptPath;
 final  List<ReceiptItem> _receiptItems;
@override@JsonKey() List<ReceiptItem> get receiptItems {
  if (_receiptItems is EqualUnmodifiableListView) return _receiptItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receiptItems);
}

@override@JsonKey() final  String note;
@override final  String createdBy;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.date, date) || other.date == date)&&(identical(other.category, category) || other.category == category)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&const DeepCollectionEquality().equals(other.splitInput, _splitInput)&&const DeepCollectionEquality().equals(other.shares, _shares)&&(identical(other.status, status) || other.status == status)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.receiptPath, receiptPath) || other.receiptPath == receiptPath)&&const DeepCollectionEquality().equals(other.receiptItems, _receiptItems)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,description,amountMinor,paidBy,date,category,splitType,const DeepCollectionEquality().hash(_splitInput),const DeepCollectionEquality().hash(_shares),status,recurringId,receiptPath,const DeepCollectionEquality().hash(_receiptItems),note,createdBy,createdAt,updatedAt);
}

@override
String toString() {
    return 'Expense(id: $id, description: $description, amountMinor: $amountMinor, paidBy: $paidBy, date: $date, category: $category, splitType: $splitType, splitInput: $splitInput, shares: $shares, status: $status, recurringId: $recurringId, receiptPath: $receiptPath, receiptItems: $receiptItems, note: $note, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String description, int amountMinor, String paidBy,@TimestampConverter() DateTime date,@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory category,@JsonKey(unknownEnumValue: SplitType.equal) SplitType splitType, Map<String, int> splitInput, Map<String, int> shares, ExpenseStatus status, String? recurringId, String? receiptPath, List<ReceiptItem> receiptItems, String note, String createdBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? amountMinor = null,Object? paidBy = null,Object? date = null,Object? category = null,Object? splitType = null,Object? splitInput = null,Object? shares = null,Object? status = null,Object? recurringId = freezed,Object? receiptPath = freezed,Object? receiptItems = null,Object? note = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidBy: null == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as SplitType,splitInput: null == splitInput ? _self._splitInput : splitInput // ignore: cast_nullable_to_non_nullable
as Map<String, int>,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as Map<String, int>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseStatus,recurringId: freezed == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,receiptItems: null == receiptItems ? _self._receiptItems : receiptItems // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Settlement {

@JsonKey(includeToJson: false) String get id; String get fromUid; String get toUid; int get amountMinor;@TimestampConverter() DateTime get date; String get note; String get createdBy;@TimestampConverter() DateTime get createdAt;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Settlement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fromUid, _this.fromUid) || other.fromUid == _this.fromUid)&&(identical(other.toUid, _this.toUid) || other.toUid == _this.toUid)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Settlement;
  return Object.hash(runtimeType,_this.id,_this.fromUid,_this.toUid,_this.amountMinor,_this.date,_this.note,_this.createdBy,_this.createdAt);
}

@override
String toString() {
  final _this = this as Settlement;
  return 'Settlement(id: ${_this.id}, fromUid: ${_this.fromUid}, toUid: ${_this.toUid}, amountMinor: ${_this.amountMinor}, date: ${_this.date}, note: ${_this.note}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String fromUid, String toUid, int amountMinor,@TimestampConverter() DateTime date, String note, String createdBy,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUid = null,Object? toUid = null,Object? amountMinor = null,Object? date = null,Object? note = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String toUid,  int amountMinor, @TimestampConverter()  DateTime date,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.fromUid,_that.toUid,_that.amountMinor,_that.date,_that.note,_that.createdBy,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String toUid,  int amountMinor, @TimestampConverter()  DateTime date,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.id,_that.fromUid,_that.toUid,_that.amountMinor,_that.date,_that.note,_that.createdBy,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String toUid,  int amountMinor, @TimestampConverter()  DateTime date,  String note,  String createdBy, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.fromUid,_that.toUid,_that.amountMinor,_that.date,_that.note,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settlement extends Settlement {
  const _Settlement({@JsonKey(includeToJson: false) required this.id, required this.fromUid, required this.toUid, required this.amountMinor, @TimestampConverter() required this.date, this.note = '', required this.createdBy, @TimestampConverter() required this.createdAt}): super._();
  factory _Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String fromUid;
@override final  String toUid;
@override final  int amountMinor;
@override@TimestampConverter() final  DateTime date;
@override@JsonKey() final  String note;
@override final  String createdBy;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.toUid, toUid) || other.toUid == toUid)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fromUid,toUid,amountMinor,date,note,createdBy,createdAt);
}

@override
String toString() {
    return 'Settlement(id: $id, fromUid: $fromUid, toUid: $toUid, amountMinor: $amountMinor, date: $date, note: $note, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String fromUid, String toUid, int amountMinor,@TimestampConverter() DateTime date, String note, String createdBy,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUid = null,Object? toUid = null,Object? amountMinor = null,Object? date = null,Object? note = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(_Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
