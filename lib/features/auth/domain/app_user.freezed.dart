// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

@JsonKey(includeToJson: false) String get id; String get displayName; String get avatarEmoji; String? get iban; String get locale; List<String> get householdIds; List<String> get fcmTokens; Map<String, bool> get notificationPrefs;@JsonKey(includeToJson: false)@NullableTimestampConverter() DateTime? get proUntil;@TimestampConverter() DateTime get createdAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarEmoji, _this.avatarEmoji) || other.avatarEmoji == _this.avatarEmoji)&&(identical(other.iban, _this.iban) || other.iban == _this.iban)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&const DeepCollectionEquality().equals(other.householdIds, _this.householdIds)&&const DeepCollectionEquality().equals(other.fcmTokens, _this.fcmTokens)&&const DeepCollectionEquality().equals(other.notificationPrefs, _this.notificationPrefs)&&(identical(other.proUntil, _this.proUntil) || other.proUntil == _this.proUntil)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.avatarEmoji,_this.iban,_this.locale,const DeepCollectionEquality().hash(_this.householdIds),const DeepCollectionEquality().hash(_this.fcmTokens),const DeepCollectionEquality().hash(_this.notificationPrefs),_this.proUntil,_this.createdAt);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(id: ${_this.id}, displayName: ${_this.displayName}, avatarEmoji: ${_this.avatarEmoji}, iban: ${_this.iban}, locale: ${_this.locale}, householdIds: ${_this.householdIds}, fcmTokens: ${_this.fcmTokens}, notificationPrefs: ${_this.notificationPrefs}, proUntil: ${_this.proUntil}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String displayName, String avatarEmoji, String? iban, String locale, List<String> householdIds, List<String> fcmTokens, Map<String, bool> notificationPrefs,@JsonKey(includeToJson: false)@NullableTimestampConverter() DateTime? proUntil,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? avatarEmoji = null,Object? iban = freezed,Object? locale = null,Object? householdIds = null,Object? fcmTokens = null,Object? notificationPrefs = null,Object? proUntil = freezed,Object? createdAt = null,}) {
  return _then(AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarEmoji: null == avatarEmoji ? _self.avatarEmoji : avatarEmoji // ignore: cast_nullable_to_non_nullable
as String,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,householdIds: null == householdIds ? _self.householdIds : householdIds // ignore: cast_nullable_to_non_nullable
as List<String>,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,notificationPrefs: null == notificationPrefs ? _self.notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  String locale,  List<String> householdIds,  List<String> fcmTokens,  Map<String, bool> notificationPrefs, @JsonKey(includeToJson: false)@NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.locale,_that.householdIds,_that.fcmTokens,_that.notificationPrefs,_that.proUntil,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  String locale,  List<String> householdIds,  List<String> fcmTokens,  Map<String, bool> notificationPrefs, @JsonKey(includeToJson: false)@NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.locale,_that.householdIds,_that.fcmTokens,_that.notificationPrefs,_that.proUntil,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String displayName,  String avatarEmoji,  String? iban,  String locale,  List<String> householdIds,  List<String> fcmTokens,  Map<String, bool> notificationPrefs, @JsonKey(includeToJson: false)@NullableTimestampConverter()  DateTime? proUntil, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarEmoji,_that.iban,_that.locale,_that.householdIds,_that.fcmTokens,_that.notificationPrefs,_that.proUntil,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({@JsonKey(includeToJson: false) required this.id, this.displayName = '', this.avatarEmoji = '🙂', this.iban, this.locale = 'tr',  List<String> householdIds = const <String>[],  List<String> fcmTokens = const <String>[],  Map<String, bool> notificationPrefs = const <String, bool>{}, @JsonKey(includeToJson: false)@NullableTimestampConverter() this.proUntil, @TimestampConverter() required this.createdAt}): _householdIds = householdIds,_fcmTokens = fcmTokens,_notificationPrefs = notificationPrefs,super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String avatarEmoji;
@override final  String? iban;
@override@JsonKey() final  String locale;
 final  List<String> _householdIds;
@override@JsonKey() List<String> get householdIds {
  if (_householdIds is EqualUnmodifiableListView) return _householdIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_householdIds);
}

 final  List<String> _fcmTokens;
@override@JsonKey() List<String> get fcmTokens {
  if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fcmTokens);
}

 final  Map<String, bool> _notificationPrefs;
@override@JsonKey() Map<String, bool> get notificationPrefs {
  if (_notificationPrefs is EqualUnmodifiableMapView) return _notificationPrefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_notificationPrefs);
}

@override@JsonKey(includeToJson: false)@NullableTimestampConverter() final  DateTime? proUntil;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarEmoji, avatarEmoji) || other.avatarEmoji == avatarEmoji)&&(identical(other.iban, iban) || other.iban == iban)&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other.householdIds, _householdIds)&&const DeepCollectionEquality().equals(other.fcmTokens, _fcmTokens)&&const DeepCollectionEquality().equals(other.notificationPrefs, _notificationPrefs)&&(identical(other.proUntil, proUntil) || other.proUntil == proUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,avatarEmoji,iban,locale,const DeepCollectionEquality().hash(_householdIds),const DeepCollectionEquality().hash(_fcmTokens),const DeepCollectionEquality().hash(_notificationPrefs),proUntil,createdAt);
}

@override
String toString() {
    return 'AppUser(id: $id, displayName: $displayName, avatarEmoji: $avatarEmoji, iban: $iban, locale: $locale, householdIds: $householdIds, fcmTokens: $fcmTokens, notificationPrefs: $notificationPrefs, proUntil: $proUntil, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String displayName, String avatarEmoji, String? iban, String locale, List<String> householdIds, List<String> fcmTokens, Map<String, bool> notificationPrefs,@JsonKey(includeToJson: false)@NullableTimestampConverter() DateTime? proUntil,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? avatarEmoji = null,Object? iban = freezed,Object? locale = null,Object? householdIds = null,Object? fcmTokens = null,Object? notificationPrefs = null,Object? proUntil = freezed,Object? createdAt = null,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarEmoji: null == avatarEmoji ? _self.avatarEmoji : avatarEmoji // ignore: cast_nullable_to_non_nullable
as String,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,householdIds: null == householdIds ? _self._householdIds : householdIds // ignore: cast_nullable_to_non_nullable
as List<String>,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,notificationPrefs: null == notificationPrefs ? _self._notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
