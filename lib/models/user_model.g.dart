// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      college: json['college'] as String,
      contact: json['contact'] as String,
      discipline: json['discipline'] as String,
      email: json['email'] as String,
      image: json['image'] as String?,
      role: json['role'] as String? ?? 'user',
      semester: json['semester'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'college': instance.college,
      'discipline': instance.discipline,
      'semester': instance.semester,
      'contact': instance.contact,
      'role': instance.role,
    };
