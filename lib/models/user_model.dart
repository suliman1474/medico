import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String password;
  final String? photo;
  final String? level;
  final String? wallet;
  final String? user_type;
  final String? is_verified;
  final String? hash_code;

  UserModel({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    required this.password,
    this.photo,
    this.level,
    this.wallet,
    this.user_type,
    this.is_verified,
    this.hash_code,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
