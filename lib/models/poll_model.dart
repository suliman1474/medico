import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medico/models/option_model.dart';

part 'poll_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class PollModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String question;
  @HiveField(2)
  List<OptionModel> options;

  PollModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) =>
      _$PollModelFromJson(json);

  Map<String, dynamic> toJson() => _$PollModelToJson(this);
}
