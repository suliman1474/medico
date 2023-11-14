import 'package:json_annotation/json_annotation.dart';
import 'package:medico/models/quiz.dart';

part 'quiz_start_model.g.dart';

@JsonSerializable()
class QuizStartModel {
  List<Quiz> quizzies;
  final int quiz_attempt_id;

  QuizStartModel({
    required this.quizzies,
    required this.quiz_attempt_id,
  });

  factory QuizStartModel.fromJson(Map<String, dynamic> json) =>
      _$QuizStartModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizStartModelToJson(this);
}
