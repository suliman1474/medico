import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'option_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class OptionModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  List<String>? voterId;

  OptionModel({
    required this.id,
    required this.title,
    this.voterId,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}
