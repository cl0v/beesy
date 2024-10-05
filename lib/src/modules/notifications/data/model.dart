import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';
@JsonSerializable()
class NotificationModel {
  @JsonKey(name: "notificationId")
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
