// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionInfo {

 GrpcConnectionStatus get status; String? get errorMessage; int get reconnectAttempt;
/// Create a copy of ConnectionInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionInfoCopyWith<ConnectionInfo> get copyWith => _$ConnectionInfoCopyWithImpl<ConnectionInfo>(this as ConnectionInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionInfo&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.reconnectAttempt, reconnectAttempt) || other.reconnectAttempt == reconnectAttempt));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,reconnectAttempt);

@override
String toString() {
  return 'ConnectionInfo(status: $status, errorMessage: $errorMessage, reconnectAttempt: $reconnectAttempt)';
}


}

/// @nodoc
abstract mixin class $ConnectionInfoCopyWith<$Res>  {
  factory $ConnectionInfoCopyWith(ConnectionInfo value, $Res Function(ConnectionInfo) _then) = _$ConnectionInfoCopyWithImpl;
@useResult
$Res call({
 GrpcConnectionStatus status, String? errorMessage, int reconnectAttempt
});




}
/// @nodoc
class _$ConnectionInfoCopyWithImpl<$Res>
    implements $ConnectionInfoCopyWith<$Res> {
  _$ConnectionInfoCopyWithImpl(this._self, this._then);

  final ConnectionInfo _self;
  final $Res Function(ConnectionInfo) _then;

/// Create a copy of ConnectionInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = freezed,Object? reconnectAttempt = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GrpcConnectionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,reconnectAttempt: null == reconnectAttempt ? _self.reconnectAttempt : reconnectAttempt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionInfo].
extension ConnectionInfoPatterns on ConnectionInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionInfo value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GrpcConnectionStatus status,  String? errorMessage,  int reconnectAttempt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionInfo() when $default != null:
return $default(_that.status,_that.errorMessage,_that.reconnectAttempt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GrpcConnectionStatus status,  String? errorMessage,  int reconnectAttempt)  $default,) {final _that = this;
switch (_that) {
case _ConnectionInfo():
return $default(_that.status,_that.errorMessage,_that.reconnectAttempt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GrpcConnectionStatus status,  String? errorMessage,  int reconnectAttempt)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionInfo() when $default != null:
return $default(_that.status,_that.errorMessage,_that.reconnectAttempt);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectionInfo implements ConnectionInfo {
  const _ConnectionInfo({this.status = GrpcConnectionStatus.disconnected, this.errorMessage, this.reconnectAttempt = 0});
  

@override@JsonKey() final  GrpcConnectionStatus status;
@override final  String? errorMessage;
@override@JsonKey() final  int reconnectAttempt;

/// Create a copy of ConnectionInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionInfoCopyWith<_ConnectionInfo> get copyWith => __$ConnectionInfoCopyWithImpl<_ConnectionInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionInfo&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.reconnectAttempt, reconnectAttempt) || other.reconnectAttempt == reconnectAttempt));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,reconnectAttempt);

@override
String toString() {
  return 'ConnectionInfo(status: $status, errorMessage: $errorMessage, reconnectAttempt: $reconnectAttempt)';
}


}

/// @nodoc
abstract mixin class _$ConnectionInfoCopyWith<$Res> implements $ConnectionInfoCopyWith<$Res> {
  factory _$ConnectionInfoCopyWith(_ConnectionInfo value, $Res Function(_ConnectionInfo) _then) = __$ConnectionInfoCopyWithImpl;
@override @useResult
$Res call({
 GrpcConnectionStatus status, String? errorMessage, int reconnectAttempt
});




}
/// @nodoc
class __$ConnectionInfoCopyWithImpl<$Res>
    implements _$ConnectionInfoCopyWith<$Res> {
  __$ConnectionInfoCopyWithImpl(this._self, this._then);

  final _ConnectionInfo _self;
  final $Res Function(_ConnectionInfo) _then;

/// Create a copy of ConnectionInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = freezed,Object? reconnectAttempt = null,}) {
  return _then(_ConnectionInfo(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GrpcConnectionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,reconnectAttempt: null == reconnectAttempt ? _self.reconnectAttempt : reconnectAttempt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
