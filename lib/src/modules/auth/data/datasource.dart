import 'dart:convert';

import 'package:app/src/common/http/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secureStorage;

import '../utils/jwt.dart';
import 'models/user.dart';
import 'models/user_registration.dart';

class AuthDatasource {
  final Dio client;
  final secureStorage.FlutterSecureStorage secure;

  AuthDatasource(
    this.client, {
    this.secure = const secureStorage.FlutterSecureStorage(),
  });

  Future<(int, UserRegistrationModel?)> register(
    String email,
    String password,
  ) async {
    int statusCode = -1;
    UserRegistrationModel? model;

    try {
      final response = await client.post(
        '$baseUrl/auth/register',
        data: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      statusCode = response.statusCode ?? -1;
      model = UserRegistrationModel.fromJson(response.data);
    } on DioException catch (e) {
      (statusCode, model) = (e.response?.statusCode ?? -1, null);
    }

    return (statusCode, model);
  }

  /// Retorna o StatusCode e o objeto de retorno do servidor
  Future<(int, UserModel?)> login(
    String email,
    String password,
  ) async {
    int statusCode = -1;
    UserModel? model;

    try {
      final response = await client.post(
        '$baseUrl/auth/login',
        data: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      if (statusCode == 200) {
        JwtUtils(secure).saveJWT(response.data['token']);
      }
      statusCode = response.statusCode ?? -1;
      model = UserModel.fromJson(
        (jsonDecode(response.data) as Map<String, dynamic>)
          ..remove('token')
          ..addAll(
            {'email': email},
          ),
      );
    } on DioException catch (e) {
      (statusCode, model) = (e.response?.statusCode ?? -1, null);
    }

    return (statusCode, model);
  }
  /// Retorna o StatusCode e o objeto de retorno do servidor
  /// 404 para caso o usuário não exista
  /// 200 para caso o usuário exista
  Future<(int statusCode, UserModel? model)> getUser() async {
    int statusCode = -1;
    UserModel? model;

    final token = JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );
    try {
      final response = await client.get(
        '$baseUrl/auth/me',
        options: options,
      );

      statusCode = response.statusCode ?? -1;
      model = UserModel.fromJson(response.data);

    } on DioException catch (e) {
      (statusCode, model) = (e.response?.statusCode ?? -1, null);
    }

    return (statusCode, model);
  }
}
