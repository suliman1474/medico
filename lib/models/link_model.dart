import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'link_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class LinkModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String url;

  // Add downloadUrl field

  LinkModel({
    required this.id,
    required this.name,
    required this.url,
    // Include downloadUrl in the constructor
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) =>
      _$LinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinkModelToJson(this);
}
