// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_start_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizStartModel _$QuizStartModelFromJson(Map<String, dynamic> json) =>
    QuizStartModel(
      quizzies: (json['quizzies'] as List<dynamic>)
          .map((e) => Quiz.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz_attempt_id: json['quiz_attempt_id'] as int,
    );

Map<String, dynamic> _$QuizStartModelToJson(QuizStartModel instance) =>
    <String, dynamic>{
      'quizzies': instance.quizzies,
      'quiz_attempt_id': instance.quiz_attempt_id,
    };
