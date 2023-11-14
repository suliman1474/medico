import 'package:json_annotation/json_annotation.dart';

part 'quiz_generate.g.dart';

@JsonSerializable()
class QuizGenerate {
  String id;
  String quiz_title;
  String quiz_categories;
  String image;
  String difficulty_level;
  String isDeleted;

  QuizGenerate({
    required this.id,
    required this.quiz_title,
    required this.quiz_categories,
    required this.image,
    required this.difficulty_level,
    required this.isDeleted,
  });
  // Deserialize the 'quiz_categories' field into a List<String>
  List<String> get quizCategoriesList =>
      quiz_categories.split(',').map((category) => category.trim()).toList();
  factory QuizGenerate.fromJson(Map<String, dynamic> json) =>
      _$QuizGenerateFromJson(json);

  Map<String, dynamic> toJson() => _$QuizGenerateToJson(this);
}
