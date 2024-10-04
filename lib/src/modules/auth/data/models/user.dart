import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  user,
  admin,
}

@JsonSerializable()
class UserModel extends Equatable {
  final String email;
  final String userId;
  final UserRole role;

  const UserModel( {
    required this.userId,
    required this.role,
    required this.email,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);


  @override
  List<Object?> get props => [
        userId,
        role,
      ];
}
