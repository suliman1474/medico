// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_generate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizGenerate _$QuizGenerateFromJson(Map<String, dynamic> json) => QuizGenerate(
      id: json['id'] as String,
      quiz_title: json['quiz_title'] as String,
      quiz_categories: json['quiz_categories'] as String,
      image: json['image'] as String,
      difficulty_level: json['difficulty_level'] as String,
      isDeleted: json['isDeleted'] as String,
    );

Map<String, dynamic> _$QuizGenerateToJson(QuizGenerate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_title': instance.quiz_title,
      'quiz_categories': instance.quiz_categories,
      'image': instance.image,
      'difficulty_level': instance.difficulty_level,
      'isDeleted': instance.isDeleted,
    };
