import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String? image;
  @HiveField(4)
  String college;
  @HiveField(5)
  String discipline;
  @HiveField(6)
  String semester;
  @HiveField(7)
  String contact;
  @HiveField(8)
  String role;
  @HiveField(9)
  String? token;
  @HiveField(10)
  bool blocked;

  UserModel({
    required this.id,
    required this.name,
    required this.college,
    required this.contact,
    required this.discipline,
    required this.email,
    this.image = '',
    this.role = 'user',
    required this.semester,
    this.token,
    this.blocked = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
