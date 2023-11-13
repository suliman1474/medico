// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) => QuizModel(
      id: json['id'] as String,
      quiz_title: json['quiz_title'] as String,
      user_id: json['user_id'] as String,
      no_of_questions: json['no_of_questions'] as String?,
      categories: json['categories'] as String?,
      difficulty_level: json['difficulty_level'] as String?,
      creation_date: json['creation_date'] as String,
      max_attempts: json['max_attempts'] as String?,
      questions_generated: json['questions_generated'] as String?,
      quiz_result: json['quiz_result'] as String?,
      passing_percentage: json['passing_percentage'] as String?,
      image: json['image'] as String?,
      isDeleted: json['isDeleted'] as String?,
      quiz_attempt_id: json['quiz_attempt_id'] as String?,
    );

Map<String, dynamic> _$QuizModelToJson(QuizModel instance) => <String, dynamic>{
      'id': instance.id,
      'quiz_title': instance.quiz_title,
      'user_id': instance.user_id,
      'no_of_questions': instance.no_of_questions,
      'categories': instance.categories,
      'difficulty_level': instance.difficulty_level,
      'creation_date': instance.creation_date,
      'max_attempts': instance.max_attempts,
      'questions_generated': instance.questions_generated,
      'quiz_result': instance.quiz_result,
      'passing_percentage': instance.passing_percentage,
      'image': instance.image,
      'isDeleted': instance.isDeleted,
      'quiz_attempt_id': instance.quiz_attempt_id,
    };
