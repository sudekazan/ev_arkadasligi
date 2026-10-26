// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chore {

@JsonKey(includeToJson: false) String get id; String get name; ChoreFrequency get frequency; List<String> get rotation; int get currentIndex;@TimestampConverter() DateTime get nextDueAt;
/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoreCopyWith<Chore> get copyWith => _$ChoreCopyWithImpl<Chore>(this as Chore, _$identity);

  /// Serializes this Chore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Chore;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chore&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&const DeepCollectionEquality().equals(other.rotation, _this.rotation)&&(identical(other.currentIndex, _this.currentIndex) || other.currentIndex == _this.currentIndex)&&(identical(other.nextDueAt, _this.nextDueAt) || other.nextDueAt == _this.nextDueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Chore;
  return Object.hash(runtimeType,_this.id,_this.name,_this.frequency,const DeepCollectionEquality().hash(_this.rotation),_this.currentIndex,_this.nextDueAt);
}

@override
String toString() {
  final _this = this as Chore;
  return 'Chore(id: ${_this.id}, name: ${_this.name}, frequency: ${_this.frequency}, rotation: ${_this.rotation}, currentIndex: ${_this.currentIndex}, nextDueAt: ${_this.nextDueAt})';
}


}

/// @nodoc
abstract mixin class $ChoreCopyWith<$Res>  {
  factory $ChoreCopyWith(Chore value, $Res Function(Chore) _then) = _$ChoreCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, ChoreFrequency frequency, List<String> rotation, int currentIndex,@TimestampConverter() DateTime nextDueAt
});




}
/// @nodoc
class _$ChoreCopyWithImpl<$Res>
    implements $ChoreCopyWith<$Res> {
  _$ChoreCopyWithImpl(this._self, this._then);

  final Chore _self;
  final $Res Function(Chore) _then;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? frequency = null,Object? rotation = null,Object? currentIndex = null,Object? nextDueAt = null,}) {
  return _then(Chore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ChoreFrequency,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as List<String>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,nextDueAt: null == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Chore].
extension ChorePatterns on Chore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chore value)  $default,){
final _that = this;
switch (_that) {
case _Chore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chore value)?  $default,){
final _that = this;
switch (_that) {
case _Chore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  ChoreFrequency frequency,  List<String> rotation,  int currentIndex, @TimestampConverter()  DateTime nextDueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chore() when $default != null:
return $default(_that.id,_that.name,_that.frequency,_that.rotation,_that.currentIndex,_that.nextDueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  ChoreFrequency frequency,  List<String> rotation,  int currentIndex, @TimestampConverter()  DateTime nextDueAt)  $default,) {final _that = this;
switch (_that) {
case _Chore():
return $default(_that.id,_that.name,_that.frequency,_that.rotation,_that.currentIndex,_that.nextDueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String name,  ChoreFrequency frequency,  List<String> rotation,  int currentIndex, @TimestampConverter()  DateTime nextDueAt)?  $default,) {final _that = this;
switch (_that) {
case _Chore() when $default != null:
return $default(_that.id,_that.name,_that.frequency,_that.rotation,_that.currentIndex,_that.nextDueAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chore extends Chore {
  const _Chore({@JsonKey(includeToJson: false) required this.id, required this.name, this.frequency = ChoreFrequency.weekly,  List<String> rotation = const <String>[], this.currentIndex = 0, @TimestampConverter() required this.nextDueAt}): _rotation = rotation,super._();
  factory _Chore.fromJson(Map<String, dynamic> json) => _$ChoreFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String name;
@override@JsonKey() final  ChoreFrequency frequency;
 final  List<String> _rotation;
@override@JsonKey() List<String> get rotation {
  if (_rotation is EqualUnmodifiableListView) return _rotation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rotation);
}

@override@JsonKey() final  int currentIndex;
@override@TimestampConverter() final  DateTime nextDueAt;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChoreCopyWith<_Chore> get copyWith => __$ChoreCopyWithImpl<_Chore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoreToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&const DeepCollectionEquality().equals(other.rotation, _rotation)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.nextDueAt, nextDueAt) || other.nextDueAt == nextDueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,frequency,const DeepCollectionEquality().hash(_rotation),currentIndex,nextDueAt);
}

@override
String toString() {
    return 'Chore(id: $id, name: $name, frequency: $frequency, rotation: $rotation, currentIndex: $currentIndex, nextDueAt: $nextDueAt)';
}


}

/// @nodoc
abstract mixin class _$ChoreCopyWith<$Res> implements $ChoreCopyWith<$Res> {
  factory _$ChoreCopyWith(_Chore value, $Res Function(_Chore) _then) = __$ChoreCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, ChoreFrequency frequency, List<String> rotation, int currentIndex,@TimestampConverter() DateTime nextDueAt
});




}
/// @nodoc
class __$ChoreCopyWithImpl<$Res>
    implements _$ChoreCopyWith<$Res> {
  __$ChoreCopyWithImpl(this._self, this._then);

  final _Chore _self;
  final $Res Function(_Chore) _then;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? frequency = null,Object? rotation = null,Object? currentIndex = null,Object? nextDueAt = null,}) {
  return _then(_Chore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ChoreFrequency,rotation: null == rotation ? _self._rotation : rotation // ignore: cast_nullable_to_non_nullable
as List<String>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,nextDueAt: null == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChoreLog {

@JsonKey(includeToJson: false) String get id; String get choreId; String get doneBy;@TimestampConverter() DateTime get doneAt;
/// Create a copy of ChoreLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoreLogCopyWith<ChoreLog> get copyWith => _$ChoreLogCopyWithImpl<ChoreLog>(this as ChoreLog, _$identity);

  /// Serializes this ChoreLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChoreLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoreLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.choreId, _this.choreId) || other.choreId == _this.choreId)&&(identical(other.doneBy, _this.doneBy) || other.doneBy == _this.doneBy)&&(identical(other.doneAt, _this.doneAt) || other.doneAt == _this.doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChoreLog;
  return Object.hash(runtimeType,_this.id,_this.choreId,_this.doneBy,_this.doneAt);
}

@override
String toString() {
  final _this = this as ChoreLog;
  return 'ChoreLog(id: ${_this.id}, choreId: ${_this.choreId}, doneBy: ${_this.doneBy}, doneAt: ${_this.doneAt})';
}


}

/// @nodoc
abstract mixin class $ChoreLogCopyWith<$Res>  {
  factory $ChoreLogCopyWith(ChoreLog value, $Res Function(ChoreLog) _then) = _$ChoreLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String choreId, String doneBy,@TimestampConverter() DateTime doneAt
});




}
/// @nodoc
class _$ChoreLogCopyWithImpl<$Res>
    implements $ChoreLogCopyWith<$Res> {
  _$ChoreLogCopyWithImpl(this._self, this._then);

  final ChoreLog _self;
  final $Res Function(ChoreLog) _then;

/// Create a copy of ChoreLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? choreId = null,Object? doneBy = null,Object? doneAt = null,}) {
  return _then(ChoreLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,choreId: null == choreId ? _self.choreId : choreId // ignore: cast_nullable_to_non_nullable
as String,doneBy: null == doneBy ? _self.doneBy : doneBy // ignore: cast_nullable_to_non_nullable
as String,doneAt: null == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChoreLog].
extension ChoreLogPatterns on ChoreLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChoreLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChoreLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChoreLog value)  $default,){
final _that = this;
switch (_that) {
case _ChoreLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChoreLog value)?  $default,){
final _that = this;
switch (_that) {
case _ChoreLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String choreId,  String doneBy, @TimestampConverter()  DateTime doneAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChoreLog() when $default != null:
return $default(_that.id,_that.choreId,_that.doneBy,_that.doneAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String choreId,  String doneBy, @TimestampConverter()  DateTime doneAt)  $default,) {final _that = this;
switch (_that) {
case _ChoreLog():
return $default(_that.id,_that.choreId,_that.doneBy,_that.doneAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String choreId,  String doneBy, @TimestampConverter()  DateTime doneAt)?  $default,) {final _that = this;
switch (_that) {
case _ChoreLog() when $default != null:
return $default(_that.id,_that.choreId,_that.doneBy,_that.doneAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChoreLog implements ChoreLog {
  const _ChoreLog({@JsonKey(includeToJson: false) required this.id, required this.choreId, required this.doneBy, @TimestampConverter() required this.doneAt});
  factory _ChoreLog.fromJson(Map<String, dynamic> json) => _$ChoreLogFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String choreId;
@override final  String doneBy;
@override@TimestampConverter() final  DateTime doneAt;

/// Create a copy of ChoreLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChoreLogCopyWith<_ChoreLog> get copyWith => __$ChoreLogCopyWithImpl<_ChoreLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoreLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChoreLog&&(identical(other.id, id) || other.id == id)&&(identical(other.choreId, choreId) || other.choreId == choreId)&&(identical(other.doneBy, doneBy) || other.doneBy == doneBy)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,choreId,doneBy,doneAt);
}

@override
String toString() {
    return 'ChoreLog(id: $id, choreId: $choreId, doneBy: $doneBy, doneAt: $doneAt)';
}


}

/// @nodoc
abstract mixin class _$ChoreLogCopyWith<$Res> implements $ChoreLogCopyWith<$Res> {
  factory _$ChoreLogCopyWith(_ChoreLog value, $Res Function(_ChoreLog) _then) = __$ChoreLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String choreId, String doneBy,@TimestampConverter() DateTime doneAt
});




}
/// @nodoc
class __$ChoreLogCopyWithImpl<$Res>
    implements _$ChoreLogCopyWith<$Res> {
  __$ChoreLogCopyWithImpl(this._self, this._then);

  final _ChoreLog _self;
  final $Res Function(_ChoreLog) _then;

/// Create a copy of ChoreLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? choreId = null,Object? doneBy = null,Object? doneAt = null,}) {
  return _then(_ChoreLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,choreId: null == choreId ? _self.choreId : choreId // ignore: cast_nullable_to_non_nullable
as String,doneBy: null == doneBy ? _self.doneBy : doneBy // ignore: cast_nullable_to_non_nullable
as String,doneAt: null == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
