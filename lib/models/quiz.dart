import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  final String id;
  final String question;
  final String category;
  final String difficulty_level;
  final String isDeleted;
  final List<Option> options;

  Quiz({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty_level,
    required this.isDeleted,
    required this.options,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

@JsonSerializable()
class Option {
  final String id;
  final String question_id;
  final String title;
  final String is_correct;
  final String isDeleted;

  Option({
    required this.id,
    required this.question_id,
    required this.title,
    required this.is_correct,
    required this.isDeleted,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
