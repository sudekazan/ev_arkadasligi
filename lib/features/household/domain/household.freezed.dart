// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Household {

@JsonKey(includeToJson: false) String get id; String get name; String get currency; String get createdBy; List<String> get adminIds; List<String> get memberIds; String get inviteCode;@NullableTimestampConverter() DateTime? get proUntil;@TimestampConverter() DateTime get createdAt;
/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdCopyWith<Household> get copyWith => _$HouseholdCopyWithImpl<Household>(this as Household, _$identity);

  /// Serializes this Household to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Household;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Household&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&const DeepCollectionEquality().equals(other.adminIds, _this.adminIds)&&const DeepCollectionEquality().equals(other.memberIds, _this.memberIds)&&(identical(other.inviteCode, _this.inviteCode) || other.inviteCode == _this.inviteCode)&&(identical(other.proUntil, _this.proUntil) || other.proUntil == _this.proUntil)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Household;
  return Object.hash(runtimeType,_this.id,_this.name,_this.currency,_this.createdBy,const DeepCollectionEquality().hash(_this.adminIds),const DeepCollectionEquality().hash(_this.memberIds),_this.inviteCode,_this.proUntil,_this.createdAt);
}

@override
String toString() {
  final _this = this as Household;
  return 'Household(id: ${_this.id}, name: ${_this.name}, currency: ${_this.currency}, createdBy: ${_this.createdBy}, adminIds: ${_this.adminIds}, memberIds: ${_this.memberIds}, inviteCode: ${_this.inviteCode}, proUntil: ${_this.proUntil}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $HouseholdCopyWith<$Res>  {
  factory $HouseholdCopyWith(Household value, $Res Function(Household) _then) = _$HouseholdCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String currency, String createdBy, List<String> adminIds, List<String> memberIds, String inviteCode,@NullableTimestampConverter() DateTime? proUntil,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$HouseholdCopyWithImpl<$Res>
    implements $HouseholdCopyWith<$Res> {
  _$HouseholdCopyWithImpl(this._self, this._then);

  final Household _self;
  final $Res Function(Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? currency = null,Object? createdBy = null,Object? adminIds = null,Object? memberIds = null,Object? inviteCode = null,Object? proUntil = freezed,Object? createdAt = null,}) {
  return _then(Household(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,adminIds: null == adminIds ? _self.adminIds : adminIds // ignore: cast_nullable_to_non_nullable
as List<String>,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Household].
extension HouseholdPatterns on Household {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Household value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Household value)  $default,){
final _that = this;
switch (_that) {
case _Household():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Household value)?  $default,){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String currency,  String createdBy,  List<String> adminIds,  List<String> memberIds,  String inviteCode, @NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.id,_that.name,_that.currency,_that.createdBy,_that.adminIds,_that.memberIds,_that.inviteCode,_that.proUntil,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String currency,  String createdBy,  List<String> adminIds,  List<String> memberIds,  String inviteCode, @NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Household():
return $default(_that.id,_that.name,_that.currency,_that.createdBy,_that.adminIds,_that.memberIds,_that.inviteCode,_that.proUntil,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String name,  String currency,  String createdBy,  List<String> adminIds,  List<String> memberIds,  String inviteCode, @NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.id,_that.name,_that.currency,_that.createdBy,_that.adminIds,_that.memberIds,_that.inviteCode,_that.proUntil,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Household extends Household {
  const _Household({@JsonKey(includeToJson: false) required this.id, required this.name, this.currency = 'TRY', required this.createdBy,  List<String> adminIds = const <String>[],  List<String> memberIds = const <String>[], this.inviteCode = '', @NullableTimestampConverter() this.proUntil, @TimestampConverter() required this.createdAt}): _adminIds = adminIds,_memberIds = memberIds,super._();
  factory _Household.fromJson(Map<String, dynamic> json) => _$HouseholdFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String name;
@override@JsonKey() final  String currency;
@override final  String createdBy;
 final  List<String> _adminIds;
@override@JsonKey() List<String> get adminIds {
  if (_adminIds is EqualUnmodifiableListView) return _adminIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_adminIds);
}

 final  List<String> _memberIds;
@override@JsonKey() List<String> get memberIds {
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberIds);
}

@override@JsonKey() final  String inviteCode;
@override@NullableTimestampConverter() final  DateTime? proUntil;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdCopyWith<_Household> get copyWith => __$HouseholdCopyWithImpl<_Household>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Household&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.adminIds, _adminIds)&&const DeepCollectionEquality().equals(other.memberIds, _memberIds)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.proUntil, proUntil) || other.proUntil == proUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,currency,createdBy,const DeepCollectionEquality().hash(_adminIds),const DeepCollectionEquality().hash(_memberIds),inviteCode,proUntil,createdAt);
}

@override
String toString() {
    return 'Household(id: $id, name: $name, currency: $currency, createdBy: $createdBy, adminIds: $adminIds, memberIds: $memberIds, inviteCode: $inviteCode, proUntil: $proUntil, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HouseholdCopyWith<$Res> implements $HouseholdCopyWith<$Res> {
  factory _$HouseholdCopyWith(_Household value, $Res Function(_Household) _then) = __$HouseholdCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String currency, String createdBy, List<String> adminIds, List<String> memberIds, String inviteCode,@NullableTimestampConverter() DateTime? proUntil,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$HouseholdCopyWithImpl<$Res>
    implements _$HouseholdCopyWith<$Res> {
  __$HouseholdCopyWithImpl(this._self, this._then);

  final _Household _self;
  final $Res Function(_Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? currency = null,Object? createdBy = null,Object? adminIds = null,Object? memberIds = null,Object? inviteCode = null,Object? proUntil = freezed,Object? createdAt = null,}) {
  return _then(_Household(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,adminIds: null == adminIds ? _self._adminIds : adminIds // ignore: cast_nullable_to_non_nullable
as List<String>,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Member {

@JsonKey(includeToJson: false) String get id; String get displayName; String get avatarEmoji; String? get iban; int get rentWeight;@TimestampConverter() DateTime get joinedAt; bool get active; bool get deleted;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Member;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarEmoji, _this.avatarEmoji) || other.avatarEmoji == _this.avatarEmoji)&&(identical(other.iban, _this.iban) || other.iban == _this.iban)&&(identical(other.rentWeight, _this.rentWeight) || other.rentWeight == _this.rentWeight)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Member;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.avatarEmoji,_this.iban,_this.rentWeight,_this.joinedAt,_this.active,_this.deleted);
}

@override
String toString() {
  final _this = this as Member;
  return 'Member(id: ${_this.id}, displayName: ${_this.displayName}, avatarEmoji: ${_this.avatarEmoji}, iban: ${_this.iban}, rentWeight: ${_this.rentWeight}, joinedAt: ${_this.joinedAt}, active: ${_this.active}, deleted: ${_this.deleted})';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String displayName, String avatarEmoji, String? iban, int rentWeight,@TimestampConverter() DateTime joinedAt, bool active, bool deleted
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? avatarEmoji = null,Object? iban = freezed,Object? rentWeight = null,Object? joinedAt = null,Object? active = null,Object? deleted = null,}) {
  return _then(Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarEmoji: null == avatarEmoji ? _self.avatarEmoji : avatarEmoji // ignore: cast_nullable_to_non_nullable
as String,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,rentWeight: null == rentWeight ? _self.rentWeight : rentWeight // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  int rentWeight, @TimestampConverter()  DateTime joinedAt,  bool active,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.rentWeight,_that.joinedAt,_that.active,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  int rentWeight, @TimestampConverter()  DateTime joinedAt,  bool active,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.rentWeight,_that.joinedAt,_that.active,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  int rentWeight, @TimestampConverter()  DateTime joinedAt,  bool active,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.rentWeight,_that.joinedAt,_that.active,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member extends Member {
  const _Member({@JsonKey(includeToJson: false) required this.id, this.displayName = '', this.avatarEmoji = '🙂', this.iban, this.rentWeight = 1, @TimestampConverter() required this.joinedAt, this.active = true, this.deleted = false}): super._();
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String avatarEmoji;
@override final  String? iban;
@override@JsonKey() final  int rentWeight;
@override@TimestampConverter() final  DateTime joinedAt;
@override@JsonKey() final  bool active;
@override@JsonKey() final  bool deleted;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarEmoji, avatarEmoji) || other.avatarEmoji == avatarEmoji)&&(identical(other.iban, iban) || other.iban == iban)&&(identical(other.rentWeight, rentWeight) || other.rentWeight == rentWeight)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.active, active) || other.active == active)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,avatarEmoji,iban,rentWeight,joinedAt,active,deleted);
}

@override
String toString() {
    return 'Member(id: $id, displayName: $displayName, avatarEmoji: $avatarEmoji, iban: $iban, rentWeight: $rentWeight, joinedAt: $joinedAt, active: $active, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String displayName, String avatarEmoji, String? iban, int rentWeight,@TimestampConverter() DateTime joinedAt, bool active, bool deleted
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? avatarEmoji = null,Object? iban = freezed,Object? rentWeight = null,Object? joinedAt = null,Object? active = null,Object? deleted = null,}) {
  return _then(_Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarEmoji: null == avatarEmoji ? _self.avatarEmoji : avatarEmoji // ignore: cast_nullable_to_non_nullable
as String,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,rentWeight: null == rentWeight ? _self.rentWeight : rentWeight // ignore: cast_nullable_to_non_nullable
as int,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
