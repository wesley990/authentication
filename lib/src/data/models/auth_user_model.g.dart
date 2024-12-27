// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, Object> json) =>
    AuthUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );

Map<String, Object> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, Object>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName ?? '',
      'isEmailVerified': instance.isEmailVerified,
    };
