// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
      difficulty_level: json['difficulty_level'] as String,
      isDeleted: json['isDeleted'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'category': instance.category,
      'difficulty_level': instance.difficulty_level,
      'isDeleted': instance.isDeleted,
      'options': instance.options,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: json['id'] as String,
      question_id: json['question_id'] as String,
      title: json['title'] as String,
      is_correct: json['is_correct'] as String,
      isDeleted: json['isDeleted'] as String,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'question_id': instance.question_id,
      'title': instance.title,
      'is_correct': instance.is_correct,
      'isDeleted': instance.isDeleted,
    };
