import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
class QuizModel {
  String id;
  String quiz_title;
  String user_id;
  String? no_of_questions;
  String? categories;
  String? difficulty_level;
  String creation_date;
  String? max_attempts;
  String? questions_generated;
  String? quiz_result;
  String? passing_percentage;
  String? image;
  String? isDeleted;
  String? quiz_attempt_id;

  QuizModel({
    required this.id,
    required this.quiz_title,
    required this.user_id,
    this.no_of_questions,
    this.categories,
    this.difficulty_level,
    required this.creation_date,
    this.max_attempts,
    this.questions_generated,
    this.quiz_result,
    this.passing_percentage,
    this.image,
    this.isDeleted,
    this.quiz_attempt_id,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizModelToJson(this);
}
