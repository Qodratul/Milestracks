// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {

 String get id; String get email; String get displayName; int get level; int get exp; int get coins; int get streakDays; String get mascotForm; bool get onboardingComplete;
/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDtoCopyWith<UserDto> get copyWith => _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.exp, _this.exp) || other.exp == _this.exp)&&(identical(other.coins, _this.coins) || other.coins == _this.coins)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.mascotForm, _this.mascotForm) || other.mascotForm == _this.mascotForm)&&(identical(other.onboardingComplete, _this.onboardingComplete) || other.onboardingComplete == _this.onboardingComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserDto;
  return Object.hash(runtimeType,_this.id,_this.email,_this.displayName,_this.level,_this.exp,_this.coins,_this.streakDays,_this.mascotForm,_this.onboardingComplete);
}

@override
String toString() {
  final _this = this as UserDto;
  return 'UserDto(id: ${_this.id}, email: ${_this.email}, displayName: ${_this.displayName}, level: ${_this.level}, exp: ${_this.exp}, coins: ${_this.coins}, streakDays: ${_this.streakDays}, mascotForm: ${_this.mascotForm}, onboardingComplete: ${_this.onboardingComplete})';
}


}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res>  {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) = _$UserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, int level, int exp, int coins, int streakDays, String mascotForm, bool onboardingComplete
});




}
/// @nodoc
class _$UserDtoCopyWithImpl<$Res>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? level = null,Object? exp = null,Object? coins = null,Object? streakDays = null,Object? mascotForm = null,Object? onboardingComplete = null,}) {
  return _then(UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,mascotForm: null == mascotForm ? _self.mascotForm : mascotForm // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDto value)  $default,){
final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  int level,  int exp,  int coins,  int streakDays,  String mascotForm,  bool onboardingComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.level,_that.exp,_that.coins,_that.streakDays,_that.mascotForm,_that.onboardingComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  int level,  int exp,  int coins,  int streakDays,  String mascotForm,  bool onboardingComplete)  $default,) {final _that = this;
switch (_that) {
case _UserDto():
return $default(_that.id,_that.email,_that.displayName,_that.level,_that.exp,_that.coins,_that.streakDays,_that.mascotForm,_that.onboardingComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  int level,  int exp,  int coins,  int streakDays,  String mascotForm,  bool onboardingComplete)?  $default,) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.level,_that.exp,_that.coins,_that.streakDays,_that.mascotForm,_that.onboardingComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDto implements UserDto {
  const _UserDto({required this.id, required this.email, required this.displayName, required this.level, required this.exp, required this.coins, required this.streakDays, required this.mascotForm, required this.onboardingComplete});
  factory _UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  int level;
@override final  int exp;
@override final  int coins;
@override final  int streakDays;
@override final  String mascotForm;
@override final  bool onboardingComplete;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDtoCopyWith<_UserDto> get copyWith => __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.level, level) || other.level == level)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.mascotForm, mascotForm) || other.mascotForm == mascotForm)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,displayName,level,exp,coins,streakDays,mascotForm,onboardingComplete);
}

@override
String toString() {
    return 'UserDto(id: $id, email: $email, displayName: $displayName, level: $level, exp: $exp, coins: $coins, streakDays: $streakDays, mascotForm: $mascotForm, onboardingComplete: $onboardingComplete)';
}


}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) = __$UserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, int level, int exp, int coins, int streakDays, String mascotForm, bool onboardingComplete
});




}
/// @nodoc
class __$UserDtoCopyWithImpl<$Res>
    implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? level = null,Object? exp = null,Object? coins = null,Object? streakDays = null,Object? mascotForm = null,Object? onboardingComplete = null,}) {
  return _then(_UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,mascotForm: null == mascotForm ? _self.mascotForm : mascotForm // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AuthTokensDto {

 String get accessToken; String get refreshToken; AuthUserDto get user; String? get accessTokenExpiresAt; bool? get emailVerificationRequired;
/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokensDtoCopyWith<AuthTokensDto> get copyWith => _$AuthTokensDtoCopyWithImpl<AuthTokensDto>(this as AuthTokensDto, _$identity);

  /// Serializes this AuthTokensDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthTokensDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokensDto&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.accessTokenExpiresAt, _this.accessTokenExpiresAt) || other.accessTokenExpiresAt == _this.accessTokenExpiresAt)&&(identical(other.emailVerificationRequired, _this.emailVerificationRequired) || other.emailVerificationRequired == _this.emailVerificationRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthTokensDto;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.user,_this.accessTokenExpiresAt,_this.emailVerificationRequired);
}

@override
String toString() {
  final _this = this as AuthTokensDto;
  return 'AuthTokensDto(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, user: ${_this.user}, accessTokenExpiresAt: ${_this.accessTokenExpiresAt}, emailVerificationRequired: ${_this.emailVerificationRequired})';
}


}

/// @nodoc
abstract mixin class $AuthTokensDtoCopyWith<$Res>  {
  factory $AuthTokensDtoCopyWith(AuthTokensDto value, $Res Function(AuthTokensDto) _then) = _$AuthTokensDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, AuthUserDto user, String? accessTokenExpiresAt, bool? emailVerificationRequired
});


$AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthTokensDtoCopyWithImpl<$Res>
    implements $AuthTokensDtoCopyWith<$Res> {
  _$AuthTokensDtoCopyWithImpl(this._self, this._then);

  final AuthTokensDto _self;
  final $Res Function(AuthTokensDto) _then;

/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,Object? accessTokenExpiresAt = freezed,Object? emailVerificationRequired = freezed,}) {
  return _then(AuthTokensDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,accessTokenExpiresAt: freezed == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,emailVerificationRequired: freezed == emailVerificationRequired ? _self.emailVerificationRequired : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthTokensDto].
extension AuthTokensDtoPatterns on AuthTokensDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokensDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokensDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokensDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokensDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokensDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokensDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AuthUserDto user,  String? accessTokenExpiresAt,  bool? emailVerificationRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokensDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.accessTokenExpiresAt,_that.emailVerificationRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AuthUserDto user,  String? accessTokenExpiresAt,  bool? emailVerificationRequired)  $default,) {final _that = this;
switch (_that) {
case _AuthTokensDto():
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.accessTokenExpiresAt,_that.emailVerificationRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  AuthUserDto user,  String? accessTokenExpiresAt,  bool? emailVerificationRequired)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokensDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.accessTokenExpiresAt,_that.emailVerificationRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokensDto implements AuthTokensDto {
  const _AuthTokensDto({required this.accessToken, required this.refreshToken, required this.user, this.accessTokenExpiresAt, this.emailVerificationRequired});
  factory _AuthTokensDto.fromJson(Map<String, dynamic> json) => _$AuthTokensDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  AuthUserDto user;
@override final  String? accessTokenExpiresAt;
@override final  bool? emailVerificationRequired;

/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokensDtoCopyWith<_AuthTokensDto> get copyWith => __$AuthTokensDtoCopyWithImpl<_AuthTokensDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokensDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokensDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.emailVerificationRequired, emailVerificationRequired) || other.emailVerificationRequired == emailVerificationRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,user,accessTokenExpiresAt,emailVerificationRequired);
}

@override
String toString() {
    return 'AuthTokensDto(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, accessTokenExpiresAt: $accessTokenExpiresAt, emailVerificationRequired: $emailVerificationRequired)';
}


}

/// @nodoc
abstract mixin class _$AuthTokensDtoCopyWith<$Res> implements $AuthTokensDtoCopyWith<$Res> {
  factory _$AuthTokensDtoCopyWith(_AuthTokensDto value, $Res Function(_AuthTokensDto) _then) = __$AuthTokensDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, AuthUserDto user, String? accessTokenExpiresAt, bool? emailVerificationRequired
});


@override $AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthTokensDtoCopyWithImpl<$Res>
    implements _$AuthTokensDtoCopyWith<$Res> {
  __$AuthTokensDtoCopyWithImpl(this._self, this._then);

  final _AuthTokensDto _self;
  final $Res Function(_AuthTokensDto) _then;

/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,Object? accessTokenExpiresAt = freezed,Object? emailVerificationRequired = freezed,}) {
  return _then(_AuthTokensDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,accessTokenExpiresAt: freezed == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,emailVerificationRequired: freezed == emailVerificationRequired ? _self.emailVerificationRequired : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of AuthTokensDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$AuthUserDto {

 String get id; String get email; String get displayName; bool get emailVerified; String get locale;
/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<AuthUserDto> get copyWith => _$AuthUserDtoCopyWithImpl<AuthUserDto>(this as AuthUserDto, _$identity);

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthUserDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUserDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.emailVerified, _this.emailVerified) || other.emailVerified == _this.emailVerified)&&(identical(other.locale, _this.locale) || other.locale == _this.locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthUserDto;
  return Object.hash(runtimeType,_this.id,_this.email,_this.displayName,_this.emailVerified,_this.locale);
}

@override
String toString() {
  final _this = this as AuthUserDto;
  return 'AuthUserDto(id: ${_this.id}, email: ${_this.email}, displayName: ${_this.displayName}, emailVerified: ${_this.emailVerified}, locale: ${_this.locale})';
}


}

/// @nodoc
abstract mixin class $AuthUserDtoCopyWith<$Res>  {
  factory $AuthUserDtoCopyWith(AuthUserDto value, $Res Function(AuthUserDto) _then) = _$AuthUserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, bool emailVerified, String locale
});




}
/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._self, this._then);

  final AuthUserDto _self;
  final $Res Function(AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? emailVerified = null,Object? locale = null,}) {
  return _then(AuthUserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUserDto].
extension AuthUserDtoPatterns on AuthUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUserDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  bool emailVerified,  String locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.emailVerified,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  bool emailVerified,  String locale)  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto():
return $default(_that.id,_that.email,_that.displayName,_that.emailVerified,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  bool emailVerified,  String locale)?  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.emailVerified,_that.locale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUserDto implements AuthUserDto {
  const _AuthUserDto({required this.id, required this.email, required this.displayName, required this.emailVerified, required this.locale});
  factory _AuthUserDto.fromJson(Map<String, dynamic> json) => _$AuthUserDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  bool emailVerified;
@override final  String locale;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserDtoCopyWith<_AuthUserDto> get copyWith => __$AuthUserDtoCopyWithImpl<_AuthUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,displayName,emailVerified,locale);
}

@override
String toString() {
    return 'AuthUserDto(id: $id, email: $email, displayName: $displayName, emailVerified: $emailVerified, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$AuthUserDtoCopyWith<$Res> implements $AuthUserDtoCopyWith<$Res> {
  factory _$AuthUserDtoCopyWith(_AuthUserDto value, $Res Function(_AuthUserDto) _then) = __$AuthUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, bool emailVerified, String locale
});




}
/// @nodoc
class __$AuthUserDtoCopyWithImpl<$Res>
    implements _$AuthUserDtoCopyWith<$Res> {
  __$AuthUserDtoCopyWithImpl(this._self, this._then);

  final _AuthUserDto _self;
  final $Res Function(_AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? emailVerified = null,Object? locale = null,}) {
  return _then(_AuthUserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RefreshedTokensDto {

 String get accessToken; String get refreshToken;
/// Create a copy of RefreshedTokensDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshedTokensDtoCopyWith<RefreshedTokensDto> get copyWith => _$RefreshedTokensDtoCopyWithImpl<RefreshedTokensDto>(this as RefreshedTokensDto, _$identity);

  /// Serializes this RefreshedTokensDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefreshedTokensDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshedTokensDto&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefreshedTokensDto;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken);
}

@override
String toString() {
  final _this = this as RefreshedTokensDto;
  return 'RefreshedTokensDto(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken})';
}


}

/// @nodoc
abstract mixin class $RefreshedTokensDtoCopyWith<$Res>  {
  factory $RefreshedTokensDtoCopyWith(RefreshedTokensDto value, $Res Function(RefreshedTokensDto) _then) = _$RefreshedTokensDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class _$RefreshedTokensDtoCopyWithImpl<$Res>
    implements $RefreshedTokensDtoCopyWith<$Res> {
  _$RefreshedTokensDtoCopyWithImpl(this._self, this._then);

  final RefreshedTokensDto _self;
  final $Res Function(RefreshedTokensDto) _then;

/// Create a copy of RefreshedTokensDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(RefreshedTokensDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RefreshedTokensDto].
extension RefreshedTokensDtoPatterns on RefreshedTokensDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefreshedTokensDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefreshedTokensDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefreshedTokensDto value)  $default,){
final _that = this;
switch (_that) {
case _RefreshedTokensDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefreshedTokensDto value)?  $default,){
final _that = this;
switch (_that) {
case _RefreshedTokensDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefreshedTokensDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _RefreshedTokensDto():
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _RefreshedTokensDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefreshedTokensDto implements RefreshedTokensDto {
  const _RefreshedTokensDto({required this.accessToken, required this.refreshToken});
  factory _RefreshedTokensDto.fromJson(Map<String, dynamic> json) => _$RefreshedTokensDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;

/// Create a copy of RefreshedTokensDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshedTokensDtoCopyWith<_RefreshedTokensDto> get copyWith => __$RefreshedTokensDtoCopyWithImpl<_RefreshedTokensDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefreshedTokensDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshedTokensDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken);
}

@override
String toString() {
    return 'RefreshedTokensDto(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$RefreshedTokensDtoCopyWith<$Res> implements $RefreshedTokensDtoCopyWith<$Res> {
  factory _$RefreshedTokensDtoCopyWith(_RefreshedTokensDto value, $Res Function(_RefreshedTokensDto) _then) = __$RefreshedTokensDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class __$RefreshedTokensDtoCopyWithImpl<$Res>
    implements _$RefreshedTokensDtoCopyWith<$Res> {
  __$RefreshedTokensDtoCopyWithImpl(this._self, this._then);

  final _RefreshedTokensDto _self;
  final $Res Function(_RefreshedTokensDto) _then;

/// Create a copy of RefreshedTokensDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_RefreshedTokensDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CredentialsRequestDto {

 String get email; String get password;@JsonKey(includeIfNull: false) String? get displayName;@JsonKey(includeIfNull: false) String? get locale;@JsonKey(includeIfNull: false) String? get timezone;
/// Create a copy of CredentialsRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CredentialsRequestDtoCopyWith<CredentialsRequestDto> get copyWith => _$CredentialsRequestDtoCopyWithImpl<CredentialsRequestDto>(this as CredentialsRequestDto, _$identity);

  /// Serializes this CredentialsRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CredentialsRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CredentialsRequestDto&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CredentialsRequestDto;
  return Object.hash(runtimeType,_this.email,_this.password,_this.displayName,_this.locale,_this.timezone);
}

@override
String toString() {
  final _this = this as CredentialsRequestDto;
  return 'CredentialsRequestDto(email: ${_this.email}, password: ${_this.password}, displayName: ${_this.displayName}, locale: ${_this.locale}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $CredentialsRequestDtoCopyWith<$Res>  {
  factory $CredentialsRequestDtoCopyWith(CredentialsRequestDto value, $Res Function(CredentialsRequestDto) _then) = _$CredentialsRequestDtoCopyWithImpl;
@useResult
$Res call({
 String email, String password,@JsonKey(includeIfNull: false) String? displayName,@JsonKey(includeIfNull: false) String? locale,@JsonKey(includeIfNull: false) String? timezone
});




}
/// @nodoc
class _$CredentialsRequestDtoCopyWithImpl<$Res>
    implements $CredentialsRequestDtoCopyWith<$Res> {
  _$CredentialsRequestDtoCopyWithImpl(this._self, this._then);

  final CredentialsRequestDto _self;
  final $Res Function(CredentialsRequestDto) _then;

/// Create a copy of CredentialsRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? displayName = freezed,Object? locale = freezed,Object? timezone = freezed,}) {
  return _then(CredentialsRequestDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CredentialsRequestDto].
extension CredentialsRequestDtoPatterns on CredentialsRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CredentialsRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CredentialsRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CredentialsRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CredentialsRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CredentialsRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CredentialsRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password, @JsonKey(includeIfNull: false)  String? displayName, @JsonKey(includeIfNull: false)  String? locale, @JsonKey(includeIfNull: false)  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CredentialsRequestDto() when $default != null:
return $default(_that.email,_that.password,_that.displayName,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password, @JsonKey(includeIfNull: false)  String? displayName, @JsonKey(includeIfNull: false)  String? locale, @JsonKey(includeIfNull: false)  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _CredentialsRequestDto():
return $default(_that.email,_that.password,_that.displayName,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password, @JsonKey(includeIfNull: false)  String? displayName, @JsonKey(includeIfNull: false)  String? locale, @JsonKey(includeIfNull: false)  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _CredentialsRequestDto() when $default != null:
return $default(_that.email,_that.password,_that.displayName,_that.locale,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CredentialsRequestDto implements CredentialsRequestDto {
  const _CredentialsRequestDto({required this.email, required this.password, @JsonKey(includeIfNull: false) this.displayName, @JsonKey(includeIfNull: false) this.locale, @JsonKey(includeIfNull: false) this.timezone});
  factory _CredentialsRequestDto.fromJson(Map<String, dynamic> json) => _$CredentialsRequestDtoFromJson(json);

@override final  String email;
@override final  String password;
@override@JsonKey(includeIfNull: false) final  String? displayName;
@override@JsonKey(includeIfNull: false) final  String? locale;
@override@JsonKey(includeIfNull: false) final  String? timezone;

/// Create a copy of CredentialsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CredentialsRequestDtoCopyWith<_CredentialsRequestDto> get copyWith => __$CredentialsRequestDtoCopyWithImpl<_CredentialsRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CredentialsRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CredentialsRequestDto&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,password,displayName,locale,timezone);
}

@override
String toString() {
    return 'CredentialsRequestDto(email: $email, password: $password, displayName: $displayName, locale: $locale, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$CredentialsRequestDtoCopyWith<$Res> implements $CredentialsRequestDtoCopyWith<$Res> {
  factory _$CredentialsRequestDtoCopyWith(_CredentialsRequestDto value, $Res Function(_CredentialsRequestDto) _then) = __$CredentialsRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String email, String password,@JsonKey(includeIfNull: false) String? displayName,@JsonKey(includeIfNull: false) String? locale,@JsonKey(includeIfNull: false) String? timezone
});




}
/// @nodoc
class __$CredentialsRequestDtoCopyWithImpl<$Res>
    implements _$CredentialsRequestDtoCopyWith<$Res> {
  __$CredentialsRequestDtoCopyWithImpl(this._self, this._then);

  final _CredentialsRequestDto _self;
  final $Res Function(_CredentialsRequestDto) _then;

/// Create a copy of CredentialsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? displayName = freezed,Object? locale = freezed,Object? timezone = freezed,}) {
  return _then(_CredentialsRequestDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GoogleAuthRequestDto {

 String get idToken; String get locale; String get timezone;
/// Create a copy of GoogleAuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoogleAuthRequestDtoCopyWith<GoogleAuthRequestDto> get copyWith => _$GoogleAuthRequestDtoCopyWithImpl<GoogleAuthRequestDto>(this as GoogleAuthRequestDto, _$identity);

  /// Serializes this GoogleAuthRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoogleAuthRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleAuthRequestDto&&(identical(other.idToken, _this.idToken) || other.idToken == _this.idToken)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoogleAuthRequestDto;
  return Object.hash(runtimeType,_this.idToken,_this.locale,_this.timezone);
}

@override
String toString() {
  final _this = this as GoogleAuthRequestDto;
  return 'GoogleAuthRequestDto(idToken: ${_this.idToken}, locale: ${_this.locale}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $GoogleAuthRequestDtoCopyWith<$Res>  {
  factory $GoogleAuthRequestDtoCopyWith(GoogleAuthRequestDto value, $Res Function(GoogleAuthRequestDto) _then) = _$GoogleAuthRequestDtoCopyWithImpl;
@useResult
$Res call({
 String idToken, String locale, String timezone
});




}
/// @nodoc
class _$GoogleAuthRequestDtoCopyWithImpl<$Res>
    implements $GoogleAuthRequestDtoCopyWith<$Res> {
  _$GoogleAuthRequestDtoCopyWithImpl(this._self, this._then);

  final GoogleAuthRequestDto _self;
  final $Res Function(GoogleAuthRequestDto) _then;

/// Create a copy of GoogleAuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,Object? locale = null,Object? timezone = null,}) {
  return _then(GoogleAuthRequestDto(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GoogleAuthRequestDto].
extension GoogleAuthRequestDtoPatterns on GoogleAuthRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoogleAuthRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoogleAuthRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoogleAuthRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _GoogleAuthRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoogleAuthRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _GoogleAuthRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken,  String locale,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoogleAuthRequestDto() when $default != null:
return $default(_that.idToken,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken,  String locale,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _GoogleAuthRequestDto():
return $default(_that.idToken,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken,  String locale,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _GoogleAuthRequestDto() when $default != null:
return $default(_that.idToken,_that.locale,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoogleAuthRequestDto implements GoogleAuthRequestDto {
  const _GoogleAuthRequestDto({required this.idToken, required this.locale, required this.timezone});
  factory _GoogleAuthRequestDto.fromJson(Map<String, dynamic> json) => _$GoogleAuthRequestDtoFromJson(json);

@override final  String idToken;
@override final  String locale;
@override final  String timezone;

/// Create a copy of GoogleAuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoogleAuthRequestDtoCopyWith<_GoogleAuthRequestDto> get copyWith => __$GoogleAuthRequestDtoCopyWithImpl<_GoogleAuthRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoogleAuthRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleAuthRequestDto&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,idToken,locale,timezone);
}

@override
String toString() {
    return 'GoogleAuthRequestDto(idToken: $idToken, locale: $locale, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$GoogleAuthRequestDtoCopyWith<$Res> implements $GoogleAuthRequestDtoCopyWith<$Res> {
  factory _$GoogleAuthRequestDtoCopyWith(_GoogleAuthRequestDto value, $Res Function(_GoogleAuthRequestDto) _then) = __$GoogleAuthRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String idToken, String locale, String timezone
});




}
/// @nodoc
class __$GoogleAuthRequestDtoCopyWithImpl<$Res>
    implements _$GoogleAuthRequestDtoCopyWith<$Res> {
  __$GoogleAuthRequestDtoCopyWithImpl(this._self, this._then);

  final _GoogleAuthRequestDto _self;
  final $Res Function(_GoogleAuthRequestDto) _then;

/// Create a copy of GoogleAuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,Object? locale = null,Object? timezone = null,}) {
  return _then(_GoogleAuthRequestDto(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RefreshRequestDto {

 String get refreshToken;
/// Create a copy of RefreshRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshRequestDtoCopyWith<RefreshRequestDto> get copyWith => _$RefreshRequestDtoCopyWithImpl<RefreshRequestDto>(this as RefreshRequestDto, _$identity);

  /// Serializes this RefreshRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefreshRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshRequestDto&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefreshRequestDto;
  return Object.hash(runtimeType,_this.refreshToken);
}

@override
String toString() {
  final _this = this as RefreshRequestDto;
  return 'RefreshRequestDto(refreshToken: ${_this.refreshToken})';
}


}

/// @nodoc
abstract mixin class $RefreshRequestDtoCopyWith<$Res>  {
  factory $RefreshRequestDtoCopyWith(RefreshRequestDto value, $Res Function(RefreshRequestDto) _then) = _$RefreshRequestDtoCopyWithImpl;
@useResult
$Res call({
 String refreshToken
});




}
/// @nodoc
class _$RefreshRequestDtoCopyWithImpl<$Res>
    implements $RefreshRequestDtoCopyWith<$Res> {
  _$RefreshRequestDtoCopyWithImpl(this._self, this._then);

  final RefreshRequestDto _self;
  final $Res Function(RefreshRequestDto) _then;

/// Create a copy of RefreshRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refreshToken = null,}) {
  return _then(RefreshRequestDto(
refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RefreshRequestDto].
extension RefreshRequestDtoPatterns on RefreshRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefreshRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefreshRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefreshRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RefreshRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefreshRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RefreshRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefreshRequestDto() when $default != null:
return $default(_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _RefreshRequestDto():
return $default(_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _RefreshRequestDto() when $default != null:
return $default(_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefreshRequestDto implements RefreshRequestDto {
  const _RefreshRequestDto({required this.refreshToken});
  factory _RefreshRequestDto.fromJson(Map<String, dynamic> json) => _$RefreshRequestDtoFromJson(json);

@override final  String refreshToken;

/// Create a copy of RefreshRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshRequestDtoCopyWith<_RefreshRequestDto> get copyWith => __$RefreshRequestDtoCopyWithImpl<_RefreshRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefreshRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshRequestDto&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,refreshToken);
}

@override
String toString() {
    return 'RefreshRequestDto(refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$RefreshRequestDtoCopyWith<$Res> implements $RefreshRequestDtoCopyWith<$Res> {
  factory _$RefreshRequestDtoCopyWith(_RefreshRequestDto value, $Res Function(_RefreshRequestDto) _then) = __$RefreshRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String refreshToken
});




}
/// @nodoc
class __$RefreshRequestDtoCopyWithImpl<$Res>
    implements _$RefreshRequestDtoCopyWith<$Res> {
  __$RefreshRequestDtoCopyWithImpl(this._self, this._then);

  final _RefreshRequestDto _self;
  final $Res Function(_RefreshRequestDto) _then;

/// Create a copy of RefreshRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refreshToken = null,}) {
  return _then(_RefreshRequestDto(
refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OnboardingRequestDto {

@JsonKey(includeIfNull: false) bool? get healthDisclaimerAccepted;@JsonKey(includeIfNull: false) String? get timezone;@JsonKey(includeIfNull: false) String? get locale;
/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingRequestDtoCopyWith<OnboardingRequestDto> get copyWith => _$OnboardingRequestDtoCopyWithImpl<OnboardingRequestDto>(this as OnboardingRequestDto, _$identity);

  /// Serializes this OnboardingRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingRequestDto&&(identical(other.healthDisclaimerAccepted, _this.healthDisclaimerAccepted) || other.healthDisclaimerAccepted == _this.healthDisclaimerAccepted)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.locale, _this.locale) || other.locale == _this.locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingRequestDto;
  return Object.hash(runtimeType,_this.healthDisclaimerAccepted,_this.timezone,_this.locale);
}

@override
String toString() {
  final _this = this as OnboardingRequestDto;
  return 'OnboardingRequestDto(healthDisclaimerAccepted: ${_this.healthDisclaimerAccepted}, timezone: ${_this.timezone}, locale: ${_this.locale})';
}


}

/// @nodoc
abstract mixin class $OnboardingRequestDtoCopyWith<$Res>  {
  factory $OnboardingRequestDtoCopyWith(OnboardingRequestDto value, $Res Function(OnboardingRequestDto) _then) = _$OnboardingRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) bool? healthDisclaimerAccepted,@JsonKey(includeIfNull: false) String? timezone,@JsonKey(includeIfNull: false) String? locale
});




}
/// @nodoc
class _$OnboardingRequestDtoCopyWithImpl<$Res>
    implements $OnboardingRequestDtoCopyWith<$Res> {
  _$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final OnboardingRequestDto _self;
  final $Res Function(OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? healthDisclaimerAccepted = freezed,Object? timezone = freezed,Object? locale = freezed,}) {
  return _then(OnboardingRequestDto(
healthDisclaimerAccepted: freezed == healthDisclaimerAccepted ? _self.healthDisclaimerAccepted : healthDisclaimerAccepted // ignore: cast_nullable_to_non_nullable
as bool?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingRequestDto].
extension OnboardingRequestDtoPatterns on OnboardingRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  bool? healthDisclaimerAccepted, @JsonKey(includeIfNull: false)  String? timezone, @JsonKey(includeIfNull: false)  String? locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.healthDisclaimerAccepted,_that.timezone,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  bool? healthDisclaimerAccepted, @JsonKey(includeIfNull: false)  String? timezone, @JsonKey(includeIfNull: false)  String? locale)  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto():
return $default(_that.healthDisclaimerAccepted,_that.timezone,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  bool? healthDisclaimerAccepted, @JsonKey(includeIfNull: false)  String? timezone, @JsonKey(includeIfNull: false)  String? locale)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.healthDisclaimerAccepted,_that.timezone,_that.locale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingRequestDto implements OnboardingRequestDto {
  const _OnboardingRequestDto({@JsonKey(includeIfNull: false) this.healthDisclaimerAccepted, @JsonKey(includeIfNull: false) this.timezone, @JsonKey(includeIfNull: false) this.locale});
  factory _OnboardingRequestDto.fromJson(Map<String, dynamic> json) => _$OnboardingRequestDtoFromJson(json);

@override@JsonKey(includeIfNull: false) final  bool? healthDisclaimerAccepted;
@override@JsonKey(includeIfNull: false) final  String? timezone;
@override@JsonKey(includeIfNull: false) final  String? locale;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingRequestDtoCopyWith<_OnboardingRequestDto> get copyWith => __$OnboardingRequestDtoCopyWithImpl<_OnboardingRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingRequestDto&&(identical(other.healthDisclaimerAccepted, healthDisclaimerAccepted) || other.healthDisclaimerAccepted == healthDisclaimerAccepted)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,healthDisclaimerAccepted,timezone,locale);
}

@override
String toString() {
    return 'OnboardingRequestDto(healthDisclaimerAccepted: $healthDisclaimerAccepted, timezone: $timezone, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$OnboardingRequestDtoCopyWith<$Res> implements $OnboardingRequestDtoCopyWith<$Res> {
  factory _$OnboardingRequestDtoCopyWith(_OnboardingRequestDto value, $Res Function(_OnboardingRequestDto) _then) = __$OnboardingRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) bool? healthDisclaimerAccepted,@JsonKey(includeIfNull: false) String? timezone,@JsonKey(includeIfNull: false) String? locale
});




}
/// @nodoc
class __$OnboardingRequestDtoCopyWithImpl<$Res>
    implements _$OnboardingRequestDtoCopyWith<$Res> {
  __$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final _OnboardingRequestDto _self;
  final $Res Function(_OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? healthDisclaimerAccepted = freezed,Object? timezone = freezed,Object? locale = freezed,}) {
  return _then(_OnboardingRequestDto(
healthDisclaimerAccepted: freezed == healthDisclaimerAccepted ? _self.healthDisclaimerAccepted : healthDisclaimerAccepted // ignore: cast_nullable_to_non_nullable
as bool?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OnboardingResponseDto {

 bool get onboardingComplete; String get locale; String get timezone;
/// Create a copy of OnboardingResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingResponseDtoCopyWith<OnboardingResponseDto> get copyWith => _$OnboardingResponseDtoCopyWithImpl<OnboardingResponseDto>(this as OnboardingResponseDto, _$identity);

  /// Serializes this OnboardingResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingResponseDto&&(identical(other.onboardingComplete, _this.onboardingComplete) || other.onboardingComplete == _this.onboardingComplete)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingResponseDto;
  return Object.hash(runtimeType,_this.onboardingComplete,_this.locale,_this.timezone);
}

@override
String toString() {
  final _this = this as OnboardingResponseDto;
  return 'OnboardingResponseDto(onboardingComplete: ${_this.onboardingComplete}, locale: ${_this.locale}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $OnboardingResponseDtoCopyWith<$Res>  {
  factory $OnboardingResponseDtoCopyWith(OnboardingResponseDto value, $Res Function(OnboardingResponseDto) _then) = _$OnboardingResponseDtoCopyWithImpl;
@useResult
$Res call({
 bool onboardingComplete, String locale, String timezone
});




}
/// @nodoc
class _$OnboardingResponseDtoCopyWithImpl<$Res>
    implements $OnboardingResponseDtoCopyWith<$Res> {
  _$OnboardingResponseDtoCopyWithImpl(this._self, this._then);

  final OnboardingResponseDto _self;
  final $Res Function(OnboardingResponseDto) _then;

/// Create a copy of OnboardingResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? onboardingComplete = null,Object? locale = null,Object? timezone = null,}) {
  return _then(OnboardingResponseDto(
onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingResponseDto].
extension OnboardingResponseDtoPatterns on OnboardingResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool onboardingComplete,  String locale,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingResponseDto() when $default != null:
return $default(_that.onboardingComplete,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool onboardingComplete,  String locale,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _OnboardingResponseDto():
return $default(_that.onboardingComplete,_that.locale,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool onboardingComplete,  String locale,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingResponseDto() when $default != null:
return $default(_that.onboardingComplete,_that.locale,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingResponseDto implements OnboardingResponseDto {
  const _OnboardingResponseDto({required this.onboardingComplete, required this.locale, required this.timezone});
  factory _OnboardingResponseDto.fromJson(Map<String, dynamic> json) => _$OnboardingResponseDtoFromJson(json);

@override final  bool onboardingComplete;
@override final  String locale;
@override final  String timezone;

/// Create a copy of OnboardingResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingResponseDtoCopyWith<_OnboardingResponseDto> get copyWith => __$OnboardingResponseDtoCopyWithImpl<_OnboardingResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingResponseDto&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,onboardingComplete,locale,timezone);
}

@override
String toString() {
    return 'OnboardingResponseDto(onboardingComplete: $onboardingComplete, locale: $locale, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$OnboardingResponseDtoCopyWith<$Res> implements $OnboardingResponseDtoCopyWith<$Res> {
  factory _$OnboardingResponseDtoCopyWith(_OnboardingResponseDto value, $Res Function(_OnboardingResponseDto) _then) = __$OnboardingResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 bool onboardingComplete, String locale, String timezone
});




}
/// @nodoc
class __$OnboardingResponseDtoCopyWithImpl<$Res>
    implements _$OnboardingResponseDtoCopyWith<$Res> {
  __$OnboardingResponseDtoCopyWithImpl(this._self, this._then);

  final _OnboardingResponseDto _self;
  final $Res Function(_OnboardingResponseDto) _then;

/// Create a copy of OnboardingResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? onboardingComplete = null,Object? locale = null,Object? timezone = null,}) {
  return _then(_OnboardingResponseDto(
onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GeoPointDto {

 double get latitude; double get longitude;
/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<GeoPointDto> get copyWith => _$GeoPointDtoCopyWithImpl<GeoPointDto>(this as GeoPointDto, _$identity);

  /// Serializes this GeoPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GeoPointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoPointDto&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GeoPointDto;
  return Object.hash(runtimeType,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as GeoPointDto;
  return 'GeoPointDto(latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $GeoPointDtoCopyWith<$Res>  {
  factory $GeoPointDtoCopyWith(GeoPointDto value, $Res Function(GeoPointDto) _then) = _$GeoPointDtoCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoPointDtoCopyWithImpl<$Res>
    implements $GeoPointDtoCopyWith<$Res> {
  _$GeoPointDtoCopyWithImpl(this._self, this._then);

  final GeoPointDto _self;
  final $Res Function(GeoPointDto) _then;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(GeoPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoPointDto].
extension GeoPointDtoPatterns on GeoPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoPointDto value)  $default,){
final _that = this;
switch (_that) {
case _GeoPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoPointDto():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoPointDto implements GeoPointDto {
  const _GeoPointDto({required this.latitude, required this.longitude});
  factory _GeoPointDto.fromJson(Map<String, dynamic> json) => _$GeoPointDtoFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoPointDtoCopyWith<_GeoPointDto> get copyWith => __$GeoPointDtoCopyWithImpl<_GeoPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoPointDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude);
}

@override
String toString() {
    return 'GeoPointDto(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoPointDtoCopyWith<$Res> implements $GeoPointDtoCopyWith<$Res> {
  factory _$GeoPointDtoCopyWith(_GeoPointDto value, $Res Function(_GeoPointDto) _then) = __$GeoPointDtoCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoPointDtoCopyWithImpl<$Res>
    implements _$GeoPointDtoCopyWith<$Res> {
  __$GeoPointDtoCopyWithImpl(this._self, this._then);

  final _GeoPointDto _self;
  final $Res Function(_GeoPointDto) _then;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TrackStartLocationDto {

@JsonKey(name: 'lat') double get latitude;@JsonKey(name: 'lng') double get longitude;@JsonKey(includeIfNull: false) double? get accuracyMeters;
/// Create a copy of TrackStartLocationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackStartLocationDtoCopyWith<TrackStartLocationDto> get copyWith => _$TrackStartLocationDtoCopyWithImpl<TrackStartLocationDto>(this as TrackStartLocationDto, _$identity);

  /// Serializes this TrackStartLocationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackStartLocationDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackStartLocationDto&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.accuracyMeters, _this.accuracyMeters) || other.accuracyMeters == _this.accuracyMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackStartLocationDto;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.accuracyMeters);
}

@override
String toString() {
  final _this = this as TrackStartLocationDto;
  return 'TrackStartLocationDto(latitude: ${_this.latitude}, longitude: ${_this.longitude}, accuracyMeters: ${_this.accuracyMeters})';
}


}

/// @nodoc
abstract mixin class $TrackStartLocationDtoCopyWith<$Res>  {
  factory $TrackStartLocationDtoCopyWith(TrackStartLocationDto value, $Res Function(TrackStartLocationDto) _then) = _$TrackStartLocationDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'lat') double latitude,@JsonKey(name: 'lng') double longitude,@JsonKey(includeIfNull: false) double? accuracyMeters
});




}
/// @nodoc
class _$TrackStartLocationDtoCopyWithImpl<$Res>
    implements $TrackStartLocationDtoCopyWith<$Res> {
  _$TrackStartLocationDtoCopyWithImpl(this._self, this._then);

  final TrackStartLocationDto _self;
  final $Res Function(TrackStartLocationDto) _then;

/// Create a copy of TrackStartLocationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = freezed,}) {
  return _then(TrackStartLocationDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackStartLocationDto].
extension TrackStartLocationDtoPatterns on TrackStartLocationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackStartLocationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackStartLocationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackStartLocationDto value)  $default,){
final _that = this;
switch (_that) {
case _TrackStartLocationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackStartLocationDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrackStartLocationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'lat')  double latitude, @JsonKey(name: 'lng')  double longitude, @JsonKey(includeIfNull: false)  double? accuracyMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackStartLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'lat')  double latitude, @JsonKey(name: 'lng')  double longitude, @JsonKey(includeIfNull: false)  double? accuracyMeters)  $default,) {final _that = this;
switch (_that) {
case _TrackStartLocationDto():
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'lat')  double latitude, @JsonKey(name: 'lng')  double longitude, @JsonKey(includeIfNull: false)  double? accuracyMeters)?  $default,) {final _that = this;
switch (_that) {
case _TrackStartLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackStartLocationDto implements TrackStartLocationDto {
  const _TrackStartLocationDto({@JsonKey(name: 'lat') required this.latitude, @JsonKey(name: 'lng') required this.longitude, @JsonKey(includeIfNull: false) this.accuracyMeters});
  factory _TrackStartLocationDto.fromJson(Map<String, dynamic> json) => _$TrackStartLocationDtoFromJson(json);

@override@JsonKey(name: 'lat') final  double latitude;
@override@JsonKey(name: 'lng') final  double longitude;
@override@JsonKey(includeIfNull: false) final  double? accuracyMeters;

/// Create a copy of TrackStartLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackStartLocationDtoCopyWith<_TrackStartLocationDto> get copyWith => __$TrackStartLocationDtoCopyWithImpl<_TrackStartLocationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackStartLocationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackStartLocationDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,accuracyMeters);
}

@override
String toString() {
    return 'TrackStartLocationDto(latitude: $latitude, longitude: $longitude, accuracyMeters: $accuracyMeters)';
}


}

/// @nodoc
abstract mixin class _$TrackStartLocationDtoCopyWith<$Res> implements $TrackStartLocationDtoCopyWith<$Res> {
  factory _$TrackStartLocationDtoCopyWith(_TrackStartLocationDto value, $Res Function(_TrackStartLocationDto) _then) = __$TrackStartLocationDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'lat') double latitude,@JsonKey(name: 'lng') double longitude,@JsonKey(includeIfNull: false) double? accuracyMeters
});




}
/// @nodoc
class __$TrackStartLocationDtoCopyWithImpl<$Res>
    implements _$TrackStartLocationDtoCopyWith<$Res> {
  __$TrackStartLocationDtoCopyWithImpl(this._self, this._then);

  final _TrackStartLocationDto _self;
  final $Res Function(_TrackStartLocationDto) _then;

/// Create a copy of TrackStartLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = freezed,}) {
  return _then(_TrackStartLocationDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$CreateTrackRequestDto {

 TrackStartLocationDto get location;
/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTrackRequestDtoCopyWith<CreateTrackRequestDto> get copyWith => _$CreateTrackRequestDtoCopyWithImpl<CreateTrackRequestDto>(this as CreateTrackRequestDto, _$identity);

  /// Serializes this CreateTrackRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateTrackRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTrackRequestDto&&(identical(other.location, _this.location) || other.location == _this.location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateTrackRequestDto;
  return Object.hash(runtimeType,_this.location);
}

@override
String toString() {
  final _this = this as CreateTrackRequestDto;
  return 'CreateTrackRequestDto(location: ${_this.location})';
}


}

/// @nodoc
abstract mixin class $CreateTrackRequestDtoCopyWith<$Res>  {
  factory $CreateTrackRequestDtoCopyWith(CreateTrackRequestDto value, $Res Function(CreateTrackRequestDto) _then) = _$CreateTrackRequestDtoCopyWithImpl;
@useResult
$Res call({
 TrackStartLocationDto location
});


$TrackStartLocationDtoCopyWith<$Res> get location;

}
/// @nodoc
class _$CreateTrackRequestDtoCopyWithImpl<$Res>
    implements $CreateTrackRequestDtoCopyWith<$Res> {
  _$CreateTrackRequestDtoCopyWithImpl(this._self, this._then);

  final CreateTrackRequestDto _self;
  final $Res Function(CreateTrackRequestDto) _then;

/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,}) {
  return _then(CreateTrackRequestDto(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as TrackStartLocationDto,
  ));
}
/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackStartLocationDtoCopyWith<$Res> get location {
  
  return $TrackStartLocationDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTrackRequestDto].
extension CreateTrackRequestDtoPatterns on CreateTrackRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTrackRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTrackRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTrackRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateTrackRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTrackRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTrackRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrackStartLocationDto location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTrackRequestDto() when $default != null:
return $default(_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrackStartLocationDto location)  $default,) {final _that = this;
switch (_that) {
case _CreateTrackRequestDto():
return $default(_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrackStartLocationDto location)?  $default,) {final _that = this;
switch (_that) {
case _CreateTrackRequestDto() when $default != null:
return $default(_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTrackRequestDto implements CreateTrackRequestDto {
  const _CreateTrackRequestDto({required this.location});
  factory _CreateTrackRequestDto.fromJson(Map<String, dynamic> json) => _$CreateTrackRequestDtoFromJson(json);

@override final  TrackStartLocationDto location;

/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTrackRequestDtoCopyWith<_CreateTrackRequestDto> get copyWith => __$CreateTrackRequestDtoCopyWithImpl<_CreateTrackRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTrackRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTrackRequestDto&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,location);
}

@override
String toString() {
    return 'CreateTrackRequestDto(location: $location)';
}


}

/// @nodoc
abstract mixin class _$CreateTrackRequestDtoCopyWith<$Res> implements $CreateTrackRequestDtoCopyWith<$Res> {
  factory _$CreateTrackRequestDtoCopyWith(_CreateTrackRequestDto value, $Res Function(_CreateTrackRequestDto) _then) = __$CreateTrackRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 TrackStartLocationDto location
});


@override $TrackStartLocationDtoCopyWith<$Res> get location;

}
/// @nodoc
class __$CreateTrackRequestDtoCopyWithImpl<$Res>
    implements _$CreateTrackRequestDtoCopyWith<$Res> {
  __$CreateTrackRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateTrackRequestDto _self;
  final $Res Function(_CreateTrackRequestDto) _then;

/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,}) {
  return _then(_CreateTrackRequestDto(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as TrackStartLocationDto,
  ));
}

/// Create a copy of CreateTrackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackStartLocationDtoCopyWith<$Res> get location {
  
  return $TrackStartLocationDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$TrackMilestoneDto {

 String get id; int get order; GeoPointDto? get position; bool get reached; int get expReward; double? get distanceMeters; double? get radiusMeters;
/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackMilestoneDtoCopyWith<TrackMilestoneDto> get copyWith => _$TrackMilestoneDtoCopyWithImpl<TrackMilestoneDto>(this as TrackMilestoneDto, _$identity);

  /// Serializes this TrackMilestoneDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackMilestoneDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackMilestoneDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.reached, _this.reached) || other.reached == _this.reached)&&(identical(other.expReward, _this.expReward) || other.expReward == _this.expReward)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.radiusMeters, _this.radiusMeters) || other.radiusMeters == _this.radiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackMilestoneDto;
  return Object.hash(runtimeType,_this.id,_this.order,_this.position,_this.reached,_this.expReward,_this.distanceMeters,_this.radiusMeters);
}

@override
String toString() {
  final _this = this as TrackMilestoneDto;
  return 'TrackMilestoneDto(id: ${_this.id}, order: ${_this.order}, position: ${_this.position}, reached: ${_this.reached}, expReward: ${_this.expReward}, distanceMeters: ${_this.distanceMeters}, radiusMeters: ${_this.radiusMeters})';
}


}

/// @nodoc
abstract mixin class $TrackMilestoneDtoCopyWith<$Res>  {
  factory $TrackMilestoneDtoCopyWith(TrackMilestoneDto value, $Res Function(TrackMilestoneDto) _then) = _$TrackMilestoneDtoCopyWithImpl;
@useResult
$Res call({
 String id, int order, GeoPointDto? position, bool reached, int expReward, double? distanceMeters, double? radiusMeters
});


$GeoPointDtoCopyWith<$Res>? get position;

}
/// @nodoc
class _$TrackMilestoneDtoCopyWithImpl<$Res>
    implements $TrackMilestoneDtoCopyWith<$Res> {
  _$TrackMilestoneDtoCopyWithImpl(this._self, this._then);

  final TrackMilestoneDto _self;
  final $Res Function(TrackMilestoneDto) _then;

/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? position = freezed,Object? reached = null,Object? expReward = null,Object? distanceMeters = freezed,Object? radiusMeters = freezed,}) {
  return _then(TrackMilestoneDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,reached: null == reached ? _self.reached : reached // ignore: cast_nullable_to_non_nullable
as bool,expReward: null == expReward ? _self.expReward : expReward // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,radiusMeters: freezed == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackMilestoneDto].
extension TrackMilestoneDtoPatterns on TrackMilestoneDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackMilestoneDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackMilestoneDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackMilestoneDto value)  $default,){
final _that = this;
switch (_that) {
case _TrackMilestoneDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackMilestoneDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrackMilestoneDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  GeoPointDto? position,  bool reached,  int expReward,  double? distanceMeters,  double? radiusMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackMilestoneDto() when $default != null:
return $default(_that.id,_that.order,_that.position,_that.reached,_that.expReward,_that.distanceMeters,_that.radiusMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  GeoPointDto? position,  bool reached,  int expReward,  double? distanceMeters,  double? radiusMeters)  $default,) {final _that = this;
switch (_that) {
case _TrackMilestoneDto():
return $default(_that.id,_that.order,_that.position,_that.reached,_that.expReward,_that.distanceMeters,_that.radiusMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  GeoPointDto? position,  bool reached,  int expReward,  double? distanceMeters,  double? radiusMeters)?  $default,) {final _that = this;
switch (_that) {
case _TrackMilestoneDto() when $default != null:
return $default(_that.id,_that.order,_that.position,_that.reached,_that.expReward,_that.distanceMeters,_that.radiusMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackMilestoneDto implements TrackMilestoneDto {
  const _TrackMilestoneDto({required this.id, required this.order, this.position, required this.reached, required this.expReward, this.distanceMeters, this.radiusMeters});
  factory _TrackMilestoneDto.fromJson(Map<String, dynamic> json) => _$TrackMilestoneDtoFromJson(json);

@override final  String id;
@override final  int order;
@override final  GeoPointDto? position;
@override final  bool reached;
@override final  int expReward;
@override final  double? distanceMeters;
@override final  double? radiusMeters;

/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackMilestoneDtoCopyWith<_TrackMilestoneDto> get copyWith => __$TrackMilestoneDtoCopyWithImpl<_TrackMilestoneDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackMilestoneDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackMilestoneDto&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.position, position) || other.position == position)&&(identical(other.reached, reached) || other.reached == reached)&&(identical(other.expReward, expReward) || other.expReward == expReward)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,order,position,reached,expReward,distanceMeters,radiusMeters);
}

@override
String toString() {
    return 'TrackMilestoneDto(id: $id, order: $order, position: $position, reached: $reached, expReward: $expReward, distanceMeters: $distanceMeters, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class _$TrackMilestoneDtoCopyWith<$Res> implements $TrackMilestoneDtoCopyWith<$Res> {
  factory _$TrackMilestoneDtoCopyWith(_TrackMilestoneDto value, $Res Function(_TrackMilestoneDto) _then) = __$TrackMilestoneDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, GeoPointDto? position, bool reached, int expReward, double? distanceMeters, double? radiusMeters
});


@override $GeoPointDtoCopyWith<$Res>? get position;

}
/// @nodoc
class __$TrackMilestoneDtoCopyWithImpl<$Res>
    implements _$TrackMilestoneDtoCopyWith<$Res> {
  __$TrackMilestoneDtoCopyWithImpl(this._self, this._then);

  final _TrackMilestoneDto _self;
  final $Res Function(_TrackMilestoneDto) _then;

/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? position = freezed,Object? reached = null,Object? expReward = null,Object? distanceMeters = freezed,Object? radiusMeters = freezed,}) {
  return _then(_TrackMilestoneDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,reached: null == reached ? _self.reached : reached // ignore: cast_nullable_to_non_nullable
as bool,expReward: null == expReward ? _self.expReward : expReward // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,radiusMeters: freezed == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of TrackMilestoneDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// @nodoc
mixin _$MilestoneDialogueDto {

 int get milestoneOrder; String get cheerLine; String get continuePrompt; String get restPrompt;
/// Create a copy of MilestoneDialogueDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneDialogueDtoCopyWith<MilestoneDialogueDto> get copyWith => _$MilestoneDialogueDtoCopyWithImpl<MilestoneDialogueDto>(this as MilestoneDialogueDto, _$identity);

  /// Serializes this MilestoneDialogueDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MilestoneDialogueDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneDialogueDto&&(identical(other.milestoneOrder, _this.milestoneOrder) || other.milestoneOrder == _this.milestoneOrder)&&(identical(other.cheerLine, _this.cheerLine) || other.cheerLine == _this.cheerLine)&&(identical(other.continuePrompt, _this.continuePrompt) || other.continuePrompt == _this.continuePrompt)&&(identical(other.restPrompt, _this.restPrompt) || other.restPrompt == _this.restPrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MilestoneDialogueDto;
  return Object.hash(runtimeType,_this.milestoneOrder,_this.cheerLine,_this.continuePrompt,_this.restPrompt);
}

@override
String toString() {
  final _this = this as MilestoneDialogueDto;
  return 'MilestoneDialogueDto(milestoneOrder: ${_this.milestoneOrder}, cheerLine: ${_this.cheerLine}, continuePrompt: ${_this.continuePrompt}, restPrompt: ${_this.restPrompt})';
}


}

/// @nodoc
abstract mixin class $MilestoneDialogueDtoCopyWith<$Res>  {
  factory $MilestoneDialogueDtoCopyWith(MilestoneDialogueDto value, $Res Function(MilestoneDialogueDto) _then) = _$MilestoneDialogueDtoCopyWithImpl;
@useResult
$Res call({
 int milestoneOrder, String cheerLine, String continuePrompt, String restPrompt
});




}
/// @nodoc
class _$MilestoneDialogueDtoCopyWithImpl<$Res>
    implements $MilestoneDialogueDtoCopyWith<$Res> {
  _$MilestoneDialogueDtoCopyWithImpl(this._self, this._then);

  final MilestoneDialogueDto _self;
  final $Res Function(MilestoneDialogueDto) _then;

/// Create a copy of MilestoneDialogueDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? milestoneOrder = null,Object? cheerLine = null,Object? continuePrompt = null,Object? restPrompt = null,}) {
  return _then(MilestoneDialogueDto(
milestoneOrder: null == milestoneOrder ? _self.milestoneOrder : milestoneOrder // ignore: cast_nullable_to_non_nullable
as int,cheerLine: null == cheerLine ? _self.cheerLine : cheerLine // ignore: cast_nullable_to_non_nullable
as String,continuePrompt: null == continuePrompt ? _self.continuePrompt : continuePrompt // ignore: cast_nullable_to_non_nullable
as String,restPrompt: null == restPrompt ? _self.restPrompt : restPrompt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneDialogueDto].
extension MilestoneDialogueDtoPatterns on MilestoneDialogueDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneDialogueDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneDialogueDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneDialogueDto value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneDialogueDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneDialogueDto value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneDialogueDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int milestoneOrder,  String cheerLine,  String continuePrompt,  String restPrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneDialogueDto() when $default != null:
return $default(_that.milestoneOrder,_that.cheerLine,_that.continuePrompt,_that.restPrompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int milestoneOrder,  String cheerLine,  String continuePrompt,  String restPrompt)  $default,) {final _that = this;
switch (_that) {
case _MilestoneDialogueDto():
return $default(_that.milestoneOrder,_that.cheerLine,_that.continuePrompt,_that.restPrompt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int milestoneOrder,  String cheerLine,  String continuePrompt,  String restPrompt)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneDialogueDto() when $default != null:
return $default(_that.milestoneOrder,_that.cheerLine,_that.continuePrompt,_that.restPrompt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneDialogueDto implements MilestoneDialogueDto {
  const _MilestoneDialogueDto({required this.milestoneOrder, required this.cheerLine, required this.continuePrompt, required this.restPrompt});
  factory _MilestoneDialogueDto.fromJson(Map<String, dynamic> json) => _$MilestoneDialogueDtoFromJson(json);

@override final  int milestoneOrder;
@override final  String cheerLine;
@override final  String continuePrompt;
@override final  String restPrompt;

/// Create a copy of MilestoneDialogueDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneDialogueDtoCopyWith<_MilestoneDialogueDto> get copyWith => __$MilestoneDialogueDtoCopyWithImpl<_MilestoneDialogueDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneDialogueDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneDialogueDto&&(identical(other.milestoneOrder, milestoneOrder) || other.milestoneOrder == milestoneOrder)&&(identical(other.cheerLine, cheerLine) || other.cheerLine == cheerLine)&&(identical(other.continuePrompt, continuePrompt) || other.continuePrompt == continuePrompt)&&(identical(other.restPrompt, restPrompt) || other.restPrompt == restPrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,milestoneOrder,cheerLine,continuePrompt,restPrompt);
}

@override
String toString() {
    return 'MilestoneDialogueDto(milestoneOrder: $milestoneOrder, cheerLine: $cheerLine, continuePrompt: $continuePrompt, restPrompt: $restPrompt)';
}


}

/// @nodoc
abstract mixin class _$MilestoneDialogueDtoCopyWith<$Res> implements $MilestoneDialogueDtoCopyWith<$Res> {
  factory _$MilestoneDialogueDtoCopyWith(_MilestoneDialogueDto value, $Res Function(_MilestoneDialogueDto) _then) = __$MilestoneDialogueDtoCopyWithImpl;
@override @useResult
$Res call({
 int milestoneOrder, String cheerLine, String continuePrompt, String restPrompt
});




}
/// @nodoc
class __$MilestoneDialogueDtoCopyWithImpl<$Res>
    implements _$MilestoneDialogueDtoCopyWith<$Res> {
  __$MilestoneDialogueDtoCopyWithImpl(this._self, this._then);

  final _MilestoneDialogueDto _self;
  final $Res Function(_MilestoneDialogueDto) _then;

/// Create a copy of MilestoneDialogueDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? milestoneOrder = null,Object? cheerLine = null,Object? continuePrompt = null,Object? restPrompt = null,}) {
  return _then(_MilestoneDialogueDto(
milestoneOrder: null == milestoneOrder ? _self.milestoneOrder : milestoneOrder // ignore: cast_nullable_to_non_nullable
as int,cheerLine: null == cheerLine ? _self.cheerLine : cheerLine // ignore: cast_nullable_to_non_nullable
as String,continuePrompt: null == continuePrompt ? _self.continuePrompt : continuePrompt // ignore: cast_nullable_to_non_nullable
as String,restPrompt: null == restPrompt ? _self.restPrompt : restPrompt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TrackNarrativeDto {

 String get trackTitle; String get mysteryBrief; String get preRunTip; List<MilestoneDialogueDto> get milestoneDialogues;
/// Create a copy of TrackNarrativeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackNarrativeDtoCopyWith<TrackNarrativeDto> get copyWith => _$TrackNarrativeDtoCopyWithImpl<TrackNarrativeDto>(this as TrackNarrativeDto, _$identity);

  /// Serializes this TrackNarrativeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackNarrativeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackNarrativeDto&&(identical(other.trackTitle, _this.trackTitle) || other.trackTitle == _this.trackTitle)&&(identical(other.mysteryBrief, _this.mysteryBrief) || other.mysteryBrief == _this.mysteryBrief)&&(identical(other.preRunTip, _this.preRunTip) || other.preRunTip == _this.preRunTip)&&const DeepCollectionEquality().equals(other.milestoneDialogues, _this.milestoneDialogues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackNarrativeDto;
  return Object.hash(runtimeType,_this.trackTitle,_this.mysteryBrief,_this.preRunTip,const DeepCollectionEquality().hash(_this.milestoneDialogues));
}

@override
String toString() {
  final _this = this as TrackNarrativeDto;
  return 'TrackNarrativeDto(trackTitle: ${_this.trackTitle}, mysteryBrief: ${_this.mysteryBrief}, preRunTip: ${_this.preRunTip}, milestoneDialogues: ${_this.milestoneDialogues})';
}


}

/// @nodoc
abstract mixin class $TrackNarrativeDtoCopyWith<$Res>  {
  factory $TrackNarrativeDtoCopyWith(TrackNarrativeDto value, $Res Function(TrackNarrativeDto) _then) = _$TrackNarrativeDtoCopyWithImpl;
@useResult
$Res call({
 String trackTitle, String mysteryBrief, String preRunTip, List<MilestoneDialogueDto> milestoneDialogues
});




}
/// @nodoc
class _$TrackNarrativeDtoCopyWithImpl<$Res>
    implements $TrackNarrativeDtoCopyWith<$Res> {
  _$TrackNarrativeDtoCopyWithImpl(this._self, this._then);

  final TrackNarrativeDto _self;
  final $Res Function(TrackNarrativeDto) _then;

/// Create a copy of TrackNarrativeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackTitle = null,Object? mysteryBrief = null,Object? preRunTip = null,Object? milestoneDialogues = null,}) {
  return _then(TrackNarrativeDto(
trackTitle: null == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String,mysteryBrief: null == mysteryBrief ? _self.mysteryBrief : mysteryBrief // ignore: cast_nullable_to_non_nullable
as String,preRunTip: null == preRunTip ? _self.preRunTip : preRunTip // ignore: cast_nullable_to_non_nullable
as String,milestoneDialogues: null == milestoneDialogues ? _self.milestoneDialogues : milestoneDialogues // ignore: cast_nullable_to_non_nullable
as List<MilestoneDialogueDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackNarrativeDto].
extension TrackNarrativeDtoPatterns on TrackNarrativeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackNarrativeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackNarrativeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackNarrativeDto value)  $default,){
final _that = this;
switch (_that) {
case _TrackNarrativeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackNarrativeDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrackNarrativeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackTitle,  String mysteryBrief,  String preRunTip,  List<MilestoneDialogueDto> milestoneDialogues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackNarrativeDto() when $default != null:
return $default(_that.trackTitle,_that.mysteryBrief,_that.preRunTip,_that.milestoneDialogues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackTitle,  String mysteryBrief,  String preRunTip,  List<MilestoneDialogueDto> milestoneDialogues)  $default,) {final _that = this;
switch (_that) {
case _TrackNarrativeDto():
return $default(_that.trackTitle,_that.mysteryBrief,_that.preRunTip,_that.milestoneDialogues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackTitle,  String mysteryBrief,  String preRunTip,  List<MilestoneDialogueDto> milestoneDialogues)?  $default,) {final _that = this;
switch (_that) {
case _TrackNarrativeDto() when $default != null:
return $default(_that.trackTitle,_that.mysteryBrief,_that.preRunTip,_that.milestoneDialogues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackNarrativeDto implements TrackNarrativeDto {
  const _TrackNarrativeDto({required this.trackTitle, required this.mysteryBrief, required this.preRunTip, required  List<MilestoneDialogueDto> milestoneDialogues}): _milestoneDialogues = milestoneDialogues;
  factory _TrackNarrativeDto.fromJson(Map<String, dynamic> json) => _$TrackNarrativeDtoFromJson(json);

@override final  String trackTitle;
@override final  String mysteryBrief;
@override final  String preRunTip;
 final  List<MilestoneDialogueDto> _milestoneDialogues;
@override List<MilestoneDialogueDto> get milestoneDialogues {
  if (_milestoneDialogues is EqualUnmodifiableListView) return _milestoneDialogues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestoneDialogues);
}


/// Create a copy of TrackNarrativeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackNarrativeDtoCopyWith<_TrackNarrativeDto> get copyWith => __$TrackNarrativeDtoCopyWithImpl<_TrackNarrativeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackNarrativeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackNarrativeDto&&(identical(other.trackTitle, trackTitle) || other.trackTitle == trackTitle)&&(identical(other.mysteryBrief, mysteryBrief) || other.mysteryBrief == mysteryBrief)&&(identical(other.preRunTip, preRunTip) || other.preRunTip == preRunTip)&&const DeepCollectionEquality().equals(other.milestoneDialogues, _milestoneDialogues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,trackTitle,mysteryBrief,preRunTip,const DeepCollectionEquality().hash(_milestoneDialogues));
}

@override
String toString() {
    return 'TrackNarrativeDto(trackTitle: $trackTitle, mysteryBrief: $mysteryBrief, preRunTip: $preRunTip, milestoneDialogues: $milestoneDialogues)';
}


}

/// @nodoc
abstract mixin class _$TrackNarrativeDtoCopyWith<$Res> implements $TrackNarrativeDtoCopyWith<$Res> {
  factory _$TrackNarrativeDtoCopyWith(_TrackNarrativeDto value, $Res Function(_TrackNarrativeDto) _then) = __$TrackNarrativeDtoCopyWithImpl;
@override @useResult
$Res call({
 String trackTitle, String mysteryBrief, String preRunTip, List<MilestoneDialogueDto> milestoneDialogues
});




}
/// @nodoc
class __$TrackNarrativeDtoCopyWithImpl<$Res>
    implements _$TrackNarrativeDtoCopyWith<$Res> {
  __$TrackNarrativeDtoCopyWithImpl(this._self, this._then);

  final _TrackNarrativeDto _self;
  final $Res Function(_TrackNarrativeDto) _then;

/// Create a copy of TrackNarrativeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackTitle = null,Object? mysteryBrief = null,Object? preRunTip = null,Object? milestoneDialogues = null,}) {
  return _then(_TrackNarrativeDto(
trackTitle: null == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String,mysteryBrief: null == mysteryBrief ? _self.mysteryBrief : mysteryBrief // ignore: cast_nullable_to_non_nullable
as String,preRunTip: null == preRunTip ? _self.preRunTip : preRunTip // ignore: cast_nullable_to_non_nullable
as String,milestoneDialogues: null == milestoneDialogues ? _self._milestoneDialogues : milestoneDialogues // ignore: cast_nullable_to_non_nullable
as List<MilestoneDialogueDto>,
  ));
}


}


/// @nodoc
mixin _$TrackDto {

 String get id; TrackStatus get status; RevealMode get revealMode; TrackNarrativeDto get narrative; List<GeoPointDto> get revealedPolyline; List<TrackMilestoneDto> get milestones; GeoPointDto? get serverStartPosition; double? get distanceMeters; int? get estimatedDurationMinutes; int? get estimatedCalories; int? get safetyScore; int? get safetyConfidence; int? get distanceToStartMeters; String? get routeNote; String? get beforeStartTip; String? get failureCode;
/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackDtoCopyWith<TrackDto> get copyWith => _$TrackDtoCopyWithImpl<TrackDto>(this as TrackDto, _$identity);

  /// Serializes this TrackDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.revealMode, _this.revealMode) || other.revealMode == _this.revealMode)&&(identical(other.narrative, _this.narrative) || other.narrative == _this.narrative)&&const DeepCollectionEquality().equals(other.revealedPolyline, _this.revealedPolyline)&&const DeepCollectionEquality().equals(other.milestones, _this.milestones)&&(identical(other.serverStartPosition, _this.serverStartPosition) || other.serverStartPosition == _this.serverStartPosition)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.estimatedDurationMinutes, _this.estimatedDurationMinutes) || other.estimatedDurationMinutes == _this.estimatedDurationMinutes)&&(identical(other.estimatedCalories, _this.estimatedCalories) || other.estimatedCalories == _this.estimatedCalories)&&(identical(other.safetyScore, _this.safetyScore) || other.safetyScore == _this.safetyScore)&&(identical(other.safetyConfidence, _this.safetyConfidence) || other.safetyConfidence == _this.safetyConfidence)&&(identical(other.distanceToStartMeters, _this.distanceToStartMeters) || other.distanceToStartMeters == _this.distanceToStartMeters)&&(identical(other.routeNote, _this.routeNote) || other.routeNote == _this.routeNote)&&(identical(other.beforeStartTip, _this.beforeStartTip) || other.beforeStartTip == _this.beforeStartTip)&&(identical(other.failureCode, _this.failureCode) || other.failureCode == _this.failureCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackDto;
  return Object.hash(runtimeType,_this.id,_this.status,_this.revealMode,_this.narrative,const DeepCollectionEquality().hash(_this.revealedPolyline),const DeepCollectionEquality().hash(_this.milestones),_this.serverStartPosition,_this.distanceMeters,_this.estimatedDurationMinutes,_this.estimatedCalories,_this.safetyScore,_this.safetyConfidence,_this.distanceToStartMeters,_this.routeNote,_this.beforeStartTip,_this.failureCode);
}

@override
String toString() {
  final _this = this as TrackDto;
  return 'TrackDto(id: ${_this.id}, status: ${_this.status}, revealMode: ${_this.revealMode}, narrative: ${_this.narrative}, revealedPolyline: ${_this.revealedPolyline}, milestones: ${_this.milestones}, serverStartPosition: ${_this.serverStartPosition}, distanceMeters: ${_this.distanceMeters}, estimatedDurationMinutes: ${_this.estimatedDurationMinutes}, estimatedCalories: ${_this.estimatedCalories}, safetyScore: ${_this.safetyScore}, safetyConfidence: ${_this.safetyConfidence}, distanceToStartMeters: ${_this.distanceToStartMeters}, routeNote: ${_this.routeNote}, beforeStartTip: ${_this.beforeStartTip}, failureCode: ${_this.failureCode})';
}


}

/// @nodoc
abstract mixin class $TrackDtoCopyWith<$Res>  {
  factory $TrackDtoCopyWith(TrackDto value, $Res Function(TrackDto) _then) = _$TrackDtoCopyWithImpl;
@useResult
$Res call({
 String id, TrackStatus status, RevealMode revealMode, TrackNarrativeDto narrative, List<GeoPointDto> revealedPolyline, List<TrackMilestoneDto> milestones, GeoPointDto? serverStartPosition, double? distanceMeters, int? estimatedDurationMinutes, int? estimatedCalories, int? safetyScore, int? safetyConfidence, int? distanceToStartMeters, String? routeNote, String? beforeStartTip, String? failureCode
});


$TrackNarrativeDtoCopyWith<$Res> get narrative;$GeoPointDtoCopyWith<$Res>? get serverStartPosition;

}
/// @nodoc
class _$TrackDtoCopyWithImpl<$Res>
    implements $TrackDtoCopyWith<$Res> {
  _$TrackDtoCopyWithImpl(this._self, this._then);

  final TrackDto _self;
  final $Res Function(TrackDto) _then;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? revealMode = null,Object? narrative = null,Object? revealedPolyline = null,Object? milestones = null,Object? serverStartPosition = freezed,Object? distanceMeters = freezed,Object? estimatedDurationMinutes = freezed,Object? estimatedCalories = freezed,Object? safetyScore = freezed,Object? safetyConfidence = freezed,Object? distanceToStartMeters = freezed,Object? routeNote = freezed,Object? beforeStartTip = freezed,Object? failureCode = freezed,}) {
  return _then(TrackDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackStatus,revealMode: null == revealMode ? _self.revealMode : revealMode // ignore: cast_nullable_to_non_nullable
as RevealMode,narrative: null == narrative ? _self.narrative : narrative // ignore: cast_nullable_to_non_nullable
as TrackNarrativeDto,revealedPolyline: null == revealedPolyline ? _self.revealedPolyline : revealedPolyline // ignore: cast_nullable_to_non_nullable
as List<GeoPointDto>,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<TrackMilestoneDto>,serverStartPosition: freezed == serverStartPosition ? _self.serverStartPosition : serverStartPosition // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,estimatedDurationMinutes: freezed == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,estimatedCalories: freezed == estimatedCalories ? _self.estimatedCalories : estimatedCalories // ignore: cast_nullable_to_non_nullable
as int?,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyConfidence: freezed == safetyConfidence ? _self.safetyConfidence : safetyConfidence // ignore: cast_nullable_to_non_nullable
as int?,distanceToStartMeters: freezed == distanceToStartMeters ? _self.distanceToStartMeters : distanceToStartMeters // ignore: cast_nullable_to_non_nullable
as int?,routeNote: freezed == routeNote ? _self.routeNote : routeNote // ignore: cast_nullable_to_non_nullable
as String?,beforeStartTip: freezed == beforeStartTip ? _self.beforeStartTip : beforeStartTip // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackNarrativeDtoCopyWith<$Res> get narrative {
  
  return $TrackNarrativeDtoCopyWith<$Res>(_self.narrative, (value) {
    return _then(_self.copyWith(narrative: value));
  });
}/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get serverStartPosition {
    if (_self.serverStartPosition == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.serverStartPosition!, (value) {
    return _then(_self.copyWith(serverStartPosition: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackDto].
extension TrackDtoPatterns on TrackDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackDto value)  $default,){
final _that = this;
switch (_that) {
case _TrackDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TrackStatus status,  RevealMode revealMode,  TrackNarrativeDto narrative,  List<GeoPointDto> revealedPolyline,  List<TrackMilestoneDto> milestones,  GeoPointDto? serverStartPosition,  double? distanceMeters,  int? estimatedDurationMinutes,  int? estimatedCalories,  int? safetyScore,  int? safetyConfidence,  int? distanceToStartMeters,  String? routeNote,  String? beforeStartTip,  String? failureCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that.id,_that.status,_that.revealMode,_that.narrative,_that.revealedPolyline,_that.milestones,_that.serverStartPosition,_that.distanceMeters,_that.estimatedDurationMinutes,_that.estimatedCalories,_that.safetyScore,_that.safetyConfidence,_that.distanceToStartMeters,_that.routeNote,_that.beforeStartTip,_that.failureCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TrackStatus status,  RevealMode revealMode,  TrackNarrativeDto narrative,  List<GeoPointDto> revealedPolyline,  List<TrackMilestoneDto> milestones,  GeoPointDto? serverStartPosition,  double? distanceMeters,  int? estimatedDurationMinutes,  int? estimatedCalories,  int? safetyScore,  int? safetyConfidence,  int? distanceToStartMeters,  String? routeNote,  String? beforeStartTip,  String? failureCode)  $default,) {final _that = this;
switch (_that) {
case _TrackDto():
return $default(_that.id,_that.status,_that.revealMode,_that.narrative,_that.revealedPolyline,_that.milestones,_that.serverStartPosition,_that.distanceMeters,_that.estimatedDurationMinutes,_that.estimatedCalories,_that.safetyScore,_that.safetyConfidence,_that.distanceToStartMeters,_that.routeNote,_that.beforeStartTip,_that.failureCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TrackStatus status,  RevealMode revealMode,  TrackNarrativeDto narrative,  List<GeoPointDto> revealedPolyline,  List<TrackMilestoneDto> milestones,  GeoPointDto? serverStartPosition,  double? distanceMeters,  int? estimatedDurationMinutes,  int? estimatedCalories,  int? safetyScore,  int? safetyConfidence,  int? distanceToStartMeters,  String? routeNote,  String? beforeStartTip,  String? failureCode)?  $default,) {final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that.id,_that.status,_that.revealMode,_that.narrative,_that.revealedPolyline,_that.milestones,_that.serverStartPosition,_that.distanceMeters,_that.estimatedDurationMinutes,_that.estimatedCalories,_that.safetyScore,_that.safetyConfidence,_that.distanceToStartMeters,_that.routeNote,_that.beforeStartTip,_that.failureCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackDto implements TrackDto {
  const _TrackDto({required this.id, required this.status, required this.revealMode, required this.narrative, required  List<GeoPointDto> revealedPolyline, required  List<TrackMilestoneDto> milestones, this.serverStartPosition, this.distanceMeters, this.estimatedDurationMinutes, this.estimatedCalories, this.safetyScore, this.safetyConfidence, this.distanceToStartMeters, this.routeNote, this.beforeStartTip, this.failureCode}): _revealedPolyline = revealedPolyline,_milestones = milestones;
  factory _TrackDto.fromJson(Map<String, dynamic> json) => _$TrackDtoFromJson(json);

@override final  String id;
@override final  TrackStatus status;
@override final  RevealMode revealMode;
@override final  TrackNarrativeDto narrative;
 final  List<GeoPointDto> _revealedPolyline;
@override List<GeoPointDto> get revealedPolyline {
  if (_revealedPolyline is EqualUnmodifiableListView) return _revealedPolyline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_revealedPolyline);
}

 final  List<TrackMilestoneDto> _milestones;
@override List<TrackMilestoneDto> get milestones {
  if (_milestones is EqualUnmodifiableListView) return _milestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestones);
}

@override final  GeoPointDto? serverStartPosition;
@override final  double? distanceMeters;
@override final  int? estimatedDurationMinutes;
@override final  int? estimatedCalories;
@override final  int? safetyScore;
@override final  int? safetyConfidence;
@override final  int? distanceToStartMeters;
@override final  String? routeNote;
@override final  String? beforeStartTip;
@override final  String? failureCode;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackDtoCopyWith<_TrackDto> get copyWith => __$TrackDtoCopyWithImpl<_TrackDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.revealMode, revealMode) || other.revealMode == revealMode)&&(identical(other.narrative, narrative) || other.narrative == narrative)&&const DeepCollectionEquality().equals(other.revealedPolyline, _revealedPolyline)&&const DeepCollectionEquality().equals(other.milestones, _milestones)&&(identical(other.serverStartPosition, serverStartPosition) || other.serverStartPosition == serverStartPosition)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.estimatedDurationMinutes, estimatedDurationMinutes) || other.estimatedDurationMinutes == estimatedDurationMinutes)&&(identical(other.estimatedCalories, estimatedCalories) || other.estimatedCalories == estimatedCalories)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.safetyConfidence, safetyConfidence) || other.safetyConfidence == safetyConfidence)&&(identical(other.distanceToStartMeters, distanceToStartMeters) || other.distanceToStartMeters == distanceToStartMeters)&&(identical(other.routeNote, routeNote) || other.routeNote == routeNote)&&(identical(other.beforeStartTip, beforeStartTip) || other.beforeStartTip == beforeStartTip)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,revealMode,narrative,const DeepCollectionEquality().hash(_revealedPolyline),const DeepCollectionEquality().hash(_milestones),serverStartPosition,distanceMeters,estimatedDurationMinutes,estimatedCalories,safetyScore,safetyConfidence,distanceToStartMeters,routeNote,beforeStartTip,failureCode);
}

@override
String toString() {
    return 'TrackDto(id: $id, status: $status, revealMode: $revealMode, narrative: $narrative, revealedPolyline: $revealedPolyline, milestones: $milestones, serverStartPosition: $serverStartPosition, distanceMeters: $distanceMeters, estimatedDurationMinutes: $estimatedDurationMinutes, estimatedCalories: $estimatedCalories, safetyScore: $safetyScore, safetyConfidence: $safetyConfidence, distanceToStartMeters: $distanceToStartMeters, routeNote: $routeNote, beforeStartTip: $beforeStartTip, failureCode: $failureCode)';
}


}

/// @nodoc
abstract mixin class _$TrackDtoCopyWith<$Res> implements $TrackDtoCopyWith<$Res> {
  factory _$TrackDtoCopyWith(_TrackDto value, $Res Function(_TrackDto) _then) = __$TrackDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, TrackStatus status, RevealMode revealMode, TrackNarrativeDto narrative, List<GeoPointDto> revealedPolyline, List<TrackMilestoneDto> milestones, GeoPointDto? serverStartPosition, double? distanceMeters, int? estimatedDurationMinutes, int? estimatedCalories, int? safetyScore, int? safetyConfidence, int? distanceToStartMeters, String? routeNote, String? beforeStartTip, String? failureCode
});


@override $TrackNarrativeDtoCopyWith<$Res> get narrative;@override $GeoPointDtoCopyWith<$Res>? get serverStartPosition;

}
/// @nodoc
class __$TrackDtoCopyWithImpl<$Res>
    implements _$TrackDtoCopyWith<$Res> {
  __$TrackDtoCopyWithImpl(this._self, this._then);

  final _TrackDto _self;
  final $Res Function(_TrackDto) _then;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? revealMode = null,Object? narrative = null,Object? revealedPolyline = null,Object? milestones = null,Object? serverStartPosition = freezed,Object? distanceMeters = freezed,Object? estimatedDurationMinutes = freezed,Object? estimatedCalories = freezed,Object? safetyScore = freezed,Object? safetyConfidence = freezed,Object? distanceToStartMeters = freezed,Object? routeNote = freezed,Object? beforeStartTip = freezed,Object? failureCode = freezed,}) {
  return _then(_TrackDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackStatus,revealMode: null == revealMode ? _self.revealMode : revealMode // ignore: cast_nullable_to_non_nullable
as RevealMode,narrative: null == narrative ? _self.narrative : narrative // ignore: cast_nullable_to_non_nullable
as TrackNarrativeDto,revealedPolyline: null == revealedPolyline ? _self._revealedPolyline : revealedPolyline // ignore: cast_nullable_to_non_nullable
as List<GeoPointDto>,milestones: null == milestones ? _self._milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<TrackMilestoneDto>,serverStartPosition: freezed == serverStartPosition ? _self.serverStartPosition : serverStartPosition // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,estimatedDurationMinutes: freezed == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,estimatedCalories: freezed == estimatedCalories ? _self.estimatedCalories : estimatedCalories // ignore: cast_nullable_to_non_nullable
as int?,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyConfidence: freezed == safetyConfidence ? _self.safetyConfidence : safetyConfidence // ignore: cast_nullable_to_non_nullable
as int?,distanceToStartMeters: freezed == distanceToStartMeters ? _self.distanceToStartMeters : distanceToStartMeters // ignore: cast_nullable_to_non_nullable
as int?,routeNote: freezed == routeNote ? _self.routeNote : routeNote // ignore: cast_nullable_to_non_nullable
as String?,beforeStartTip: freezed == beforeStartTip ? _self.beforeStartTip : beforeStartTip // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackNarrativeDtoCopyWith<$Res> get narrative {
  
  return $TrackNarrativeDtoCopyWith<$Res>(_self.narrative, (value) {
    return _then(_self.copyWith(narrative: value));
  });
}/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get serverStartPosition {
    if (_self.serverStartPosition == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.serverStartPosition!, (value) {
    return _then(_self.copyWith(serverStartPosition: value));
  });
}
}


/// @nodoc
mixin _$StartRunRequestDto {

@JsonKey(name: 'routeId') String get trackId; String? get activeItemId; String? get boostItemCode; String? get modifierItemCode; String get units; TrackStartLocationDto? get startLocation; Map<String, dynamic>? get clientCapabilities;
/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartRunRequestDtoCopyWith<StartRunRequestDto> get copyWith => _$StartRunRequestDtoCopyWithImpl<StartRunRequestDto>(this as StartRunRequestDto, _$identity);

  /// Serializes this StartRunRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StartRunRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartRunRequestDto&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.activeItemId, _this.activeItemId) || other.activeItemId == _this.activeItemId)&&(identical(other.boostItemCode, _this.boostItemCode) || other.boostItemCode == _this.boostItemCode)&&(identical(other.modifierItemCode, _this.modifierItemCode) || other.modifierItemCode == _this.modifierItemCode)&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.startLocation, _this.startLocation) || other.startLocation == _this.startLocation)&&const DeepCollectionEquality().equals(other.clientCapabilities, _this.clientCapabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StartRunRequestDto;
  return Object.hash(runtimeType,_this.trackId,_this.activeItemId,_this.boostItemCode,_this.modifierItemCode,_this.units,_this.startLocation,const DeepCollectionEquality().hash(_this.clientCapabilities));
}

@override
String toString() {
  final _this = this as StartRunRequestDto;
  return 'StartRunRequestDto(trackId: ${_this.trackId}, activeItemId: ${_this.activeItemId}, boostItemCode: ${_this.boostItemCode}, modifierItemCode: ${_this.modifierItemCode}, units: ${_this.units}, startLocation: ${_this.startLocation}, clientCapabilities: ${_this.clientCapabilities})';
}


}

/// @nodoc
abstract mixin class $StartRunRequestDtoCopyWith<$Res>  {
  factory $StartRunRequestDtoCopyWith(StartRunRequestDto value, $Res Function(StartRunRequestDto) _then) = _$StartRunRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'routeId') String trackId, String? activeItemId, String? boostItemCode, String? modifierItemCode, String units, TrackStartLocationDto? startLocation, Map<String, dynamic>? clientCapabilities
});


$TrackStartLocationDtoCopyWith<$Res>? get startLocation;

}
/// @nodoc
class _$StartRunRequestDtoCopyWithImpl<$Res>
    implements $StartRunRequestDtoCopyWith<$Res> {
  _$StartRunRequestDtoCopyWithImpl(this._self, this._then);

  final StartRunRequestDto _self;
  final $Res Function(StartRunRequestDto) _then;

/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? activeItemId = freezed,Object? boostItemCode = freezed,Object? modifierItemCode = freezed,Object? units = null,Object? startLocation = freezed,Object? clientCapabilities = freezed,}) {
  return _then(StartRunRequestDto(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,activeItemId: freezed == activeItemId ? _self.activeItemId : activeItemId // ignore: cast_nullable_to_non_nullable
as String?,boostItemCode: freezed == boostItemCode ? _self.boostItemCode : boostItemCode // ignore: cast_nullable_to_non_nullable
as String?,modifierItemCode: freezed == modifierItemCode ? _self.modifierItemCode : modifierItemCode // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,startLocation: freezed == startLocation ? _self.startLocation : startLocation // ignore: cast_nullable_to_non_nullable
as TrackStartLocationDto?,clientCapabilities: freezed == clientCapabilities ? _self.clientCapabilities : clientCapabilities // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackStartLocationDtoCopyWith<$Res>? get startLocation {
    if (_self.startLocation == null) {
    return null;
  }

  return $TrackStartLocationDtoCopyWith<$Res>(_self.startLocation!, (value) {
    return _then(_self.copyWith(startLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [StartRunRequestDto].
extension StartRunRequestDtoPatterns on StartRunRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartRunRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartRunRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartRunRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _StartRunRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartRunRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _StartRunRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String trackId,  String? activeItemId,  String? boostItemCode,  String? modifierItemCode,  String units,  TrackStartLocationDto? startLocation,  Map<String, dynamic>? clientCapabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartRunRequestDto() when $default != null:
return $default(_that.trackId,_that.activeItemId,_that.boostItemCode,_that.modifierItemCode,_that.units,_that.startLocation,_that.clientCapabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String trackId,  String? activeItemId,  String? boostItemCode,  String? modifierItemCode,  String units,  TrackStartLocationDto? startLocation,  Map<String, dynamic>? clientCapabilities)  $default,) {final _that = this;
switch (_that) {
case _StartRunRequestDto():
return $default(_that.trackId,_that.activeItemId,_that.boostItemCode,_that.modifierItemCode,_that.units,_that.startLocation,_that.clientCapabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'routeId')  String trackId,  String? activeItemId,  String? boostItemCode,  String? modifierItemCode,  String units,  TrackStartLocationDto? startLocation,  Map<String, dynamic>? clientCapabilities)?  $default,) {final _that = this;
switch (_that) {
case _StartRunRequestDto() when $default != null:
return $default(_that.trackId,_that.activeItemId,_that.boostItemCode,_that.modifierItemCode,_that.units,_that.startLocation,_that.clientCapabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartRunRequestDto implements StartRunRequestDto {
  const _StartRunRequestDto({@JsonKey(name: 'routeId') required this.trackId, this.activeItemId, this.boostItemCode, this.modifierItemCode, this.units = 'metric', this.startLocation,  Map<String, dynamic>? clientCapabilities}): _clientCapabilities = clientCapabilities;
  factory _StartRunRequestDto.fromJson(Map<String, dynamic> json) => _$StartRunRequestDtoFromJson(json);

@override@JsonKey(name: 'routeId') final  String trackId;
@override final  String? activeItemId;
@override final  String? boostItemCode;
@override final  String? modifierItemCode;
@override@JsonKey() final  String units;
@override final  TrackStartLocationDto? startLocation;
 final  Map<String, dynamic>? _clientCapabilities;
@override Map<String, dynamic>? get clientCapabilities {
  final value = _clientCapabilities;
  if (value == null) return null;
  if (_clientCapabilities is EqualUnmodifiableMapView) return _clientCapabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartRunRequestDtoCopyWith<_StartRunRequestDto> get copyWith => __$StartRunRequestDtoCopyWithImpl<_StartRunRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartRunRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartRunRequestDto&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.activeItemId, activeItemId) || other.activeItemId == activeItemId)&&(identical(other.boostItemCode, boostItemCode) || other.boostItemCode == boostItemCode)&&(identical(other.modifierItemCode, modifierItemCode) || other.modifierItemCode == modifierItemCode)&&(identical(other.units, units) || other.units == units)&&(identical(other.startLocation, startLocation) || other.startLocation == startLocation)&&const DeepCollectionEquality().equals(other.clientCapabilities, _clientCapabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,trackId,activeItemId,boostItemCode,modifierItemCode,units,startLocation,const DeepCollectionEquality().hash(_clientCapabilities));
}

@override
String toString() {
    return 'StartRunRequestDto(trackId: $trackId, activeItemId: $activeItemId, boostItemCode: $boostItemCode, modifierItemCode: $modifierItemCode, units: $units, startLocation: $startLocation, clientCapabilities: $clientCapabilities)';
}


}

/// @nodoc
abstract mixin class _$StartRunRequestDtoCopyWith<$Res> implements $StartRunRequestDtoCopyWith<$Res> {
  factory _$StartRunRequestDtoCopyWith(_StartRunRequestDto value, $Res Function(_StartRunRequestDto) _then) = __$StartRunRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'routeId') String trackId, String? activeItemId, String? boostItemCode, String? modifierItemCode, String units, TrackStartLocationDto? startLocation, Map<String, dynamic>? clientCapabilities
});


@override $TrackStartLocationDtoCopyWith<$Res>? get startLocation;

}
/// @nodoc
class __$StartRunRequestDtoCopyWithImpl<$Res>
    implements _$StartRunRequestDtoCopyWith<$Res> {
  __$StartRunRequestDtoCopyWithImpl(this._self, this._then);

  final _StartRunRequestDto _self;
  final $Res Function(_StartRunRequestDto) _then;

/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? activeItemId = freezed,Object? boostItemCode = freezed,Object? modifierItemCode = freezed,Object? units = null,Object? startLocation = freezed,Object? clientCapabilities = freezed,}) {
  return _then(_StartRunRequestDto(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,activeItemId: freezed == activeItemId ? _self.activeItemId : activeItemId // ignore: cast_nullable_to_non_nullable
as String?,boostItemCode: freezed == boostItemCode ? _self.boostItemCode : boostItemCode // ignore: cast_nullable_to_non_nullable
as String?,modifierItemCode: freezed == modifierItemCode ? _self.modifierItemCode : modifierItemCode // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,startLocation: freezed == startLocation ? _self.startLocation : startLocation // ignore: cast_nullable_to_non_nullable
as TrackStartLocationDto?,clientCapabilities: freezed == clientCapabilities ? _self._clientCapabilities : clientCapabilities // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of StartRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackStartLocationDtoCopyWith<$Res>? get startLocation {
    if (_self.startLocation == null) {
    return null;
  }

  return $TrackStartLocationDtoCopyWith<$Res>(_self.startLocation!, (value) {
    return _then(_self.copyWith(startLocation: value));
  });
}
}


/// @nodoc
mixin _$RunDto {

 String get id; String get trackId; String? get trackTitle; RunStatus get status; DateTime get startedAt; DateTime? get finishedAt; double? get distanceMeters; int? get durationSeconds; double? get paceSecondsPerKm; int? get netExp; int? get coinsEarned; int? get milestoneExp; double? get expMultiplier; int? get runPenaltyExp; int? get roleLeaguePoints; int? get estimatedCalories; int? get streakDays; int? get reachedMilestones; String? get loadoutLabel; String? get rejectionCode; String? get claimId; bool get claimed; List<TrackMilestoneDto> get milestones; RevealMode? get revealMode; int? get minimumDistanceMeters;
/// Create a copy of RunDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunDtoCopyWith<RunDto> get copyWith => _$RunDtoCopyWithImpl<RunDto>(this as RunDto, _$identity);

  /// Serializes this RunDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RunDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.trackTitle, _this.trackTitle) || other.trackTitle == _this.trackTitle)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.paceSecondsPerKm, _this.paceSecondsPerKm) || other.paceSecondsPerKm == _this.paceSecondsPerKm)&&(identical(other.netExp, _this.netExp) || other.netExp == _this.netExp)&&(identical(other.coinsEarned, _this.coinsEarned) || other.coinsEarned == _this.coinsEarned)&&(identical(other.milestoneExp, _this.milestoneExp) || other.milestoneExp == _this.milestoneExp)&&(identical(other.expMultiplier, _this.expMultiplier) || other.expMultiplier == _this.expMultiplier)&&(identical(other.runPenaltyExp, _this.runPenaltyExp) || other.runPenaltyExp == _this.runPenaltyExp)&&(identical(other.roleLeaguePoints, _this.roleLeaguePoints) || other.roleLeaguePoints == _this.roleLeaguePoints)&&(identical(other.estimatedCalories, _this.estimatedCalories) || other.estimatedCalories == _this.estimatedCalories)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.reachedMilestones, _this.reachedMilestones) || other.reachedMilestones == _this.reachedMilestones)&&(identical(other.loadoutLabel, _this.loadoutLabel) || other.loadoutLabel == _this.loadoutLabel)&&(identical(other.rejectionCode, _this.rejectionCode) || other.rejectionCode == _this.rejectionCode)&&(identical(other.claimId, _this.claimId) || other.claimId == _this.claimId)&&(identical(other.claimed, _this.claimed) || other.claimed == _this.claimed)&&const DeepCollectionEquality().equals(other.milestones, _this.milestones)&&(identical(other.revealMode, _this.revealMode) || other.revealMode == _this.revealMode)&&(identical(other.minimumDistanceMeters, _this.minimumDistanceMeters) || other.minimumDistanceMeters == _this.minimumDistanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RunDto;
  return Object.hashAll([runtimeType,_this.id,_this.trackId,_this.trackTitle,_this.status,_this.startedAt,_this.finishedAt,_this.distanceMeters,_this.durationSeconds,_this.paceSecondsPerKm,_this.netExp,_this.coinsEarned,_this.milestoneExp,_this.expMultiplier,_this.runPenaltyExp,_this.roleLeaguePoints,_this.estimatedCalories,_this.streakDays,_this.reachedMilestones,_this.loadoutLabel,_this.rejectionCode,_this.claimId,_this.claimed,const DeepCollectionEquality().hash(_this.milestones),_this.revealMode,_this.minimumDistanceMeters]);
}

@override
String toString() {
  final _this = this as RunDto;
  return 'RunDto(id: ${_this.id}, trackId: ${_this.trackId}, trackTitle: ${_this.trackTitle}, status: ${_this.status}, startedAt: ${_this.startedAt}, finishedAt: ${_this.finishedAt}, distanceMeters: ${_this.distanceMeters}, durationSeconds: ${_this.durationSeconds}, paceSecondsPerKm: ${_this.paceSecondsPerKm}, netExp: ${_this.netExp}, coinsEarned: ${_this.coinsEarned}, milestoneExp: ${_this.milestoneExp}, expMultiplier: ${_this.expMultiplier}, runPenaltyExp: ${_this.runPenaltyExp}, roleLeaguePoints: ${_this.roleLeaguePoints}, estimatedCalories: ${_this.estimatedCalories}, streakDays: ${_this.streakDays}, reachedMilestones: ${_this.reachedMilestones}, loadoutLabel: ${_this.loadoutLabel}, rejectionCode: ${_this.rejectionCode}, claimId: ${_this.claimId}, claimed: ${_this.claimed}, milestones: ${_this.milestones}, revealMode: ${_this.revealMode}, minimumDistanceMeters: ${_this.minimumDistanceMeters})';
}


}

/// @nodoc
abstract mixin class $RunDtoCopyWith<$Res>  {
  factory $RunDtoCopyWith(RunDto value, $Res Function(RunDto) _then) = _$RunDtoCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String? trackTitle, RunStatus status, DateTime startedAt, DateTime? finishedAt, double? distanceMeters, int? durationSeconds, double? paceSecondsPerKm, int? netExp, int? coinsEarned, int? milestoneExp, double? expMultiplier, int? runPenaltyExp, int? roleLeaguePoints, int? estimatedCalories, int? streakDays, int? reachedMilestones, String? loadoutLabel, String? rejectionCode, String? claimId, bool claimed, List<TrackMilestoneDto> milestones, RevealMode? revealMode, int? minimumDistanceMeters
});




}
/// @nodoc
class _$RunDtoCopyWithImpl<$Res>
    implements $RunDtoCopyWith<$Res> {
  _$RunDtoCopyWithImpl(this._self, this._then);

  final RunDto _self;
  final $Res Function(RunDto) _then;

/// Create a copy of RunDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackId = null,Object? trackTitle = freezed,Object? status = null,Object? startedAt = null,Object? finishedAt = freezed,Object? distanceMeters = freezed,Object? durationSeconds = freezed,Object? paceSecondsPerKm = freezed,Object? netExp = freezed,Object? coinsEarned = freezed,Object? milestoneExp = freezed,Object? expMultiplier = freezed,Object? runPenaltyExp = freezed,Object? roleLeaguePoints = freezed,Object? estimatedCalories = freezed,Object? streakDays = freezed,Object? reachedMilestones = freezed,Object? loadoutLabel = freezed,Object? rejectionCode = freezed,Object? claimId = freezed,Object? claimed = null,Object? milestones = null,Object? revealMode = freezed,Object? minimumDistanceMeters = freezed,}) {
  return _then(RunDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,trackTitle: freezed == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RunStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,paceSecondsPerKm: freezed == paceSecondsPerKm ? _self.paceSecondsPerKm : paceSecondsPerKm // ignore: cast_nullable_to_non_nullable
as double?,netExp: freezed == netExp ? _self.netExp : netExp // ignore: cast_nullable_to_non_nullable
as int?,coinsEarned: freezed == coinsEarned ? _self.coinsEarned : coinsEarned // ignore: cast_nullable_to_non_nullable
as int?,milestoneExp: freezed == milestoneExp ? _self.milestoneExp : milestoneExp // ignore: cast_nullable_to_non_nullable
as int?,expMultiplier: freezed == expMultiplier ? _self.expMultiplier : expMultiplier // ignore: cast_nullable_to_non_nullable
as double?,runPenaltyExp: freezed == runPenaltyExp ? _self.runPenaltyExp : runPenaltyExp // ignore: cast_nullable_to_non_nullable
as int?,roleLeaguePoints: freezed == roleLeaguePoints ? _self.roleLeaguePoints : roleLeaguePoints // ignore: cast_nullable_to_non_nullable
as int?,estimatedCalories: freezed == estimatedCalories ? _self.estimatedCalories : estimatedCalories // ignore: cast_nullable_to_non_nullable
as int?,streakDays: freezed == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int?,reachedMilestones: freezed == reachedMilestones ? _self.reachedMilestones : reachedMilestones // ignore: cast_nullable_to_non_nullable
as int?,loadoutLabel: freezed == loadoutLabel ? _self.loadoutLabel : loadoutLabel // ignore: cast_nullable_to_non_nullable
as String?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,claimId: freezed == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String?,claimed: null == claimed ? _self.claimed : claimed // ignore: cast_nullable_to_non_nullable
as bool,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<TrackMilestoneDto>,revealMode: freezed == revealMode ? _self.revealMode : revealMode // ignore: cast_nullable_to_non_nullable
as RevealMode?,minimumDistanceMeters: freezed == minimumDistanceMeters ? _self.minimumDistanceMeters : minimumDistanceMeters // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RunDto].
extension RunDtoPatterns on RunDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunDto value)  $default,){
final _that = this;
switch (_that) {
case _RunDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String trackId,  String? trackTitle,  RunStatus status,  DateTime startedAt,  DateTime? finishedAt,  double? distanceMeters,  int? durationSeconds,  double? paceSecondsPerKm,  int? netExp,  int? coinsEarned,  int? milestoneExp,  double? expMultiplier,  int? runPenaltyExp,  int? roleLeaguePoints,  int? estimatedCalories,  int? streakDays,  int? reachedMilestones,  String? loadoutLabel,  String? rejectionCode,  String? claimId,  bool claimed,  List<TrackMilestoneDto> milestones,  RevealMode? revealMode,  int? minimumDistanceMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunDto() when $default != null:
return $default(_that.id,_that.trackId,_that.trackTitle,_that.status,_that.startedAt,_that.finishedAt,_that.distanceMeters,_that.durationSeconds,_that.paceSecondsPerKm,_that.netExp,_that.coinsEarned,_that.milestoneExp,_that.expMultiplier,_that.runPenaltyExp,_that.roleLeaguePoints,_that.estimatedCalories,_that.streakDays,_that.reachedMilestones,_that.loadoutLabel,_that.rejectionCode,_that.claimId,_that.claimed,_that.milestones,_that.revealMode,_that.minimumDistanceMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String trackId,  String? trackTitle,  RunStatus status,  DateTime startedAt,  DateTime? finishedAt,  double? distanceMeters,  int? durationSeconds,  double? paceSecondsPerKm,  int? netExp,  int? coinsEarned,  int? milestoneExp,  double? expMultiplier,  int? runPenaltyExp,  int? roleLeaguePoints,  int? estimatedCalories,  int? streakDays,  int? reachedMilestones,  String? loadoutLabel,  String? rejectionCode,  String? claimId,  bool claimed,  List<TrackMilestoneDto> milestones,  RevealMode? revealMode,  int? minimumDistanceMeters)  $default,) {final _that = this;
switch (_that) {
case _RunDto():
return $default(_that.id,_that.trackId,_that.trackTitle,_that.status,_that.startedAt,_that.finishedAt,_that.distanceMeters,_that.durationSeconds,_that.paceSecondsPerKm,_that.netExp,_that.coinsEarned,_that.milestoneExp,_that.expMultiplier,_that.runPenaltyExp,_that.roleLeaguePoints,_that.estimatedCalories,_that.streakDays,_that.reachedMilestones,_that.loadoutLabel,_that.rejectionCode,_that.claimId,_that.claimed,_that.milestones,_that.revealMode,_that.minimumDistanceMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String trackId,  String? trackTitle,  RunStatus status,  DateTime startedAt,  DateTime? finishedAt,  double? distanceMeters,  int? durationSeconds,  double? paceSecondsPerKm,  int? netExp,  int? coinsEarned,  int? milestoneExp,  double? expMultiplier,  int? runPenaltyExp,  int? roleLeaguePoints,  int? estimatedCalories,  int? streakDays,  int? reachedMilestones,  String? loadoutLabel,  String? rejectionCode,  String? claimId,  bool claimed,  List<TrackMilestoneDto> milestones,  RevealMode? revealMode,  int? minimumDistanceMeters)?  $default,) {final _that = this;
switch (_that) {
case _RunDto() when $default != null:
return $default(_that.id,_that.trackId,_that.trackTitle,_that.status,_that.startedAt,_that.finishedAt,_that.distanceMeters,_that.durationSeconds,_that.paceSecondsPerKm,_that.netExp,_that.coinsEarned,_that.milestoneExp,_that.expMultiplier,_that.runPenaltyExp,_that.roleLeaguePoints,_that.estimatedCalories,_that.streakDays,_that.reachedMilestones,_that.loadoutLabel,_that.rejectionCode,_that.claimId,_that.claimed,_that.milestones,_that.revealMode,_that.minimumDistanceMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunDto implements RunDto {
  const _RunDto({required this.id, required this.trackId, this.trackTitle, required this.status, required this.startedAt, this.finishedAt, this.distanceMeters, this.durationSeconds, this.paceSecondsPerKm, this.netExp, this.coinsEarned, this.milestoneExp, this.expMultiplier, this.runPenaltyExp, this.roleLeaguePoints, this.estimatedCalories, this.streakDays, this.reachedMilestones, this.loadoutLabel, this.rejectionCode, this.claimId, this.claimed = false,  List<TrackMilestoneDto> milestones = const <TrackMilestoneDto>[], this.revealMode, this.minimumDistanceMeters}): _milestones = milestones;
  factory _RunDto.fromJson(Map<String, dynamic> json) => _$RunDtoFromJson(json);

@override final  String id;
@override final  String trackId;
@override final  String? trackTitle;
@override final  RunStatus status;
@override final  DateTime startedAt;
@override final  DateTime? finishedAt;
@override final  double? distanceMeters;
@override final  int? durationSeconds;
@override final  double? paceSecondsPerKm;
@override final  int? netExp;
@override final  int? coinsEarned;
@override final  int? milestoneExp;
@override final  double? expMultiplier;
@override final  int? runPenaltyExp;
@override final  int? roleLeaguePoints;
@override final  int? estimatedCalories;
@override final  int? streakDays;
@override final  int? reachedMilestones;
@override final  String? loadoutLabel;
@override final  String? rejectionCode;
@override final  String? claimId;
@override@JsonKey() final  bool claimed;
 final  List<TrackMilestoneDto> _milestones;
@override@JsonKey() List<TrackMilestoneDto> get milestones {
  if (_milestones is EqualUnmodifiableListView) return _milestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestones);
}

@override final  RevealMode? revealMode;
@override final  int? minimumDistanceMeters;

/// Create a copy of RunDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunDtoCopyWith<_RunDto> get copyWith => __$RunDtoCopyWithImpl<_RunDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunDto&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackTitle, trackTitle) || other.trackTitle == trackTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.paceSecondsPerKm, paceSecondsPerKm) || other.paceSecondsPerKm == paceSecondsPerKm)&&(identical(other.netExp, netExp) || other.netExp == netExp)&&(identical(other.coinsEarned, coinsEarned) || other.coinsEarned == coinsEarned)&&(identical(other.milestoneExp, milestoneExp) || other.milestoneExp == milestoneExp)&&(identical(other.expMultiplier, expMultiplier) || other.expMultiplier == expMultiplier)&&(identical(other.runPenaltyExp, runPenaltyExp) || other.runPenaltyExp == runPenaltyExp)&&(identical(other.roleLeaguePoints, roleLeaguePoints) || other.roleLeaguePoints == roleLeaguePoints)&&(identical(other.estimatedCalories, estimatedCalories) || other.estimatedCalories == estimatedCalories)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.reachedMilestones, reachedMilestones) || other.reachedMilestones == reachedMilestones)&&(identical(other.loadoutLabel, loadoutLabel) || other.loadoutLabel == loadoutLabel)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimed, claimed) || other.claimed == claimed)&&const DeepCollectionEquality().equals(other.milestones, _milestones)&&(identical(other.revealMode, revealMode) || other.revealMode == revealMode)&&(identical(other.minimumDistanceMeters, minimumDistanceMeters) || other.minimumDistanceMeters == minimumDistanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,trackId,trackTitle,status,startedAt,finishedAt,distanceMeters,durationSeconds,paceSecondsPerKm,netExp,coinsEarned,milestoneExp,expMultiplier,runPenaltyExp,roleLeaguePoints,estimatedCalories,streakDays,reachedMilestones,loadoutLabel,rejectionCode,claimId,claimed,const DeepCollectionEquality().hash(_milestones),revealMode,minimumDistanceMeters]);
}

@override
String toString() {
    return 'RunDto(id: $id, trackId: $trackId, trackTitle: $trackTitle, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, paceSecondsPerKm: $paceSecondsPerKm, netExp: $netExp, coinsEarned: $coinsEarned, milestoneExp: $milestoneExp, expMultiplier: $expMultiplier, runPenaltyExp: $runPenaltyExp, roleLeaguePoints: $roleLeaguePoints, estimatedCalories: $estimatedCalories, streakDays: $streakDays, reachedMilestones: $reachedMilestones, loadoutLabel: $loadoutLabel, rejectionCode: $rejectionCode, claimId: $claimId, claimed: $claimed, milestones: $milestones, revealMode: $revealMode, minimumDistanceMeters: $minimumDistanceMeters)';
}


}

/// @nodoc
abstract mixin class _$RunDtoCopyWith<$Res> implements $RunDtoCopyWith<$Res> {
  factory _$RunDtoCopyWith(_RunDto value, $Res Function(_RunDto) _then) = __$RunDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String? trackTitle, RunStatus status, DateTime startedAt, DateTime? finishedAt, double? distanceMeters, int? durationSeconds, double? paceSecondsPerKm, int? netExp, int? coinsEarned, int? milestoneExp, double? expMultiplier, int? runPenaltyExp, int? roleLeaguePoints, int? estimatedCalories, int? streakDays, int? reachedMilestones, String? loadoutLabel, String? rejectionCode, String? claimId, bool claimed, List<TrackMilestoneDto> milestones, RevealMode? revealMode, int? minimumDistanceMeters
});




}
/// @nodoc
class __$RunDtoCopyWithImpl<$Res>
    implements _$RunDtoCopyWith<$Res> {
  __$RunDtoCopyWithImpl(this._self, this._then);

  final _RunDto _self;
  final $Res Function(_RunDto) _then;

/// Create a copy of RunDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? trackTitle = freezed,Object? status = null,Object? startedAt = null,Object? finishedAt = freezed,Object? distanceMeters = freezed,Object? durationSeconds = freezed,Object? paceSecondsPerKm = freezed,Object? netExp = freezed,Object? coinsEarned = freezed,Object? milestoneExp = freezed,Object? expMultiplier = freezed,Object? runPenaltyExp = freezed,Object? roleLeaguePoints = freezed,Object? estimatedCalories = freezed,Object? streakDays = freezed,Object? reachedMilestones = freezed,Object? loadoutLabel = freezed,Object? rejectionCode = freezed,Object? claimId = freezed,Object? claimed = null,Object? milestones = null,Object? revealMode = freezed,Object? minimumDistanceMeters = freezed,}) {
  return _then(_RunDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,trackTitle: freezed == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RunStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,paceSecondsPerKm: freezed == paceSecondsPerKm ? _self.paceSecondsPerKm : paceSecondsPerKm // ignore: cast_nullable_to_non_nullable
as double?,netExp: freezed == netExp ? _self.netExp : netExp // ignore: cast_nullable_to_non_nullable
as int?,coinsEarned: freezed == coinsEarned ? _self.coinsEarned : coinsEarned // ignore: cast_nullable_to_non_nullable
as int?,milestoneExp: freezed == milestoneExp ? _self.milestoneExp : milestoneExp // ignore: cast_nullable_to_non_nullable
as int?,expMultiplier: freezed == expMultiplier ? _self.expMultiplier : expMultiplier // ignore: cast_nullable_to_non_nullable
as double?,runPenaltyExp: freezed == runPenaltyExp ? _self.runPenaltyExp : runPenaltyExp // ignore: cast_nullable_to_non_nullable
as int?,roleLeaguePoints: freezed == roleLeaguePoints ? _self.roleLeaguePoints : roleLeaguePoints // ignore: cast_nullable_to_non_nullable
as int?,estimatedCalories: freezed == estimatedCalories ? _self.estimatedCalories : estimatedCalories // ignore: cast_nullable_to_non_nullable
as int?,streakDays: freezed == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int?,reachedMilestones: freezed == reachedMilestones ? _self.reachedMilestones : reachedMilestones // ignore: cast_nullable_to_non_nullable
as int?,loadoutLabel: freezed == loadoutLabel ? _self.loadoutLabel : loadoutLabel // ignore: cast_nullable_to_non_nullable
as String?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,claimId: freezed == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String?,claimed: null == claimed ? _self.claimed : claimed // ignore: cast_nullable_to_non_nullable
as bool,milestones: null == milestones ? _self._milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<TrackMilestoneDto>,revealMode: freezed == revealMode ? _self.revealMode : revealMode // ignore: cast_nullable_to_non_nullable
as RevealMode?,minimumDistanceMeters: freezed == minimumDistanceMeters ? _self.minimumDistanceMeters : minimumDistanceMeters // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RunPointDto {

 double get latitude; double get longitude; DateTime get recordedAt; double? get accuracyMeters; double? get speedMetersPerSecond; bool get mocked;
/// Create a copy of RunPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunPointDtoCopyWith<RunPointDto> get copyWith => _$RunPointDtoCopyWithImpl<RunPointDto>(this as RunPointDto, _$identity);

  /// Serializes this RunPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RunPointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunPointDto&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt)&&(identical(other.accuracyMeters, _this.accuracyMeters) || other.accuracyMeters == _this.accuracyMeters)&&(identical(other.speedMetersPerSecond, _this.speedMetersPerSecond) || other.speedMetersPerSecond == _this.speedMetersPerSecond)&&(identical(other.mocked, _this.mocked) || other.mocked == _this.mocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RunPointDto;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.recordedAt,_this.accuracyMeters,_this.speedMetersPerSecond,_this.mocked);
}

@override
String toString() {
  final _this = this as RunPointDto;
  return 'RunPointDto(latitude: ${_this.latitude}, longitude: ${_this.longitude}, recordedAt: ${_this.recordedAt}, accuracyMeters: ${_this.accuracyMeters}, speedMetersPerSecond: ${_this.speedMetersPerSecond}, mocked: ${_this.mocked})';
}


}

/// @nodoc
abstract mixin class $RunPointDtoCopyWith<$Res>  {
  factory $RunPointDtoCopyWith(RunPointDto value, $Res Function(RunPointDto) _then) = _$RunPointDtoCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, DateTime recordedAt, double? accuracyMeters, double? speedMetersPerSecond, bool mocked
});




}
/// @nodoc
class _$RunPointDtoCopyWithImpl<$Res>
    implements $RunPointDtoCopyWith<$Res> {
  _$RunPointDtoCopyWithImpl(this._self, this._then);

  final RunPointDto _self;
  final $Res Function(RunPointDto) _then;

/// Create a copy of RunPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? recordedAt = null,Object? accuracyMeters = freezed,Object? speedMetersPerSecond = freezed,Object? mocked = null,}) {
  return _then(RunPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,speedMetersPerSecond: freezed == speedMetersPerSecond ? _self.speedMetersPerSecond : speedMetersPerSecond // ignore: cast_nullable_to_non_nullable
as double?,mocked: null == mocked ? _self.mocked : mocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RunPointDto].
extension RunPointDtoPatterns on RunPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunPointDto value)  $default,){
final _that = this;
switch (_that) {
case _RunPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  DateTime recordedAt,  double? accuracyMeters,  double? speedMetersPerSecond,  bool mocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunPointDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.recordedAt,_that.accuracyMeters,_that.speedMetersPerSecond,_that.mocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  DateTime recordedAt,  double? accuracyMeters,  double? speedMetersPerSecond,  bool mocked)  $default,) {final _that = this;
switch (_that) {
case _RunPointDto():
return $default(_that.latitude,_that.longitude,_that.recordedAt,_that.accuracyMeters,_that.speedMetersPerSecond,_that.mocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  DateTime recordedAt,  double? accuracyMeters,  double? speedMetersPerSecond,  bool mocked)?  $default,) {final _that = this;
switch (_that) {
case _RunPointDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.recordedAt,_that.accuracyMeters,_that.speedMetersPerSecond,_that.mocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunPointDto implements RunPointDto {
  const _RunPointDto({required this.latitude, required this.longitude, required this.recordedAt, this.accuracyMeters, this.speedMetersPerSecond, this.mocked = false});
  factory _RunPointDto.fromJson(Map<String, dynamic> json) => _$RunPointDtoFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override final  DateTime recordedAt;
@override final  double? accuracyMeters;
@override final  double? speedMetersPerSecond;
@override@JsonKey() final  bool mocked;

/// Create a copy of RunPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunPointDtoCopyWith<_RunPointDto> get copyWith => __$RunPointDtoCopyWithImpl<_RunPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunPointDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters)&&(identical(other.speedMetersPerSecond, speedMetersPerSecond) || other.speedMetersPerSecond == speedMetersPerSecond)&&(identical(other.mocked, mocked) || other.mocked == mocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,recordedAt,accuracyMeters,speedMetersPerSecond,mocked);
}

@override
String toString() {
    return 'RunPointDto(latitude: $latitude, longitude: $longitude, recordedAt: $recordedAt, accuracyMeters: $accuracyMeters, speedMetersPerSecond: $speedMetersPerSecond, mocked: $mocked)';
}


}

/// @nodoc
abstract mixin class _$RunPointDtoCopyWith<$Res> implements $RunPointDtoCopyWith<$Res> {
  factory _$RunPointDtoCopyWith(_RunPointDto value, $Res Function(_RunPointDto) _then) = __$RunPointDtoCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, DateTime recordedAt, double? accuracyMeters, double? speedMetersPerSecond, bool mocked
});




}
/// @nodoc
class __$RunPointDtoCopyWithImpl<$Res>
    implements _$RunPointDtoCopyWith<$Res> {
  __$RunPointDtoCopyWithImpl(this._self, this._then);

  final _RunPointDto _self;
  final $Res Function(_RunPointDto) _then;

/// Create a copy of RunPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? recordedAt = null,Object? accuracyMeters = freezed,Object? speedMetersPerSecond = freezed,Object? mocked = null,}) {
  return _then(_RunPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,speedMetersPerSecond: freezed == speedMetersPerSecond ? _self.speedMetersPerSecond : speedMetersPerSecond // ignore: cast_nullable_to_non_nullable
as double?,mocked: null == mocked ? _self.mocked : mocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RunPointsRequestDto {

 List<RunPointDto> get points; int get firstSequence;
/// Create a copy of RunPointsRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunPointsRequestDtoCopyWith<RunPointsRequestDto> get copyWith => _$RunPointsRequestDtoCopyWithImpl<RunPointsRequestDto>(this as RunPointsRequestDto, _$identity);

  /// Serializes this RunPointsRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RunPointsRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunPointsRequestDto&&const DeepCollectionEquality().equals(other.points, _this.points)&&(identical(other.firstSequence, _this.firstSequence) || other.firstSequence == _this.firstSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RunPointsRequestDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.points),_this.firstSequence);
}

@override
String toString() {
  final _this = this as RunPointsRequestDto;
  return 'RunPointsRequestDto(points: ${_this.points}, firstSequence: ${_this.firstSequence})';
}


}

/// @nodoc
abstract mixin class $RunPointsRequestDtoCopyWith<$Res>  {
  factory $RunPointsRequestDtoCopyWith(RunPointsRequestDto value, $Res Function(RunPointsRequestDto) _then) = _$RunPointsRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<RunPointDto> points, int firstSequence
});




}
/// @nodoc
class _$RunPointsRequestDtoCopyWithImpl<$Res>
    implements $RunPointsRequestDtoCopyWith<$Res> {
  _$RunPointsRequestDtoCopyWithImpl(this._self, this._then);

  final RunPointsRequestDto _self;
  final $Res Function(RunPointsRequestDto) _then;

/// Create a copy of RunPointsRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? firstSequence = null,}) {
  return _then(RunPointsRequestDto(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,firstSequence: null == firstSequence ? _self.firstSequence : firstSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RunPointsRequestDto].
extension RunPointsRequestDtoPatterns on RunPointsRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunPointsRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunPointsRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunPointsRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RunPointsRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunPointsRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunPointsRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RunPointDto> points,  int firstSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunPointsRequestDto() when $default != null:
return $default(_that.points,_that.firstSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RunPointDto> points,  int firstSequence)  $default,) {final _that = this;
switch (_that) {
case _RunPointsRequestDto():
return $default(_that.points,_that.firstSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RunPointDto> points,  int firstSequence)?  $default,) {final _that = this;
switch (_that) {
case _RunPointsRequestDto() when $default != null:
return $default(_that.points,_that.firstSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunPointsRequestDto implements RunPointsRequestDto {
  const _RunPointsRequestDto({required  List<RunPointDto> points, this.firstSequence = 1}): _points = points;
  factory _RunPointsRequestDto.fromJson(Map<String, dynamic> json) => _$RunPointsRequestDtoFromJson(json);

 final  List<RunPointDto> _points;
@override List<RunPointDto> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  int firstSequence;

/// Create a copy of RunPointsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunPointsRequestDtoCopyWith<_RunPointsRequestDto> get copyWith => __$RunPointsRequestDtoCopyWithImpl<_RunPointsRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunPointsRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunPointsRequestDto&&const DeepCollectionEquality().equals(other.points, _points)&&(identical(other.firstSequence, firstSequence) || other.firstSequence == firstSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),firstSequence);
}

@override
String toString() {
    return 'RunPointsRequestDto(points: $points, firstSequence: $firstSequence)';
}


}

/// @nodoc
abstract mixin class _$RunPointsRequestDtoCopyWith<$Res> implements $RunPointsRequestDtoCopyWith<$Res> {
  factory _$RunPointsRequestDtoCopyWith(_RunPointsRequestDto value, $Res Function(_RunPointsRequestDto) _then) = __$RunPointsRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RunPointDto> points, int firstSequence
});




}
/// @nodoc
class __$RunPointsRequestDtoCopyWithImpl<$Res>
    implements _$RunPointsRequestDtoCopyWith<$Res> {
  __$RunPointsRequestDtoCopyWithImpl(this._self, this._then);

  final _RunPointsRequestDto _self;
  final $Res Function(_RunPointsRequestDto) _then;

/// Create a copy of RunPointsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? firstSequence = null,}) {
  return _then(_RunPointsRequestDto(
points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,firstSequence: null == firstSequence ? _self.firstSequence : firstSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MilestoneCheckRequestDto {

 String get milestoneId; RunPointDto get currentPoint; int get lastSampleSequence;
/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneCheckRequestDtoCopyWith<MilestoneCheckRequestDto> get copyWith => _$MilestoneCheckRequestDtoCopyWithImpl<MilestoneCheckRequestDto>(this as MilestoneCheckRequestDto, _$identity);

  /// Serializes this MilestoneCheckRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MilestoneCheckRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneCheckRequestDto&&(identical(other.milestoneId, _this.milestoneId) || other.milestoneId == _this.milestoneId)&&(identical(other.currentPoint, _this.currentPoint) || other.currentPoint == _this.currentPoint)&&(identical(other.lastSampleSequence, _this.lastSampleSequence) || other.lastSampleSequence == _this.lastSampleSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MilestoneCheckRequestDto;
  return Object.hash(runtimeType,_this.milestoneId,_this.currentPoint,_this.lastSampleSequence);
}

@override
String toString() {
  final _this = this as MilestoneCheckRequestDto;
  return 'MilestoneCheckRequestDto(milestoneId: ${_this.milestoneId}, currentPoint: ${_this.currentPoint}, lastSampleSequence: ${_this.lastSampleSequence})';
}


}

/// @nodoc
abstract mixin class $MilestoneCheckRequestDtoCopyWith<$Res>  {
  factory $MilestoneCheckRequestDtoCopyWith(MilestoneCheckRequestDto value, $Res Function(MilestoneCheckRequestDto) _then) = _$MilestoneCheckRequestDtoCopyWithImpl;
@useResult
$Res call({
 String milestoneId, RunPointDto currentPoint, int lastSampleSequence
});


$RunPointDtoCopyWith<$Res> get currentPoint;

}
/// @nodoc
class _$MilestoneCheckRequestDtoCopyWithImpl<$Res>
    implements $MilestoneCheckRequestDtoCopyWith<$Res> {
  _$MilestoneCheckRequestDtoCopyWithImpl(this._self, this._then);

  final MilestoneCheckRequestDto _self;
  final $Res Function(MilestoneCheckRequestDto) _then;

/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? milestoneId = null,Object? currentPoint = null,Object? lastSampleSequence = null,}) {
  return _then(MilestoneCheckRequestDto(
milestoneId: null == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String,currentPoint: null == currentPoint ? _self.currentPoint : currentPoint // ignore: cast_nullable_to_non_nullable
as RunPointDto,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunPointDtoCopyWith<$Res> get currentPoint {
  
  return $RunPointDtoCopyWith<$Res>(_self.currentPoint, (value) {
    return _then(_self.copyWith(currentPoint: value));
  });
}
}


/// Adds pattern-matching-related methods to [MilestoneCheckRequestDto].
extension MilestoneCheckRequestDtoPatterns on MilestoneCheckRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneCheckRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneCheckRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneCheckRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String milestoneId,  RunPointDto currentPoint,  int lastSampleSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto() when $default != null:
return $default(_that.milestoneId,_that.currentPoint,_that.lastSampleSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String milestoneId,  RunPointDto currentPoint,  int lastSampleSequence)  $default,) {final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto():
return $default(_that.milestoneId,_that.currentPoint,_that.lastSampleSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String milestoneId,  RunPointDto currentPoint,  int lastSampleSequence)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneCheckRequestDto() when $default != null:
return $default(_that.milestoneId,_that.currentPoint,_that.lastSampleSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneCheckRequestDto implements MilestoneCheckRequestDto {
  const _MilestoneCheckRequestDto({required this.milestoneId, required this.currentPoint, this.lastSampleSequence = 0});
  factory _MilestoneCheckRequestDto.fromJson(Map<String, dynamic> json) => _$MilestoneCheckRequestDtoFromJson(json);

@override final  String milestoneId;
@override final  RunPointDto currentPoint;
@override@JsonKey() final  int lastSampleSequence;

/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneCheckRequestDtoCopyWith<_MilestoneCheckRequestDto> get copyWith => __$MilestoneCheckRequestDtoCopyWithImpl<_MilestoneCheckRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneCheckRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneCheckRequestDto&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.currentPoint, currentPoint) || other.currentPoint == currentPoint)&&(identical(other.lastSampleSequence, lastSampleSequence) || other.lastSampleSequence == lastSampleSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,milestoneId,currentPoint,lastSampleSequence);
}

@override
String toString() {
    return 'MilestoneCheckRequestDto(milestoneId: $milestoneId, currentPoint: $currentPoint, lastSampleSequence: $lastSampleSequence)';
}


}

/// @nodoc
abstract mixin class _$MilestoneCheckRequestDtoCopyWith<$Res> implements $MilestoneCheckRequestDtoCopyWith<$Res> {
  factory _$MilestoneCheckRequestDtoCopyWith(_MilestoneCheckRequestDto value, $Res Function(_MilestoneCheckRequestDto) _then) = __$MilestoneCheckRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String milestoneId, RunPointDto currentPoint, int lastSampleSequence
});


@override $RunPointDtoCopyWith<$Res> get currentPoint;

}
/// @nodoc
class __$MilestoneCheckRequestDtoCopyWithImpl<$Res>
    implements _$MilestoneCheckRequestDtoCopyWith<$Res> {
  __$MilestoneCheckRequestDtoCopyWithImpl(this._self, this._then);

  final _MilestoneCheckRequestDto _self;
  final $Res Function(_MilestoneCheckRequestDto) _then;

/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? milestoneId = null,Object? currentPoint = null,Object? lastSampleSequence = null,}) {
  return _then(_MilestoneCheckRequestDto(
milestoneId: null == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String,currentPoint: null == currentPoint ? _self.currentPoint : currentPoint // ignore: cast_nullable_to_non_nullable
as RunPointDto,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MilestoneCheckRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunPointDtoCopyWith<$Res> get currentPoint {
  
  return $RunPointDtoCopyWith<$Res>(_self.currentPoint, (value) {
    return _then(_self.copyWith(currentPoint: value));
  });
}
}


/// @nodoc
mixin _$MilestoneCheckResponseDto {

 bool get reached; int? get expAwarded; String? get safetyMessage; String? get nextMilestoneId;
/// Create a copy of MilestoneCheckResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneCheckResponseDtoCopyWith<MilestoneCheckResponseDto> get copyWith => _$MilestoneCheckResponseDtoCopyWithImpl<MilestoneCheckResponseDto>(this as MilestoneCheckResponseDto, _$identity);

  /// Serializes this MilestoneCheckResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MilestoneCheckResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneCheckResponseDto&&(identical(other.reached, _this.reached) || other.reached == _this.reached)&&(identical(other.expAwarded, _this.expAwarded) || other.expAwarded == _this.expAwarded)&&(identical(other.safetyMessage, _this.safetyMessage) || other.safetyMessage == _this.safetyMessage)&&(identical(other.nextMilestoneId, _this.nextMilestoneId) || other.nextMilestoneId == _this.nextMilestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MilestoneCheckResponseDto;
  return Object.hash(runtimeType,_this.reached,_this.expAwarded,_this.safetyMessage,_this.nextMilestoneId);
}

@override
String toString() {
  final _this = this as MilestoneCheckResponseDto;
  return 'MilestoneCheckResponseDto(reached: ${_this.reached}, expAwarded: ${_this.expAwarded}, safetyMessage: ${_this.safetyMessage}, nextMilestoneId: ${_this.nextMilestoneId})';
}


}

/// @nodoc
abstract mixin class $MilestoneCheckResponseDtoCopyWith<$Res>  {
  factory $MilestoneCheckResponseDtoCopyWith(MilestoneCheckResponseDto value, $Res Function(MilestoneCheckResponseDto) _then) = _$MilestoneCheckResponseDtoCopyWithImpl;
@useResult
$Res call({
 bool reached, int? expAwarded, String? safetyMessage, String? nextMilestoneId
});




}
/// @nodoc
class _$MilestoneCheckResponseDtoCopyWithImpl<$Res>
    implements $MilestoneCheckResponseDtoCopyWith<$Res> {
  _$MilestoneCheckResponseDtoCopyWithImpl(this._self, this._then);

  final MilestoneCheckResponseDto _self;
  final $Res Function(MilestoneCheckResponseDto) _then;

/// Create a copy of MilestoneCheckResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reached = null,Object? expAwarded = freezed,Object? safetyMessage = freezed,Object? nextMilestoneId = freezed,}) {
  return _then(MilestoneCheckResponseDto(
reached: null == reached ? _self.reached : reached // ignore: cast_nullable_to_non_nullable
as bool,expAwarded: freezed == expAwarded ? _self.expAwarded : expAwarded // ignore: cast_nullable_to_non_nullable
as int?,safetyMessage: freezed == safetyMessage ? _self.safetyMessage : safetyMessage // ignore: cast_nullable_to_non_nullable
as String?,nextMilestoneId: freezed == nextMilestoneId ? _self.nextMilestoneId : nextMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneCheckResponseDto].
extension MilestoneCheckResponseDtoPatterns on MilestoneCheckResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneCheckResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneCheckResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneCheckResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool reached,  int? expAwarded,  String? safetyMessage,  String? nextMilestoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto() when $default != null:
return $default(_that.reached,_that.expAwarded,_that.safetyMessage,_that.nextMilestoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool reached,  int? expAwarded,  String? safetyMessage,  String? nextMilestoneId)  $default,) {final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto():
return $default(_that.reached,_that.expAwarded,_that.safetyMessage,_that.nextMilestoneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool reached,  int? expAwarded,  String? safetyMessage,  String? nextMilestoneId)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneCheckResponseDto() when $default != null:
return $default(_that.reached,_that.expAwarded,_that.safetyMessage,_that.nextMilestoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneCheckResponseDto implements MilestoneCheckResponseDto {
  const _MilestoneCheckResponseDto({required this.reached, this.expAwarded, this.safetyMessage, this.nextMilestoneId});
  factory _MilestoneCheckResponseDto.fromJson(Map<String, dynamic> json) => _$MilestoneCheckResponseDtoFromJson(json);

@override final  bool reached;
@override final  int? expAwarded;
@override final  String? safetyMessage;
@override final  String? nextMilestoneId;

/// Create a copy of MilestoneCheckResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneCheckResponseDtoCopyWith<_MilestoneCheckResponseDto> get copyWith => __$MilestoneCheckResponseDtoCopyWithImpl<_MilestoneCheckResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneCheckResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneCheckResponseDto&&(identical(other.reached, reached) || other.reached == reached)&&(identical(other.expAwarded, expAwarded) || other.expAwarded == expAwarded)&&(identical(other.safetyMessage, safetyMessage) || other.safetyMessage == safetyMessage)&&(identical(other.nextMilestoneId, nextMilestoneId) || other.nextMilestoneId == nextMilestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,reached,expAwarded,safetyMessage,nextMilestoneId);
}

@override
String toString() {
    return 'MilestoneCheckResponseDto(reached: $reached, expAwarded: $expAwarded, safetyMessage: $safetyMessage, nextMilestoneId: $nextMilestoneId)';
}


}

/// @nodoc
abstract mixin class _$MilestoneCheckResponseDtoCopyWith<$Res> implements $MilestoneCheckResponseDtoCopyWith<$Res> {
  factory _$MilestoneCheckResponseDtoCopyWith(_MilestoneCheckResponseDto value, $Res Function(_MilestoneCheckResponseDto) _then) = __$MilestoneCheckResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 bool reached, int? expAwarded, String? safetyMessage, String? nextMilestoneId
});




}
/// @nodoc
class __$MilestoneCheckResponseDtoCopyWithImpl<$Res>
    implements _$MilestoneCheckResponseDtoCopyWith<$Res> {
  __$MilestoneCheckResponseDtoCopyWithImpl(this._self, this._then);

  final _MilestoneCheckResponseDto _self;
  final $Res Function(_MilestoneCheckResponseDto) _then;

/// Create a copy of MilestoneCheckResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reached = null,Object? expAwarded = freezed,Object? safetyMessage = freezed,Object? nextMilestoneId = freezed,}) {
  return _then(_MilestoneCheckResponseDto(
reached: null == reached ? _self.reached : reached // ignore: cast_nullable_to_non_nullable
as bool,expAwarded: freezed == expAwarded ? _self.expAwarded : expAwarded // ignore: cast_nullable_to_non_nullable
as int?,safetyMessage: freezed == safetyMessage ? _self.safetyMessage : safetyMessage // ignore: cast_nullable_to_non_nullable
as String?,nextMilestoneId: freezed == nextMilestoneId ? _self.nextMilestoneId : nextMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FinishRunRequestDto {

 List<RunPointDto> get remainingPoints; DateTime? get endedAt; int get lastSampleSequence; double? get distanceMeters; int? get durationSeconds;
/// Create a copy of FinishRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishRunRequestDtoCopyWith<FinishRunRequestDto> get copyWith => _$FinishRunRequestDtoCopyWithImpl<FinishRunRequestDto>(this as FinishRunRequestDto, _$identity);

  /// Serializes this FinishRunRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinishRunRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishRunRequestDto&&const DeepCollectionEquality().equals(other.remainingPoints, _this.remainingPoints)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.lastSampleSequence, _this.lastSampleSequence) || other.lastSampleSequence == _this.lastSampleSequence)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinishRunRequestDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.remainingPoints),_this.endedAt,_this.lastSampleSequence,_this.distanceMeters,_this.durationSeconds);
}

@override
String toString() {
  final _this = this as FinishRunRequestDto;
  return 'FinishRunRequestDto(remainingPoints: ${_this.remainingPoints}, endedAt: ${_this.endedAt}, lastSampleSequence: ${_this.lastSampleSequence}, distanceMeters: ${_this.distanceMeters}, durationSeconds: ${_this.durationSeconds})';
}


}

/// @nodoc
abstract mixin class $FinishRunRequestDtoCopyWith<$Res>  {
  factory $FinishRunRequestDtoCopyWith(FinishRunRequestDto value, $Res Function(FinishRunRequestDto) _then) = _$FinishRunRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<RunPointDto> remainingPoints, DateTime? endedAt, int lastSampleSequence, double? distanceMeters, int? durationSeconds
});




}
/// @nodoc
class _$FinishRunRequestDtoCopyWithImpl<$Res>
    implements $FinishRunRequestDtoCopyWith<$Res> {
  _$FinishRunRequestDtoCopyWithImpl(this._self, this._then);

  final FinishRunRequestDto _self;
  final $Res Function(FinishRunRequestDto) _then;

/// Create a copy of FinishRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? remainingPoints = null,Object? endedAt = freezed,Object? lastSampleSequence = null,Object? distanceMeters = freezed,Object? durationSeconds = freezed,}) {
  return _then(FinishRunRequestDto(
remainingPoints: null == remainingPoints ? _self.remainingPoints : remainingPoints // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishRunRequestDto].
extension FinishRunRequestDtoPatterns on FinishRunRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishRunRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishRunRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishRunRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _FinishRunRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishRunRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _FinishRunRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RunPointDto> remainingPoints,  DateTime? endedAt,  int lastSampleSequence,  double? distanceMeters,  int? durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishRunRequestDto() when $default != null:
return $default(_that.remainingPoints,_that.endedAt,_that.lastSampleSequence,_that.distanceMeters,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RunPointDto> remainingPoints,  DateTime? endedAt,  int lastSampleSequence,  double? distanceMeters,  int? durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _FinishRunRequestDto():
return $default(_that.remainingPoints,_that.endedAt,_that.lastSampleSequence,_that.distanceMeters,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RunPointDto> remainingPoints,  DateTime? endedAt,  int lastSampleSequence,  double? distanceMeters,  int? durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _FinishRunRequestDto() when $default != null:
return $default(_that.remainingPoints,_that.endedAt,_that.lastSampleSequence,_that.distanceMeters,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishRunRequestDto implements FinishRunRequestDto {
  const _FinishRunRequestDto({ List<RunPointDto> remainingPoints = const <RunPointDto>[], this.endedAt, this.lastSampleSequence = 0, this.distanceMeters, this.durationSeconds}): _remainingPoints = remainingPoints;
  factory _FinishRunRequestDto.fromJson(Map<String, dynamic> json) => _$FinishRunRequestDtoFromJson(json);

 final  List<RunPointDto> _remainingPoints;
@override@JsonKey() List<RunPointDto> get remainingPoints {
  if (_remainingPoints is EqualUnmodifiableListView) return _remainingPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remainingPoints);
}

@override final  DateTime? endedAt;
@override@JsonKey() final  int lastSampleSequence;
@override final  double? distanceMeters;
@override final  int? durationSeconds;

/// Create a copy of FinishRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishRunRequestDtoCopyWith<_FinishRunRequestDto> get copyWith => __$FinishRunRequestDtoCopyWithImpl<_FinishRunRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishRunRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishRunRequestDto&&const DeepCollectionEquality().equals(other.remainingPoints, _remainingPoints)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.lastSampleSequence, lastSampleSequence) || other.lastSampleSequence == lastSampleSequence)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_remainingPoints),endedAt,lastSampleSequence,distanceMeters,durationSeconds);
}

@override
String toString() {
    return 'FinishRunRequestDto(remainingPoints: $remainingPoints, endedAt: $endedAt, lastSampleSequence: $lastSampleSequence, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$FinishRunRequestDtoCopyWith<$Res> implements $FinishRunRequestDtoCopyWith<$Res> {
  factory _$FinishRunRequestDtoCopyWith(_FinishRunRequestDto value, $Res Function(_FinishRunRequestDto) _then) = __$FinishRunRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RunPointDto> remainingPoints, DateTime? endedAt, int lastSampleSequence, double? distanceMeters, int? durationSeconds
});




}
/// @nodoc
class __$FinishRunRequestDtoCopyWithImpl<$Res>
    implements _$FinishRunRequestDtoCopyWith<$Res> {
  __$FinishRunRequestDtoCopyWithImpl(this._self, this._then);

  final _FinishRunRequestDto _self;
  final $Res Function(_FinishRunRequestDto) _then;

/// Create a copy of FinishRunRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? remainingPoints = null,Object? endedAt = freezed,Object? lastSampleSequence = null,Object? distanceMeters = freezed,Object? durationSeconds = freezed,}) {
  return _then(_FinishRunRequestDto(
remainingPoints: null == remainingPoints ? _self._remainingPoints : remainingPoints // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SafeStopRequestDto {

 String? get reasonCode; int get lastSampleSequence;
/// Create a copy of SafeStopRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SafeStopRequestDtoCopyWith<SafeStopRequestDto> get copyWith => _$SafeStopRequestDtoCopyWithImpl<SafeStopRequestDto>(this as SafeStopRequestDto, _$identity);

  /// Serializes this SafeStopRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SafeStopRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SafeStopRequestDto&&(identical(other.reasonCode, _this.reasonCode) || other.reasonCode == _this.reasonCode)&&(identical(other.lastSampleSequence, _this.lastSampleSequence) || other.lastSampleSequence == _this.lastSampleSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SafeStopRequestDto;
  return Object.hash(runtimeType,_this.reasonCode,_this.lastSampleSequence);
}

@override
String toString() {
  final _this = this as SafeStopRequestDto;
  return 'SafeStopRequestDto(reasonCode: ${_this.reasonCode}, lastSampleSequence: ${_this.lastSampleSequence})';
}


}

/// @nodoc
abstract mixin class $SafeStopRequestDtoCopyWith<$Res>  {
  factory $SafeStopRequestDtoCopyWith(SafeStopRequestDto value, $Res Function(SafeStopRequestDto) _then) = _$SafeStopRequestDtoCopyWithImpl;
@useResult
$Res call({
 String? reasonCode, int lastSampleSequence
});




}
/// @nodoc
class _$SafeStopRequestDtoCopyWithImpl<$Res>
    implements $SafeStopRequestDtoCopyWith<$Res> {
  _$SafeStopRequestDtoCopyWithImpl(this._self, this._then);

  final SafeStopRequestDto _self;
  final $Res Function(SafeStopRequestDto) _then;

/// Create a copy of SafeStopRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reasonCode = freezed,Object? lastSampleSequence = null,}) {
  return _then(SafeStopRequestDto(
reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SafeStopRequestDto].
extension SafeStopRequestDtoPatterns on SafeStopRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SafeStopRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SafeStopRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SafeStopRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SafeStopRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SafeStopRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SafeStopRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reasonCode,  int lastSampleSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SafeStopRequestDto() when $default != null:
return $default(_that.reasonCode,_that.lastSampleSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reasonCode,  int lastSampleSequence)  $default,) {final _that = this;
switch (_that) {
case _SafeStopRequestDto():
return $default(_that.reasonCode,_that.lastSampleSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reasonCode,  int lastSampleSequence)?  $default,) {final _that = this;
switch (_that) {
case _SafeStopRequestDto() when $default != null:
return $default(_that.reasonCode,_that.lastSampleSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SafeStopRequestDto implements SafeStopRequestDto {
  const _SafeStopRequestDto({this.reasonCode, this.lastSampleSequence = 0});
  factory _SafeStopRequestDto.fromJson(Map<String, dynamic> json) => _$SafeStopRequestDtoFromJson(json);

@override final  String? reasonCode;
@override@JsonKey() final  int lastSampleSequence;

/// Create a copy of SafeStopRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SafeStopRequestDtoCopyWith<_SafeStopRequestDto> get copyWith => __$SafeStopRequestDtoCopyWithImpl<_SafeStopRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SafeStopRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SafeStopRequestDto&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.lastSampleSequence, lastSampleSequence) || other.lastSampleSequence == lastSampleSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,reasonCode,lastSampleSequence);
}

@override
String toString() {
    return 'SafeStopRequestDto(reasonCode: $reasonCode, lastSampleSequence: $lastSampleSequence)';
}


}

/// @nodoc
abstract mixin class _$SafeStopRequestDtoCopyWith<$Res> implements $SafeStopRequestDtoCopyWith<$Res> {
  factory _$SafeStopRequestDtoCopyWith(_SafeStopRequestDto value, $Res Function(_SafeStopRequestDto) _then) = __$SafeStopRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String? reasonCode, int lastSampleSequence
});




}
/// @nodoc
class __$SafeStopRequestDtoCopyWithImpl<$Res>
    implements _$SafeStopRequestDtoCopyWith<$Res> {
  __$SafeStopRequestDtoCopyWithImpl(this._self, this._then);

  final _SafeStopRequestDto _self;
  final $Res Function(_SafeStopRequestDto) _then;

/// Create a copy of SafeStopRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reasonCode = freezed,Object? lastSampleSequence = null,}) {
  return _then(_SafeStopRequestDto(
reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,lastSampleSequence: null == lastSampleSequence ? _self.lastSampleSequence : lastSampleSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ShopItemDto {

 String get id; String get name; String get description; int get priceCoins; String get effectCode; bool get available; int get maxStock; bool get risky;
/// Create a copy of ShopItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopItemDtoCopyWith<ShopItemDto> get copyWith => _$ShopItemDtoCopyWithImpl<ShopItemDto>(this as ShopItemDto, _$identity);

  /// Serializes this ShopItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ShopItemDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopItemDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priceCoins, _this.priceCoins) || other.priceCoins == _this.priceCoins)&&(identical(other.effectCode, _this.effectCode) || other.effectCode == _this.effectCode)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.maxStock, _this.maxStock) || other.maxStock == _this.maxStock)&&(identical(other.risky, _this.risky) || other.risky == _this.risky));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShopItemDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.priceCoins,_this.effectCode,_this.available,_this.maxStock,_this.risky);
}

@override
String toString() {
  final _this = this as ShopItemDto;
  return 'ShopItemDto(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, priceCoins: ${_this.priceCoins}, effectCode: ${_this.effectCode}, available: ${_this.available}, maxStock: ${_this.maxStock}, risky: ${_this.risky})';
}


}

/// @nodoc
abstract mixin class $ShopItemDtoCopyWith<$Res>  {
  factory $ShopItemDtoCopyWith(ShopItemDto value, $Res Function(ShopItemDto) _then) = _$ShopItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int priceCoins, String effectCode, bool available, int maxStock, bool risky
});




}
/// @nodoc
class _$ShopItemDtoCopyWithImpl<$Res>
    implements $ShopItemDtoCopyWith<$Res> {
  _$ShopItemDtoCopyWithImpl(this._self, this._then);

  final ShopItemDto _self;
  final $Res Function(ShopItemDto) _then;

/// Create a copy of ShopItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? priceCoins = null,Object? effectCode = null,Object? available = null,Object? maxStock = null,Object? risky = null,}) {
  return _then(ShopItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priceCoins: null == priceCoins ? _self.priceCoins : priceCoins // ignore: cast_nullable_to_non_nullable
as int,effectCode: null == effectCode ? _self.effectCode : effectCode // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,maxStock: null == maxStock ? _self.maxStock : maxStock // ignore: cast_nullable_to_non_nullable
as int,risky: null == risky ? _self.risky : risky // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopItemDto].
extension ShopItemDtoPatterns on ShopItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ShopItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShopItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int priceCoins,  String effectCode,  bool available,  int maxStock,  bool risky)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopItemDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.priceCoins,_that.effectCode,_that.available,_that.maxStock,_that.risky);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int priceCoins,  String effectCode,  bool available,  int maxStock,  bool risky)  $default,) {final _that = this;
switch (_that) {
case _ShopItemDto():
return $default(_that.id,_that.name,_that.description,_that.priceCoins,_that.effectCode,_that.available,_that.maxStock,_that.risky);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int priceCoins,  String effectCode,  bool available,  int maxStock,  bool risky)?  $default,) {final _that = this;
switch (_that) {
case _ShopItemDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.priceCoins,_that.effectCode,_that.available,_that.maxStock,_that.risky);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShopItemDto implements ShopItemDto {
  const _ShopItemDto({required this.id, required this.name, required this.description, required this.priceCoins, required this.effectCode, required this.available, this.maxStock = 0, this.risky = false});
  factory _ShopItemDto.fromJson(Map<String, dynamic> json) => _$ShopItemDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  int priceCoins;
@override final  String effectCode;
@override final  bool available;
@override@JsonKey() final  int maxStock;
@override@JsonKey() final  bool risky;

/// Create a copy of ShopItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopItemDtoCopyWith<_ShopItemDto> get copyWith => __$ShopItemDtoCopyWithImpl<_ShopItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceCoins, priceCoins) || other.priceCoins == priceCoins)&&(identical(other.effectCode, effectCode) || other.effectCode == effectCode)&&(identical(other.available, available) || other.available == available)&&(identical(other.maxStock, maxStock) || other.maxStock == maxStock)&&(identical(other.risky, risky) || other.risky == risky));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,priceCoins,effectCode,available,maxStock,risky);
}

@override
String toString() {
    return 'ShopItemDto(id: $id, name: $name, description: $description, priceCoins: $priceCoins, effectCode: $effectCode, available: $available, maxStock: $maxStock, risky: $risky)';
}


}

/// @nodoc
abstract mixin class _$ShopItemDtoCopyWith<$Res> implements $ShopItemDtoCopyWith<$Res> {
  factory _$ShopItemDtoCopyWith(_ShopItemDto value, $Res Function(_ShopItemDto) _then) = __$ShopItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int priceCoins, String effectCode, bool available, int maxStock, bool risky
});




}
/// @nodoc
class __$ShopItemDtoCopyWithImpl<$Res>
    implements _$ShopItemDtoCopyWith<$Res> {
  __$ShopItemDtoCopyWithImpl(this._self, this._then);

  final _ShopItemDto _self;
  final $Res Function(_ShopItemDto) _then;

/// Create a copy of ShopItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? priceCoins = null,Object? effectCode = null,Object? available = null,Object? maxStock = null,Object? risky = null,}) {
  return _then(_ShopItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priceCoins: null == priceCoins ? _self.priceCoins : priceCoins // ignore: cast_nullable_to_non_nullable
as int,effectCode: null == effectCode ? _self.effectCode : effectCode // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,maxStock: null == maxStock ? _self.maxStock : maxStock // ignore: cast_nullable_to_non_nullable
as int,risky: null == risky ? _self.risky : risky // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PurchaseRequestDto {

 String get itemId;
/// Create a copy of PurchaseRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseRequestDtoCopyWith<PurchaseRequestDto> get copyWith => _$PurchaseRequestDtoCopyWithImpl<PurchaseRequestDto>(this as PurchaseRequestDto, _$identity);

  /// Serializes this PurchaseRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRequestDto&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseRequestDto;
  return Object.hash(runtimeType,_this.itemId);
}

@override
String toString() {
  final _this = this as PurchaseRequestDto;
  return 'PurchaseRequestDto(itemId: ${_this.itemId})';
}


}

/// @nodoc
abstract mixin class $PurchaseRequestDtoCopyWith<$Res>  {
  factory $PurchaseRequestDtoCopyWith(PurchaseRequestDto value, $Res Function(PurchaseRequestDto) _then) = _$PurchaseRequestDtoCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class _$PurchaseRequestDtoCopyWithImpl<$Res>
    implements $PurchaseRequestDtoCopyWith<$Res> {
  _$PurchaseRequestDtoCopyWithImpl(this._self, this._then);

  final PurchaseRequestDto _self;
  final $Res Function(PurchaseRequestDto) _then;

/// Create a copy of PurchaseRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,}) {
  return _then(PurchaseRequestDto(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseRequestDto].
extension PurchaseRequestDtoPatterns on PurchaseRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseRequestDto() when $default != null:
return $default(_that.itemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId)  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestDto():
return $default(_that.itemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestDto() when $default != null:
return $default(_that.itemId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseRequestDto implements PurchaseRequestDto {
  const _PurchaseRequestDto({required this.itemId});
  factory _PurchaseRequestDto.fromJson(Map<String, dynamic> json) => _$PurchaseRequestDtoFromJson(json);

@override final  String itemId;

/// Create a copy of PurchaseRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseRequestDtoCopyWith<_PurchaseRequestDto> get copyWith => __$PurchaseRequestDtoCopyWithImpl<_PurchaseRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequestDto&&(identical(other.itemId, itemId) || other.itemId == itemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId);
}

@override
String toString() {
    return 'PurchaseRequestDto(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestDtoCopyWith<$Res> implements $PurchaseRequestDtoCopyWith<$Res> {
  factory _$PurchaseRequestDtoCopyWith(_PurchaseRequestDto value, $Res Function(_PurchaseRequestDto) _then) = __$PurchaseRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$PurchaseRequestDtoCopyWithImpl<$Res>
    implements _$PurchaseRequestDtoCopyWith<$Res> {
  __$PurchaseRequestDtoCopyWithImpl(this._self, this._then);

  final _PurchaseRequestDto _self;
  final $Res Function(_PurchaseRequestDto) _then;

/// Create a copy of PurchaseRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_PurchaseRequestDto(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PurchaseResultDto {

 String get inventoryItemId; String get itemId; int get remainingCoins;
/// Create a copy of PurchaseResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseResultDtoCopyWith<PurchaseResultDto> get copyWith => _$PurchaseResultDtoCopyWithImpl<PurchaseResultDto>(this as PurchaseResultDto, _$identity);

  /// Serializes this PurchaseResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PurchaseResultDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseResultDto&&(identical(other.inventoryItemId, _this.inventoryItemId) || other.inventoryItemId == _this.inventoryItemId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.remainingCoins, _this.remainingCoins) || other.remainingCoins == _this.remainingCoins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PurchaseResultDto;
  return Object.hash(runtimeType,_this.inventoryItemId,_this.itemId,_this.remainingCoins);
}

@override
String toString() {
  final _this = this as PurchaseResultDto;
  return 'PurchaseResultDto(inventoryItemId: ${_this.inventoryItemId}, itemId: ${_this.itemId}, remainingCoins: ${_this.remainingCoins})';
}


}

/// @nodoc
abstract mixin class $PurchaseResultDtoCopyWith<$Res>  {
  factory $PurchaseResultDtoCopyWith(PurchaseResultDto value, $Res Function(PurchaseResultDto) _then) = _$PurchaseResultDtoCopyWithImpl;
@useResult
$Res call({
 String inventoryItemId, String itemId, int remainingCoins
});




}
/// @nodoc
class _$PurchaseResultDtoCopyWithImpl<$Res>
    implements $PurchaseResultDtoCopyWith<$Res> {
  _$PurchaseResultDtoCopyWithImpl(this._self, this._then);

  final PurchaseResultDto _self;
  final $Res Function(PurchaseResultDto) _then;

/// Create a copy of PurchaseResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventoryItemId = null,Object? itemId = null,Object? remainingCoins = null,}) {
  return _then(PurchaseResultDto(
inventoryItemId: null == inventoryItemId ? _self.inventoryItemId : inventoryItemId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,remainingCoins: null == remainingCoins ? _self.remainingCoins : remainingCoins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseResultDto].
extension PurchaseResultDtoPatterns on PurchaseResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseResultDto value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inventoryItemId,  String itemId,  int remainingCoins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseResultDto() when $default != null:
return $default(_that.inventoryItemId,_that.itemId,_that.remainingCoins);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inventoryItemId,  String itemId,  int remainingCoins)  $default,) {final _that = this;
switch (_that) {
case _PurchaseResultDto():
return $default(_that.inventoryItemId,_that.itemId,_that.remainingCoins);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inventoryItemId,  String itemId,  int remainingCoins)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseResultDto() when $default != null:
return $default(_that.inventoryItemId,_that.itemId,_that.remainingCoins);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseResultDto implements PurchaseResultDto {
  const _PurchaseResultDto({required this.inventoryItemId, required this.itemId, required this.remainingCoins});
  factory _PurchaseResultDto.fromJson(Map<String, dynamic> json) => _$PurchaseResultDtoFromJson(json);

@override final  String inventoryItemId;
@override final  String itemId;
@override final  int remainingCoins;

/// Create a copy of PurchaseResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseResultDtoCopyWith<_PurchaseResultDto> get copyWith => __$PurchaseResultDtoCopyWithImpl<_PurchaseResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseResultDto&&(identical(other.inventoryItemId, inventoryItemId) || other.inventoryItemId == inventoryItemId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.remainingCoins, remainingCoins) || other.remainingCoins == remainingCoins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,inventoryItemId,itemId,remainingCoins);
}

@override
String toString() {
    return 'PurchaseResultDto(inventoryItemId: $inventoryItemId, itemId: $itemId, remainingCoins: $remainingCoins)';
}


}

/// @nodoc
abstract mixin class _$PurchaseResultDtoCopyWith<$Res> implements $PurchaseResultDtoCopyWith<$Res> {
  factory _$PurchaseResultDtoCopyWith(_PurchaseResultDto value, $Res Function(_PurchaseResultDto) _then) = __$PurchaseResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String inventoryItemId, String itemId, int remainingCoins
});




}
/// @nodoc
class __$PurchaseResultDtoCopyWithImpl<$Res>
    implements _$PurchaseResultDtoCopyWith<$Res> {
  __$PurchaseResultDtoCopyWithImpl(this._self, this._then);

  final _PurchaseResultDto _self;
  final $Res Function(_PurchaseResultDto) _then;

/// Create a copy of PurchaseResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventoryItemId = null,Object? itemId = null,Object? remainingCoins = null,}) {
  return _then(_PurchaseResultDto(
inventoryItemId: null == inventoryItemId ? _self.inventoryItemId : inventoryItemId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,remainingCoins: null == remainingCoins ? _self.remainingCoins : remainingCoins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InventoryItemDto {

 String get id; String get itemId; String get name; String get description; int get quantity; bool get equipped;
/// Create a copy of InventoryItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemDtoCopyWith<InventoryItemDto> get copyWith => _$InventoryItemDtoCopyWithImpl<InventoryItemDto>(this as InventoryItemDto, _$identity);

  /// Serializes this InventoryItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InventoryItemDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItemDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.equipped, _this.equipped) || other.equipped == _this.equipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InventoryItemDto;
  return Object.hash(runtimeType,_this.id,_this.itemId,_this.name,_this.description,_this.quantity,_this.equipped);
}

@override
String toString() {
  final _this = this as InventoryItemDto;
  return 'InventoryItemDto(id: ${_this.id}, itemId: ${_this.itemId}, name: ${_this.name}, description: ${_this.description}, quantity: ${_this.quantity}, equipped: ${_this.equipped})';
}


}

/// @nodoc
abstract mixin class $InventoryItemDtoCopyWith<$Res>  {
  factory $InventoryItemDtoCopyWith(InventoryItemDto value, $Res Function(InventoryItemDto) _then) = _$InventoryItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String itemId, String name, String description, int quantity, bool equipped
});




}
/// @nodoc
class _$InventoryItemDtoCopyWithImpl<$Res>
    implements $InventoryItemDtoCopyWith<$Res> {
  _$InventoryItemDtoCopyWithImpl(this._self, this._then);

  final InventoryItemDto _self;
  final $Res Function(InventoryItemDto) _then;

/// Create a copy of InventoryItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? name = null,Object? description = null,Object? quantity = null,Object? equipped = null,}) {
  return _then(InventoryItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItemDto].
extension InventoryItemDtoPatterns on InventoryItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItemDto value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemId,  String name,  String description,  int quantity,  bool equipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.name,_that.description,_that.quantity,_that.equipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemId,  String name,  String description,  int quantity,  bool equipped)  $default,) {final _that = this;
switch (_that) {
case _InventoryItemDto():
return $default(_that.id,_that.itemId,_that.name,_that.description,_that.quantity,_that.equipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemId,  String name,  String description,  int quantity,  bool equipped)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.name,_that.description,_that.quantity,_that.equipped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryItemDto implements InventoryItemDto {
  const _InventoryItemDto({required this.id, required this.itemId, required this.name, required this.description, required this.quantity, required this.equipped});
  factory _InventoryItemDto.fromJson(Map<String, dynamic> json) => _$InventoryItemDtoFromJson(json);

@override final  String id;
@override final  String itemId;
@override final  String name;
@override final  String description;
@override final  int quantity;
@override final  bool equipped;

/// Create a copy of InventoryItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemDtoCopyWith<_InventoryItemDto> get copyWith => __$InventoryItemDtoCopyWithImpl<_InventoryItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.equipped, equipped) || other.equipped == equipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,itemId,name,description,quantity,equipped);
}

@override
String toString() {
    return 'InventoryItemDto(id: $id, itemId: $itemId, name: $name, description: $description, quantity: $quantity, equipped: $equipped)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemDtoCopyWith<$Res> implements $InventoryItemDtoCopyWith<$Res> {
  factory _$InventoryItemDtoCopyWith(_InventoryItemDto value, $Res Function(_InventoryItemDto) _then) = __$InventoryItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemId, String name, String description, int quantity, bool equipped
});




}
/// @nodoc
class __$InventoryItemDtoCopyWithImpl<$Res>
    implements _$InventoryItemDtoCopyWith<$Res> {
  __$InventoryItemDtoCopyWithImpl(this._self, this._then);

  final _InventoryItemDto _self;
  final $Res Function(_InventoryItemDto) _then;

/// Create a copy of InventoryItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? name = null,Object? description = null,Object? quantity = null,Object? equipped = null,}) {
  return _then(_InventoryItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LedgerEntryDto {

 String get id; String get currency; int get amount; String get reason; String? get refId; DateTime get createdAt;
/// Create a copy of LedgerEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerEntryDtoCopyWith<LedgerEntryDto> get copyWith => _$LedgerEntryDtoCopyWithImpl<LedgerEntryDto>(this as LedgerEntryDto, _$identity);

  /// Serializes this LedgerEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LedgerEntryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerEntryDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.refId, _this.refId) || other.refId == _this.refId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LedgerEntryDto;
  return Object.hash(runtimeType,_this.id,_this.currency,_this.amount,_this.reason,_this.refId,_this.createdAt);
}

@override
String toString() {
  final _this = this as LedgerEntryDto;
  return 'LedgerEntryDto(id: ${_this.id}, currency: ${_this.currency}, amount: ${_this.amount}, reason: ${_this.reason}, refId: ${_this.refId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $LedgerEntryDtoCopyWith<$Res>  {
  factory $LedgerEntryDtoCopyWith(LedgerEntryDto value, $Res Function(LedgerEntryDto) _then) = _$LedgerEntryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String currency, int amount, String reason, String? refId, DateTime createdAt
});




}
/// @nodoc
class _$LedgerEntryDtoCopyWithImpl<$Res>
    implements $LedgerEntryDtoCopyWith<$Res> {
  _$LedgerEntryDtoCopyWithImpl(this._self, this._then);

  final LedgerEntryDto _self;
  final $Res Function(LedgerEntryDto) _then;

/// Create a copy of LedgerEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? currency = null,Object? amount = null,Object? reason = null,Object? refId = freezed,Object? createdAt = null,}) {
  return _then(LedgerEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerEntryDto].
extension LedgerEntryDtoPatterns on LedgerEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _LedgerEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String currency,  int amount,  String reason,  String? refId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerEntryDto() when $default != null:
return $default(_that.id,_that.currency,_that.amount,_that.reason,_that.refId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String currency,  int amount,  String reason,  String? refId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LedgerEntryDto():
return $default(_that.id,_that.currency,_that.amount,_that.reason,_that.refId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String currency,  int amount,  String reason,  String? refId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LedgerEntryDto() when $default != null:
return $default(_that.id,_that.currency,_that.amount,_that.reason,_that.refId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerEntryDto implements LedgerEntryDto {
  const _LedgerEntryDto({required this.id, required this.currency, required this.amount, required this.reason, this.refId, required this.createdAt});
  factory _LedgerEntryDto.fromJson(Map<String, dynamic> json) => _$LedgerEntryDtoFromJson(json);

@override final  String id;
@override final  String currency;
@override final  int amount;
@override final  String reason;
@override final  String? refId;
@override final  DateTime createdAt;

/// Create a copy of LedgerEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerEntryDtoCopyWith<_LedgerEntryDto> get copyWith => __$LedgerEntryDtoCopyWithImpl<_LedgerEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.refId, refId) || other.refId == refId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,currency,amount,reason,refId,createdAt);
}

@override
String toString() {
    return 'LedgerEntryDto(id: $id, currency: $currency, amount: $amount, reason: $reason, refId: $refId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LedgerEntryDtoCopyWith<$Res> implements $LedgerEntryDtoCopyWith<$Res> {
  factory _$LedgerEntryDtoCopyWith(_LedgerEntryDto value, $Res Function(_LedgerEntryDto) _then) = __$LedgerEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String currency, int amount, String reason, String? refId, DateTime createdAt
});




}
/// @nodoc
class __$LedgerEntryDtoCopyWithImpl<$Res>
    implements _$LedgerEntryDtoCopyWith<$Res> {
  __$LedgerEntryDtoCopyWithImpl(this._self, this._then);

  final _LedgerEntryDto _self;
  final $Res Function(_LedgerEntryDto) _then;

/// Create a copy of LedgerEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? currency = null,Object? amount = null,Object? reason = null,Object? refId = freezed,Object? createdAt = null,}) {
  return _then(_LedgerEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$LedgerPageDto {

 List<LedgerEntryDto> get entries; String? get nextCursor;
/// Create a copy of LedgerPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerPageDtoCopyWith<LedgerPageDto> get copyWith => _$LedgerPageDtoCopyWithImpl<LedgerPageDto>(this as LedgerPageDto, _$identity);

  /// Serializes this LedgerPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LedgerPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerPageDto&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LedgerPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.nextCursor);
}

@override
String toString() {
  final _this = this as LedgerPageDto;
  return 'LedgerPageDto(entries: ${_this.entries}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $LedgerPageDtoCopyWith<$Res>  {
  factory $LedgerPageDtoCopyWith(LedgerPageDto value, $Res Function(LedgerPageDto) _then) = _$LedgerPageDtoCopyWithImpl;
@useResult
$Res call({
 List<LedgerEntryDto> entries, String? nextCursor
});




}
/// @nodoc
class _$LedgerPageDtoCopyWithImpl<$Res>
    implements $LedgerPageDtoCopyWith<$Res> {
  _$LedgerPageDtoCopyWithImpl(this._self, this._then);

  final LedgerPageDto _self;
  final $Res Function(LedgerPageDto) _then;

/// Create a copy of LedgerPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? nextCursor = freezed,}) {
  return _then(LedgerPageDto(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LedgerEntryDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerPageDto].
extension LedgerPageDtoPatterns on LedgerPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerPageDto value)  $default,){
final _that = this;
switch (_that) {
case _LedgerPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LedgerEntryDto> entries,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerPageDto() when $default != null:
return $default(_that.entries,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LedgerEntryDto> entries,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _LedgerPageDto():
return $default(_that.entries,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LedgerEntryDto> entries,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _LedgerPageDto() when $default != null:
return $default(_that.entries,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerPageDto implements LedgerPageDto {
  const _LedgerPageDto({required  List<LedgerEntryDto> entries, this.nextCursor}): _entries = entries;
  factory _LedgerPageDto.fromJson(Map<String, dynamic> json) => _$LedgerPageDtoFromJson(json);

 final  List<LedgerEntryDto> _entries;
@override List<LedgerEntryDto> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  String? nextCursor;

/// Create a copy of LedgerPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerPageDtoCopyWith<_LedgerPageDto> get copyWith => __$LedgerPageDtoCopyWithImpl<_LedgerPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerPageDto&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),nextCursor);
}

@override
String toString() {
    return 'LedgerPageDto(entries: $entries, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$LedgerPageDtoCopyWith<$Res> implements $LedgerPageDtoCopyWith<$Res> {
  factory _$LedgerPageDtoCopyWith(_LedgerPageDto value, $Res Function(_LedgerPageDto) _then) = __$LedgerPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<LedgerEntryDto> entries, String? nextCursor
});




}
/// @nodoc
class __$LedgerPageDtoCopyWithImpl<$Res>
    implements _$LedgerPageDtoCopyWith<$Res> {
  __$LedgerPageDtoCopyWithImpl(this._self, this._then);

  final _LedgerPageDto _self;
  final $Res Function(_LedgerPageDto) _then;

/// Create a copy of LedgerPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? nextCursor = freezed,}) {
  return _then(_LedgerPageDto(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LedgerEntryDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StreakDto {

 int get currentDays; int get bestDays; int get freezesRemaining; bool get restShieldActive; DateTime? get lastQualifiedAt;
/// Create a copy of StreakDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakDtoCopyWith<StreakDto> get copyWith => _$StreakDtoCopyWithImpl<StreakDto>(this as StreakDto, _$identity);

  /// Serializes this StreakDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StreakDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakDto&&(identical(other.currentDays, _this.currentDays) || other.currentDays == _this.currentDays)&&(identical(other.bestDays, _this.bestDays) || other.bestDays == _this.bestDays)&&(identical(other.freezesRemaining, _this.freezesRemaining) || other.freezesRemaining == _this.freezesRemaining)&&(identical(other.restShieldActive, _this.restShieldActive) || other.restShieldActive == _this.restShieldActive)&&(identical(other.lastQualifiedAt, _this.lastQualifiedAt) || other.lastQualifiedAt == _this.lastQualifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StreakDto;
  return Object.hash(runtimeType,_this.currentDays,_this.bestDays,_this.freezesRemaining,_this.restShieldActive,_this.lastQualifiedAt);
}

@override
String toString() {
  final _this = this as StreakDto;
  return 'StreakDto(currentDays: ${_this.currentDays}, bestDays: ${_this.bestDays}, freezesRemaining: ${_this.freezesRemaining}, restShieldActive: ${_this.restShieldActive}, lastQualifiedAt: ${_this.lastQualifiedAt})';
}


}

/// @nodoc
abstract mixin class $StreakDtoCopyWith<$Res>  {
  factory $StreakDtoCopyWith(StreakDto value, $Res Function(StreakDto) _then) = _$StreakDtoCopyWithImpl;
@useResult
$Res call({
 int currentDays, int bestDays, int freezesRemaining, bool restShieldActive, DateTime? lastQualifiedAt
});




}
/// @nodoc
class _$StreakDtoCopyWithImpl<$Res>
    implements $StreakDtoCopyWith<$Res> {
  _$StreakDtoCopyWithImpl(this._self, this._then);

  final StreakDto _self;
  final $Res Function(StreakDto) _then;

/// Create a copy of StreakDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDays = null,Object? bestDays = null,Object? freezesRemaining = null,Object? restShieldActive = null,Object? lastQualifiedAt = freezed,}) {
  return _then(StreakDto(
currentDays: null == currentDays ? _self.currentDays : currentDays // ignore: cast_nullable_to_non_nullable
as int,bestDays: null == bestDays ? _self.bestDays : bestDays // ignore: cast_nullable_to_non_nullable
as int,freezesRemaining: null == freezesRemaining ? _self.freezesRemaining : freezesRemaining // ignore: cast_nullable_to_non_nullable
as int,restShieldActive: null == restShieldActive ? _self.restShieldActive : restShieldActive // ignore: cast_nullable_to_non_nullable
as bool,lastQualifiedAt: freezed == lastQualifiedAt ? _self.lastQualifiedAt : lastQualifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakDto].
extension StreakDtoPatterns on StreakDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakDto value)  $default,){
final _that = this;
switch (_that) {
case _StreakDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakDto value)?  $default,){
final _that = this;
switch (_that) {
case _StreakDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentDays,  int bestDays,  int freezesRemaining,  bool restShieldActive,  DateTime? lastQualifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakDto() when $default != null:
return $default(_that.currentDays,_that.bestDays,_that.freezesRemaining,_that.restShieldActive,_that.lastQualifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentDays,  int bestDays,  int freezesRemaining,  bool restShieldActive,  DateTime? lastQualifiedAt)  $default,) {final _that = this;
switch (_that) {
case _StreakDto():
return $default(_that.currentDays,_that.bestDays,_that.freezesRemaining,_that.restShieldActive,_that.lastQualifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentDays,  int bestDays,  int freezesRemaining,  bool restShieldActive,  DateTime? lastQualifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _StreakDto() when $default != null:
return $default(_that.currentDays,_that.bestDays,_that.freezesRemaining,_that.restShieldActive,_that.lastQualifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakDto implements StreakDto {
  const _StreakDto({required this.currentDays, required this.bestDays, required this.freezesRemaining, required this.restShieldActive, this.lastQualifiedAt});
  factory _StreakDto.fromJson(Map<String, dynamic> json) => _$StreakDtoFromJson(json);

@override final  int currentDays;
@override final  int bestDays;
@override final  int freezesRemaining;
@override final  bool restShieldActive;
@override final  DateTime? lastQualifiedAt;

/// Create a copy of StreakDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakDtoCopyWith<_StreakDto> get copyWith => __$StreakDtoCopyWithImpl<_StreakDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakDto&&(identical(other.currentDays, currentDays) || other.currentDays == currentDays)&&(identical(other.bestDays, bestDays) || other.bestDays == bestDays)&&(identical(other.freezesRemaining, freezesRemaining) || other.freezesRemaining == freezesRemaining)&&(identical(other.restShieldActive, restShieldActive) || other.restShieldActive == restShieldActive)&&(identical(other.lastQualifiedAt, lastQualifiedAt) || other.lastQualifiedAt == lastQualifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currentDays,bestDays,freezesRemaining,restShieldActive,lastQualifiedAt);
}

@override
String toString() {
    return 'StreakDto(currentDays: $currentDays, bestDays: $bestDays, freezesRemaining: $freezesRemaining, restShieldActive: $restShieldActive, lastQualifiedAt: $lastQualifiedAt)';
}


}

/// @nodoc
abstract mixin class _$StreakDtoCopyWith<$Res> implements $StreakDtoCopyWith<$Res> {
  factory _$StreakDtoCopyWith(_StreakDto value, $Res Function(_StreakDto) _then) = __$StreakDtoCopyWithImpl;
@override @useResult
$Res call({
 int currentDays, int bestDays, int freezesRemaining, bool restShieldActive, DateTime? lastQualifiedAt
});




}
/// @nodoc
class __$StreakDtoCopyWithImpl<$Res>
    implements _$StreakDtoCopyWith<$Res> {
  __$StreakDtoCopyWithImpl(this._self, this._then);

  final _StreakDto _self;
  final $Res Function(_StreakDto) _then;

/// Create a copy of StreakDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDays = null,Object? bestDays = null,Object? freezesRemaining = null,Object? restShieldActive = null,Object? lastQualifiedAt = freezed,}) {
  return _then(_StreakDto(
currentDays: null == currentDays ? _self.currentDays : currentDays // ignore: cast_nullable_to_non_nullable
as int,bestDays: null == bestDays ? _self.bestDays : bestDays // ignore: cast_nullable_to_non_nullable
as int,freezesRemaining: null == freezesRemaining ? _self.freezesRemaining : freezesRemaining // ignore: cast_nullable_to_non_nullable
as int,restShieldActive: null == restShieldActive ? _self.restShieldActive : restShieldActive // ignore: cast_nullable_to_non_nullable
as bool,lastQualifiedAt: freezed == lastQualifiedAt ? _self.lastQualifiedAt : lastQualifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BadgeDto {

 String get id; String get name; String get description; bool get unlocked; double? get progress; DateTime? get unlockedAt;
/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeDtoCopyWith<BadgeDto> get copyWith => _$BadgeDtoCopyWithImpl<BadgeDto>(this as BadgeDto, _$identity);

  /// Serializes this BadgeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BadgeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.unlocked, _this.unlocked) || other.unlocked == _this.unlocked)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.unlockedAt, _this.unlockedAt) || other.unlockedAt == _this.unlockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BadgeDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.unlocked,_this.progress,_this.unlockedAt);
}

@override
String toString() {
  final _this = this as BadgeDto;
  return 'BadgeDto(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, unlocked: ${_this.unlocked}, progress: ${_this.progress}, unlockedAt: ${_this.unlockedAt})';
}


}

/// @nodoc
abstract mixin class $BadgeDtoCopyWith<$Res>  {
  factory $BadgeDtoCopyWith(BadgeDto value, $Res Function(BadgeDto) _then) = _$BadgeDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, bool unlocked, double? progress, DateTime? unlockedAt
});




}
/// @nodoc
class _$BadgeDtoCopyWithImpl<$Res>
    implements $BadgeDtoCopyWith<$Res> {
  _$BadgeDtoCopyWithImpl(this._self, this._then);

  final BadgeDto _self;
  final $Res Function(BadgeDto) _then;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? unlocked = null,Object? progress = freezed,Object? unlockedAt = freezed,}) {
  return _then(BadgeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,unlockedAt: freezed == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeDto].
extension BadgeDtoPatterns on BadgeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeDto value)  $default,){
final _that = this;
switch (_that) {
case _BadgeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeDto value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  bool unlocked,  double? progress,  DateTime? unlockedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.unlocked,_that.progress,_that.unlockedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  bool unlocked,  double? progress,  DateTime? unlockedAt)  $default,) {final _that = this;
switch (_that) {
case _BadgeDto():
return $default(_that.id,_that.name,_that.description,_that.unlocked,_that.progress,_that.unlockedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  bool unlocked,  double? progress,  DateTime? unlockedAt)?  $default,) {final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.unlocked,_that.progress,_that.unlockedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeDto implements BadgeDto {
  const _BadgeDto({required this.id, required this.name, required this.description, required this.unlocked, this.progress, this.unlockedAt});
  factory _BadgeDto.fromJson(Map<String, dynamic> json) => _$BadgeDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  bool unlocked;
@override final  double? progress;
@override final  DateTime? unlockedAt;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeDtoCopyWith<_BadgeDto> get copyWith => __$BadgeDtoCopyWithImpl<_BadgeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.unlockedAt, unlockedAt) || other.unlockedAt == unlockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,unlocked,progress,unlockedAt);
}

@override
String toString() {
    return 'BadgeDto(id: $id, name: $name, description: $description, unlocked: $unlocked, progress: $progress, unlockedAt: $unlockedAt)';
}


}

/// @nodoc
abstract mixin class _$BadgeDtoCopyWith<$Res> implements $BadgeDtoCopyWith<$Res> {
  factory _$BadgeDtoCopyWith(_BadgeDto value, $Res Function(_BadgeDto) _then) = __$BadgeDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, bool unlocked, double? progress, DateTime? unlockedAt
});




}
/// @nodoc
class __$BadgeDtoCopyWithImpl<$Res>
    implements _$BadgeDtoCopyWith<$Res> {
  __$BadgeDtoCopyWithImpl(this._self, this._then);

  final _BadgeDto _self;
  final $Res Function(_BadgeDto) _then;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? unlocked = null,Object? progress = freezed,Object? unlockedAt = freezed,}) {
  return _then(_BadgeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,unlockedAt: freezed == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StravaConnectRequestDto {

 String get authorizationCode;
/// Create a copy of StravaConnectRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StravaConnectRequestDtoCopyWith<StravaConnectRequestDto> get copyWith => _$StravaConnectRequestDtoCopyWithImpl<StravaConnectRequestDto>(this as StravaConnectRequestDto, _$identity);

  /// Serializes this StravaConnectRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StravaConnectRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StravaConnectRequestDto&&(identical(other.authorizationCode, _this.authorizationCode) || other.authorizationCode == _this.authorizationCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StravaConnectRequestDto;
  return Object.hash(runtimeType,_this.authorizationCode);
}

@override
String toString() {
  final _this = this as StravaConnectRequestDto;
  return 'StravaConnectRequestDto(authorizationCode: ${_this.authorizationCode})';
}


}

/// @nodoc
abstract mixin class $StravaConnectRequestDtoCopyWith<$Res>  {
  factory $StravaConnectRequestDtoCopyWith(StravaConnectRequestDto value, $Res Function(StravaConnectRequestDto) _then) = _$StravaConnectRequestDtoCopyWithImpl;
@useResult
$Res call({
 String authorizationCode
});




}
/// @nodoc
class _$StravaConnectRequestDtoCopyWithImpl<$Res>
    implements $StravaConnectRequestDtoCopyWith<$Res> {
  _$StravaConnectRequestDtoCopyWithImpl(this._self, this._then);

  final StravaConnectRequestDto _self;
  final $Res Function(StravaConnectRequestDto) _then;

/// Create a copy of StravaConnectRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorizationCode = null,}) {
  return _then(StravaConnectRequestDto(
authorizationCode: null == authorizationCode ? _self.authorizationCode : authorizationCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StravaConnectRequestDto].
extension StravaConnectRequestDtoPatterns on StravaConnectRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StravaConnectRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StravaConnectRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StravaConnectRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _StravaConnectRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StravaConnectRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _StravaConnectRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authorizationCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StravaConnectRequestDto() when $default != null:
return $default(_that.authorizationCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authorizationCode)  $default,) {final _that = this;
switch (_that) {
case _StravaConnectRequestDto():
return $default(_that.authorizationCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authorizationCode)?  $default,) {final _that = this;
switch (_that) {
case _StravaConnectRequestDto() when $default != null:
return $default(_that.authorizationCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StravaConnectRequestDto implements StravaConnectRequestDto {
  const _StravaConnectRequestDto({required this.authorizationCode});
  factory _StravaConnectRequestDto.fromJson(Map<String, dynamic> json) => _$StravaConnectRequestDtoFromJson(json);

@override final  String authorizationCode;

/// Create a copy of StravaConnectRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StravaConnectRequestDtoCopyWith<_StravaConnectRequestDto> get copyWith => __$StravaConnectRequestDtoCopyWithImpl<_StravaConnectRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StravaConnectRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StravaConnectRequestDto&&(identical(other.authorizationCode, authorizationCode) || other.authorizationCode == authorizationCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,authorizationCode);
}

@override
String toString() {
    return 'StravaConnectRequestDto(authorizationCode: $authorizationCode)';
}


}

/// @nodoc
abstract mixin class _$StravaConnectRequestDtoCopyWith<$Res> implements $StravaConnectRequestDtoCopyWith<$Res> {
  factory _$StravaConnectRequestDtoCopyWith(_StravaConnectRequestDto value, $Res Function(_StravaConnectRequestDto) _then) = __$StravaConnectRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String authorizationCode
});




}
/// @nodoc
class __$StravaConnectRequestDtoCopyWithImpl<$Res>
    implements _$StravaConnectRequestDtoCopyWith<$Res> {
  __$StravaConnectRequestDtoCopyWithImpl(this._self, this._then);

  final _StravaConnectRequestDto _self;
  final $Res Function(_StravaConnectRequestDto) _then;

/// Create a copy of StravaConnectRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorizationCode = null,}) {
  return _then(_StravaConnectRequestDto(
authorizationCode: null == authorizationCode ? _self.authorizationCode : authorizationCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StravaConnectResponseDto {

 bool get connected; String? get athleteName;
/// Create a copy of StravaConnectResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StravaConnectResponseDtoCopyWith<StravaConnectResponseDto> get copyWith => _$StravaConnectResponseDtoCopyWithImpl<StravaConnectResponseDto>(this as StravaConnectResponseDto, _$identity);

  /// Serializes this StravaConnectResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StravaConnectResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StravaConnectResponseDto&&(identical(other.connected, _this.connected) || other.connected == _this.connected)&&(identical(other.athleteName, _this.athleteName) || other.athleteName == _this.athleteName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StravaConnectResponseDto;
  return Object.hash(runtimeType,_this.connected,_this.athleteName);
}

@override
String toString() {
  final _this = this as StravaConnectResponseDto;
  return 'StravaConnectResponseDto(connected: ${_this.connected}, athleteName: ${_this.athleteName})';
}


}

/// @nodoc
abstract mixin class $StravaConnectResponseDtoCopyWith<$Res>  {
  factory $StravaConnectResponseDtoCopyWith(StravaConnectResponseDto value, $Res Function(StravaConnectResponseDto) _then) = _$StravaConnectResponseDtoCopyWithImpl;
@useResult
$Res call({
 bool connected, String? athleteName
});




}
/// @nodoc
class _$StravaConnectResponseDtoCopyWithImpl<$Res>
    implements $StravaConnectResponseDtoCopyWith<$Res> {
  _$StravaConnectResponseDtoCopyWithImpl(this._self, this._then);

  final StravaConnectResponseDto _self;
  final $Res Function(StravaConnectResponseDto) _then;

/// Create a copy of StravaConnectResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connected = null,Object? athleteName = freezed,}) {
  return _then(StravaConnectResponseDto(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,athleteName: freezed == athleteName ? _self.athleteName : athleteName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StravaConnectResponseDto].
extension StravaConnectResponseDtoPatterns on StravaConnectResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StravaConnectResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StravaConnectResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StravaConnectResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _StravaConnectResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StravaConnectResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _StravaConnectResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool connected,  String? athleteName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StravaConnectResponseDto() when $default != null:
return $default(_that.connected,_that.athleteName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool connected,  String? athleteName)  $default,) {final _that = this;
switch (_that) {
case _StravaConnectResponseDto():
return $default(_that.connected,_that.athleteName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool connected,  String? athleteName)?  $default,) {final _that = this;
switch (_that) {
case _StravaConnectResponseDto() when $default != null:
return $default(_that.connected,_that.athleteName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StravaConnectResponseDto implements StravaConnectResponseDto {
  const _StravaConnectResponseDto({required this.connected, this.athleteName});
  factory _StravaConnectResponseDto.fromJson(Map<String, dynamic> json) => _$StravaConnectResponseDtoFromJson(json);

@override final  bool connected;
@override final  String? athleteName;

/// Create a copy of StravaConnectResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StravaConnectResponseDtoCopyWith<_StravaConnectResponseDto> get copyWith => __$StravaConnectResponseDtoCopyWithImpl<_StravaConnectResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StravaConnectResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StravaConnectResponseDto&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.athleteName, athleteName) || other.athleteName == athleteName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,connected,athleteName);
}

@override
String toString() {
    return 'StravaConnectResponseDto(connected: $connected, athleteName: $athleteName)';
}


}

/// @nodoc
abstract mixin class _$StravaConnectResponseDtoCopyWith<$Res> implements $StravaConnectResponseDtoCopyWith<$Res> {
  factory _$StravaConnectResponseDtoCopyWith(_StravaConnectResponseDto value, $Res Function(_StravaConnectResponseDto) _then) = __$StravaConnectResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 bool connected, String? athleteName
});




}
/// @nodoc
class __$StravaConnectResponseDtoCopyWithImpl<$Res>
    implements _$StravaConnectResponseDtoCopyWith<$Res> {
  __$StravaConnectResponseDtoCopyWithImpl(this._self, this._then);

  final _StravaConnectResponseDto _self;
  final $Res Function(_StravaConnectResponseDto) _then;

/// Create a copy of StravaConnectResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connected = null,Object? athleteName = freezed,}) {
  return _then(_StravaConnectResponseDto(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,athleteName: freezed == athleteName ? _self.athleteName : athleteName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RunHistoryPageDto {

 List<RunDto> get runs; String? get nextCursor;
/// Create a copy of RunHistoryPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunHistoryPageDtoCopyWith<RunHistoryPageDto> get copyWith => _$RunHistoryPageDtoCopyWithImpl<RunHistoryPageDto>(this as RunHistoryPageDto, _$identity);

  /// Serializes this RunHistoryPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RunHistoryPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunHistoryPageDto&&const DeepCollectionEquality().equals(other.runs, _this.runs)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RunHistoryPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.runs),_this.nextCursor);
}

@override
String toString() {
  final _this = this as RunHistoryPageDto;
  return 'RunHistoryPageDto(runs: ${_this.runs}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $RunHistoryPageDtoCopyWith<$Res>  {
  factory $RunHistoryPageDtoCopyWith(RunHistoryPageDto value, $Res Function(RunHistoryPageDto) _then) = _$RunHistoryPageDtoCopyWithImpl;
@useResult
$Res call({
 List<RunDto> runs, String? nextCursor
});




}
/// @nodoc
class _$RunHistoryPageDtoCopyWithImpl<$Res>
    implements $RunHistoryPageDtoCopyWith<$Res> {
  _$RunHistoryPageDtoCopyWithImpl(this._self, this._then);

  final RunHistoryPageDto _self;
  final $Res Function(RunHistoryPageDto) _then;

/// Create a copy of RunHistoryPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runs = null,Object? nextCursor = freezed,}) {
  return _then(RunHistoryPageDto(
runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as List<RunDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RunHistoryPageDto].
extension RunHistoryPageDtoPatterns on RunHistoryPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunHistoryPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunHistoryPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunHistoryPageDto value)  $default,){
final _that = this;
switch (_that) {
case _RunHistoryPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunHistoryPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunHistoryPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RunDto> runs,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunHistoryPageDto() when $default != null:
return $default(_that.runs,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RunDto> runs,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _RunHistoryPageDto():
return $default(_that.runs,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RunDto> runs,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _RunHistoryPageDto() when $default != null:
return $default(_that.runs,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunHistoryPageDto implements RunHistoryPageDto {
  const _RunHistoryPageDto({required  List<RunDto> runs, this.nextCursor}): _runs = runs;
  factory _RunHistoryPageDto.fromJson(Map<String, dynamic> json) => _$RunHistoryPageDtoFromJson(json);

 final  List<RunDto> _runs;
@override List<RunDto> get runs {
  if (_runs is EqualUnmodifiableListView) return _runs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_runs);
}

@override final  String? nextCursor;

/// Create a copy of RunHistoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunHistoryPageDtoCopyWith<_RunHistoryPageDto> get copyWith => __$RunHistoryPageDtoCopyWithImpl<_RunHistoryPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunHistoryPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunHistoryPageDto&&const DeepCollectionEquality().equals(other.runs, _runs)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_runs),nextCursor);
}

@override
String toString() {
    return 'RunHistoryPageDto(runs: $runs, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$RunHistoryPageDtoCopyWith<$Res> implements $RunHistoryPageDtoCopyWith<$Res> {
  factory _$RunHistoryPageDtoCopyWith(_RunHistoryPageDto value, $Res Function(_RunHistoryPageDto) _then) = __$RunHistoryPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RunDto> runs, String? nextCursor
});




}
/// @nodoc
class __$RunHistoryPageDtoCopyWithImpl<$Res>
    implements _$RunHistoryPageDtoCopyWith<$Res> {
  __$RunHistoryPageDtoCopyWithImpl(this._self, this._then);

  final _RunHistoryPageDto _self;
  final $Res Function(_RunHistoryPageDto) _then;

/// Create a copy of RunHistoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runs = null,Object? nextCursor = freezed,}) {
  return _then(_RunHistoryPageDto(
runs: null == runs ? _self._runs : runs // ignore: cast_nullable_to_non_nullable
as List<RunDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RunDetailDto {

 RunDto get run; List<RunPointDto> get trace;
/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunDetailDtoCopyWith<RunDetailDto> get copyWith => _$RunDetailDtoCopyWithImpl<RunDetailDto>(this as RunDetailDto, _$identity);

  /// Serializes this RunDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RunDetailDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunDetailDto&&(identical(other.run, _this.run) || other.run == _this.run)&&const DeepCollectionEquality().equals(other.trace, _this.trace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RunDetailDto;
  return Object.hash(runtimeType,_this.run,const DeepCollectionEquality().hash(_this.trace));
}

@override
String toString() {
  final _this = this as RunDetailDto;
  return 'RunDetailDto(run: ${_this.run}, trace: ${_this.trace})';
}


}

/// @nodoc
abstract mixin class $RunDetailDtoCopyWith<$Res>  {
  factory $RunDetailDtoCopyWith(RunDetailDto value, $Res Function(RunDetailDto) _then) = _$RunDetailDtoCopyWithImpl;
@useResult
$Res call({
 RunDto run, List<RunPointDto> trace
});


$RunDtoCopyWith<$Res> get run;

}
/// @nodoc
class _$RunDetailDtoCopyWithImpl<$Res>
    implements $RunDetailDtoCopyWith<$Res> {
  _$RunDetailDtoCopyWithImpl(this._self, this._then);

  final RunDetailDto _self;
  final $Res Function(RunDetailDto) _then;

/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? run = null,Object? trace = null,}) {
  return _then(RunDetailDto(
run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,trace: null == trace ? _self.trace : trace // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,
  ));
}
/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}


/// Adds pattern-matching-related methods to [RunDetailDto].
extension RunDetailDtoPatterns on RunDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _RunDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RunDto run,  List<RunPointDto> trace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunDetailDto() when $default != null:
return $default(_that.run,_that.trace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RunDto run,  List<RunPointDto> trace)  $default,) {final _that = this;
switch (_that) {
case _RunDetailDto():
return $default(_that.run,_that.trace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RunDto run,  List<RunPointDto> trace)?  $default,) {final _that = this;
switch (_that) {
case _RunDetailDto() when $default != null:
return $default(_that.run,_that.trace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunDetailDto implements RunDetailDto {
  const _RunDetailDto({required this.run, required  List<RunPointDto> trace}): _trace = trace;
  factory _RunDetailDto.fromJson(Map<String, dynamic> json) => _$RunDetailDtoFromJson(json);

@override final  RunDto run;
 final  List<RunPointDto> _trace;
@override List<RunPointDto> get trace {
  if (_trace is EqualUnmodifiableListView) return _trace;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trace);
}


/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunDetailDtoCopyWith<_RunDetailDto> get copyWith => __$RunDetailDtoCopyWithImpl<_RunDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunDetailDto&&(identical(other.run, run) || other.run == run)&&const DeepCollectionEquality().equals(other.trace, _trace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,run,const DeepCollectionEquality().hash(_trace));
}

@override
String toString() {
    return 'RunDetailDto(run: $run, trace: $trace)';
}


}

/// @nodoc
abstract mixin class _$RunDetailDtoCopyWith<$Res> implements $RunDetailDtoCopyWith<$Res> {
  factory _$RunDetailDtoCopyWith(_RunDetailDto value, $Res Function(_RunDetailDto) _then) = __$RunDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 RunDto run, List<RunPointDto> trace
});


@override $RunDtoCopyWith<$Res> get run;

}
/// @nodoc
class __$RunDetailDtoCopyWithImpl<$Res>
    implements _$RunDetailDtoCopyWith<$Res> {
  __$RunDetailDtoCopyWithImpl(this._self, this._then);

  final _RunDetailDto _self;
  final $Res Function(_RunDetailDto) _then;

/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? run = null,Object? trace = null,}) {
  return _then(_RunDetailDto(
run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,trace: null == trace ? _self._trace : trace // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,
  ));
}

/// Create a copy of RunDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}

// dart format on
