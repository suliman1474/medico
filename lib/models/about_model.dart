import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'about_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class AboutModel {
  @HiveField(0)
  String image;
  @HiveField(1)
  String description;
  @HiveField(2)
  String whatsapp;
  @HiveField(3)
  String insta;
  @HiveField(4)
  String gmail;
  @HiveField(5)
  String ownername;

  AboutModel({
    required this.image,
    required this.description,
    required this.whatsapp,
    required this.insta,
    required this.gmail,
    required this.ownername,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) =>
      _$AboutModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutModelToJson(this);
}
