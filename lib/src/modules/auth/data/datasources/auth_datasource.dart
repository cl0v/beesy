import 'dart:convert';

import 'package:app/src/core/services/getit.dart';
import 'package:app/src/core/http/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

import '../utils/jwt.dart';
import '../models/user.dart';
import '../models/user_registration.dart';

class AuthDatasource {
  final Dio client;
  final secure_storage.FlutterSecureStorage secure;

  AuthDatasource(
    this.client, {
    this.secure = const secure_storage.FlutterSecureStorage(),
  });

  Future<(UserRegistrationModel?, String?)> register(
    String email,
    String password,
  ) async {
    try {
      final response = await client.post(
        '$baseUrl/auth/register',
        options: Options(
          headers: {
            'content-type': 'multipart/form-data',
          },
        ),
        data: FormData.fromMap(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      final model = UserRegistrationModel.fromJson(jsonDecode(response.data));
      return (model, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }

  /// Retorna o StatusCode e o objeto de retorno do servidor
  Future<(UserModel?, String?)> login(
    String email,
    String password,
  ) async {
    try {
      final response = await client.post(
        '$baseUrl/auth/login',
        options: Options(
          headers: {'content-type': 'multipart/form-data'},
        ),
        data: FormData.fromMap(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      if (response.statusCode == 200) {
        JwtUtils(secure).saveJWT(jsonDecode(response.data)['token']);
      }
      final model = UserModel.fromJson(
        (jsonDecode(response.data) as Map<String, dynamic>)
          ..remove('token')
          ..addAll(
            {'email': email},
          ),
      );
      return (model, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)?['message'] as String?);
    }
  }

  /// Retorna o StatusCode e o objeto de retorno do servidor
  /// 404 para caso o usuário não exista
  /// 200 para caso o usuário exista
  Future<(UserModel?, String?)> getUser() async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      final response = await client.get(
        '$baseUrl/auth/me',
        options: options,
      );

      final model = UserModel.fromJson(jsonDecode(response.data));

      return (model, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }

  Future<(String?, String?)> logout() async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      final result = await client.post(
        '$baseUrl/auth/logout',
        options: options,
      );

      return (jsonDecode(result.data)['message'] as String?, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }

  Future<(String?, String?)> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final userId = getIt.get<UserModel>().id;

    final token = await JwtUtils(secure).getJWT();

    final options = Options(
      contentType: 'multipart/form-data',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      },
    );

    try {
      final result = await client.patch(
        '$baseUrl/users/$userId/password',
        options: options,
        data: FormData.fromMap(
          {
            "oldPassword": oldPassword,
            "newPassword": newPassword,
          },
        ),
      );
      return (jsonDecode(result.data)['message'] as String?, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }
}
