import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_login.g.dart';


enum UserRole {
  user,
  admin,
}

@JsonSerializable()
class UserLoginModel extends Equatable {
  // final String token;
  final String userId;
  final UserRole role;

  const UserLoginModel({
    // required this.token,
    required this.userId,
    required this.role,
  });


  factory UserLoginModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);


  @override
  // TODO: implement props
  List<Object?> get props => [
        // token,
        userId,
        role,
      ];
}
