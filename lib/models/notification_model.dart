import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class NotificationModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  String timestamp;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
