import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_registration.g.dart';

@JsonSerializable()
class UserRegistrationModel extends Equatable {
  final String message;
  final String userId;

  const UserRegistrationModel(
    this.message,
    this.userId,
  );

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationModelFromJson(json);

  @override
  List<Object?> get props => [message, userId];
}
