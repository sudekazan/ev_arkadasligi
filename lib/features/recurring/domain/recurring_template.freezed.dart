// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringTemplate {

@JsonKey(includeToJson: false) String get id; String get description;/// 0 for variable-amount templates.
 int get amountMinor; String get paidBy;@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory get category;@JsonKey(unknownEnumValue: SplitType.equal) SplitType get splitType; Map<String, int> get splitInput; String get note; RecurrenceFrequency get frequency; int? get dayOfMonth; int? get dayOfWeek; bool get fixedAmount;@TimestampConverter() DateTime get nextRunAt; bool get active; String get createdBy;@TimestampConverter() DateTime get createdAt;
/// Create a copy of RecurringTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTemplateCopyWith<RecurringTemplate> get copyWith => _$RecurringTemplateCopyWithImpl<RecurringTemplate>(this as RecurringTemplate, _$identity);

  /// Serializes this RecurringTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecurringTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.paidBy, _this.paidBy) || other.paidBy == _this.paidBy)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.splitType, _this.splitType) || other.splitType == _this.splitType)&&const DeepCollectionEquality().equals(other.splitInput, _this.splitInput)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.dayOfMonth, _this.dayOfMonth) || other.dayOfMonth == _this.dayOfMonth)&&(identical(other.dayOfWeek, _this.dayOfWeek) || other.dayOfWeek == _this.dayOfWeek)&&(identical(other.fixedAmount, _this.fixedAmount) || other.fixedAmount == _this.fixedAmount)&&(identical(other.nextRunAt, _this.nextRunAt) || other.nextRunAt == _this.nextRunAt)&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecurringTemplate;
  return Object.hash(runtimeType,_this.id,_this.description,_this.amountMinor,_this.paidBy,_this.category,_this.splitType,const DeepCollectionEquality().hash(_this.splitInput),_this.note,_this.frequency,_this.dayOfMonth,_this.dayOfWeek,_this.fixedAmount,_this.nextRunAt,_this.active,_this.createdBy,_this.createdAt);
}

@override
String toString() {
  final _this = this as RecurringTemplate;
  return 'RecurringTemplate(id: ${_this.id}, description: ${_this.description}, amountMinor: ${_this.amountMinor}, paidBy: ${_this.paidBy}, category: ${_this.category}, splitType: ${_this.splitType}, splitInput: ${_this.splitInput}, note: ${_this.note}, frequency: ${_this.frequency}, dayOfMonth: ${_this.dayOfMonth}, dayOfWeek: ${_this.dayOfWeek}, fixedAmount: ${_this.fixedAmount}, nextRunAt: ${_this.nextRunAt}, active: ${_this.active}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RecurringTemplateCopyWith<$Res>  {
  factory $RecurringTemplateCopyWith(RecurringTemplate value, $Res Function(RecurringTemplate) _then) = _$RecurringTemplateCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String description, int amountMinor, String paidBy,@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory category,@JsonKey(unknownEnumValue: SplitType.equal) SplitType splitType, Map<String, int> splitInput, String note, RecurrenceFrequency frequency, int? dayOfMonth, int? dayOfWeek, bool fixedAmount,@TimestampConverter() DateTime nextRunAt, bool active, String createdBy,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$RecurringTemplateCopyWithImpl<$Res>
    implements $RecurringTemplateCopyWith<$Res> {
  _$RecurringTemplateCopyWithImpl(this._self, this._then);

  final RecurringTemplate _self;
  final $Res Function(RecurringTemplate) _then;

/// Create a copy of RecurringTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? amountMinor = null,Object? paidBy = null,Object? category = null,Object? splitType = null,Object? splitInput = null,Object? note = null,Object? frequency = null,Object? dayOfMonth = freezed,Object? dayOfWeek = freezed,Object? fixedAmount = null,Object? nextRunAt = null,Object? active = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(RecurringTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidBy: null == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as SplitType,splitInput: null == splitInput ? _self.splitInput : splitInput // ignore: cast_nullable_to_non_nullable
as Map<String, int>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int?,fixedAmount: null == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: null == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTemplate].
extension RecurringTemplatePatterns on RecurringTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTemplate value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  String note,  RecurrenceFrequency frequency,  int? dayOfMonth,  int? dayOfWeek,  bool fixedAmount, @TimestampConverter()  DateTime nextRunAt,  bool active,  String createdBy, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringTemplate() when $default != null:
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.category,_that.splitType,_that.splitInput,_that.note,_that.frequency,_that.dayOfMonth,_that.dayOfWeek,_that.fixedAmount,_that.nextRunAt,_that.active,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  String note,  RecurrenceFrequency frequency,  int? dayOfMonth,  int? dayOfWeek,  bool fixedAmount, @TimestampConverter()  DateTime nextRunAt,  bool active,  String createdBy, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RecurringTemplate():
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.category,_that.splitType,_that.splitInput,_that.note,_that.frequency,_that.dayOfMonth,_that.dayOfWeek,_that.fixedAmount,_that.nextRunAt,_that.active,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String description,  int amountMinor,  String paidBy, @JsonKey(unknownEnumValue: ExpenseCategory.other)  ExpenseCategory category, @JsonKey(unknownEnumValue: SplitType.equal)  SplitType splitType,  Map<String, int> splitInput,  String note,  RecurrenceFrequency frequency,  int? dayOfMonth,  int? dayOfWeek,  bool fixedAmount, @TimestampConverter()  DateTime nextRunAt,  bool active,  String createdBy, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RecurringTemplate() when $default != null:
return $default(_that.id,_that.description,_that.amountMinor,_that.paidBy,_that.category,_that.splitType,_that.splitInput,_that.note,_that.frequency,_that.dayOfMonth,_that.dayOfWeek,_that.fixedAmount,_that.nextRunAt,_that.active,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringTemplate extends RecurringTemplate {
  const _RecurringTemplate({@JsonKey(includeToJson: false) required this.id, required this.description, this.amountMinor = 0, required this.paidBy, @JsonKey(unknownEnumValue: ExpenseCategory.other) this.category = ExpenseCategory.other, @JsonKey(unknownEnumValue: SplitType.equal) this.splitType = SplitType.equal,  Map<String, int> splitInput = const <String, int>{}, this.note = '', this.frequency = RecurrenceFrequency.monthly, this.dayOfMonth, this.dayOfWeek, this.fixedAmount = true, @TimestampConverter() required this.nextRunAt, this.active = true, required this.createdBy, @TimestampConverter() required this.createdAt}): _splitInput = splitInput,super._();
  factory _RecurringTemplate.fromJson(Map<String, dynamic> json) => _$RecurringTemplateFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String description;
/// 0 for variable-amount templates.
@override@JsonKey() final  int amountMinor;
@override final  String paidBy;
@override@JsonKey(unknownEnumValue: ExpenseCategory.other) final  ExpenseCategory category;
@override@JsonKey(unknownEnumValue: SplitType.equal) final  SplitType splitType;
 final  Map<String, int> _splitInput;
@override@JsonKey() Map<String, int> get splitInput {
  if (_splitInput is EqualUnmodifiableMapView) return _splitInput;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_splitInput);
}

@override@JsonKey() final  String note;
@override@JsonKey() final  RecurrenceFrequency frequency;
@override final  int? dayOfMonth;
@override final  int? dayOfWeek;
@override@JsonKey() final  bool fixedAmount;
@override@TimestampConverter() final  DateTime nextRunAt;
@override@JsonKey() final  bool active;
@override final  String createdBy;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of RecurringTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTemplateCopyWith<_RecurringTemplate> get copyWith => __$RecurringTemplateCopyWithImpl<_RecurringTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.category, category) || other.category == category)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&const DeepCollectionEquality().equals(other.splitInput, _splitInput)&&(identical(other.note, note) || other.note == note)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.fixedAmount, fixedAmount) || other.fixedAmount == fixedAmount)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,description,amountMinor,paidBy,category,splitType,const DeepCollectionEquality().hash(_splitInput),note,frequency,dayOfMonth,dayOfWeek,fixedAmount,nextRunAt,active,createdBy,createdAt);
}

@override
String toString() {
    return 'RecurringTemplate(id: $id, description: $description, amountMinor: $amountMinor, paidBy: $paidBy, category: $category, splitType: $splitType, splitInput: $splitInput, note: $note, frequency: $frequency, dayOfMonth: $dayOfMonth, dayOfWeek: $dayOfWeek, fixedAmount: $fixedAmount, nextRunAt: $nextRunAt, active: $active, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RecurringTemplateCopyWith<$Res> implements $RecurringTemplateCopyWith<$Res> {
  factory _$RecurringTemplateCopyWith(_RecurringTemplate value, $Res Function(_RecurringTemplate) _then) = __$RecurringTemplateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String description, int amountMinor, String paidBy,@JsonKey(unknownEnumValue: ExpenseCategory.other) ExpenseCategory category,@JsonKey(unknownEnumValue: SplitType.equal) SplitType splitType, Map<String, int> splitInput, String note, RecurrenceFrequency frequency, int? dayOfMonth, int? dayOfWeek, bool fixedAmount,@TimestampConverter() DateTime nextRunAt, bool active, String createdBy,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$RecurringTemplateCopyWithImpl<$Res>
    implements _$RecurringTemplateCopyWith<$Res> {
  __$RecurringTemplateCopyWithImpl(this._self, this._then);

  final _RecurringTemplate _self;
  final $Res Function(_RecurringTemplate) _then;

/// Create a copy of RecurringTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? amountMinor = null,Object? paidBy = null,Object? category = null,Object? splitType = null,Object? splitInput = null,Object? note = null,Object? frequency = null,Object? dayOfMonth = freezed,Object? dayOfWeek = freezed,Object? fixedAmount = null,Object? nextRunAt = null,Object? active = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(_RecurringTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidBy: null == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as SplitType,splitInput: null == splitInput ? _self._splitInput : splitInput // ignore: cast_nullable_to_non_nullable
as Map<String, int>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int?,fixedAmount: null == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: null == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
