import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class PostModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? description;
  @HiveField(2)
  List<String>? images;
  @HiveField(3)
  String? timestamp;
  @HiveField(4)
  List<String>? like;

  PostModel({
    required this.id,
    this.description,
    this.images,
    this.timestamp,
    this.like,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
