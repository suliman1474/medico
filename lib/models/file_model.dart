import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class FileModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String path;

  @HiveField(3)
  String downloadUrl;

  // Add downloadUrl field

  FileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.downloadUrl,
    // Include downloadUrl in the constructor
  });

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileModelToJson(this);
}
