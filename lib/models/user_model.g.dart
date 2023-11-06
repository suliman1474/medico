// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String,
      photo: json['photo'] as String?,
      level: json['level'] as String?,
      wallet: json['wallet'] as String?,
      user_type: json['user_type'] as String?,
      is_verified: json['is_verified'] as String?,
      hash_code: json['hash_code'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'photo': instance.photo,
      'level': instance.level,
      'wallet': instance.wallet,
      'user_type': instance.user_type,
      'is_verified': instance.is_verified,
      'hash_code': instance.hash_code,
    };
