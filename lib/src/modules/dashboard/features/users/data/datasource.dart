import 'dart:convert';

import 'package:app/src/modules/auth/utils/jwt.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

import '../../../../../common/http/base_url.dart';
import '../../../../auth/data/models/user.dart';

class UserListDatasource {
  final secure_storage.FlutterSecureStorage secure;
  final Dio client;

  UserListDatasource(
    this.client, {
    this.secure = const secure_storage.FlutterSecureStorage(),
  });

  Future<(List<UserModel>?, String?)> fetchUsers() async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      final result = await client.get(
        '$baseUrl/users',
        options: options,
      );
      List<UserModel>? users = jsonDecode(result.data)
          .map<UserModel>((u) => UserModel.fromJson(u))
          .toList();
      return (users, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }

  Future<(String?, String?)> updateUserRole(
      String userId, UserRole role) async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      final result = await client.patch(
        '$baseUrl/users/$userId/role',
        options: options,
        data: jsonEncode({"role": role.toString().split(".")[1]}),
      );

      return ((jsonDecode(result.data)?['message'] as String?), null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }
}
