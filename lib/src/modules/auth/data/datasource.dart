import 'dart:convert';

import 'package:app/src/common/http/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/jwt.dart';
import 'models/user_login.dart';
import 'models/user_registration.dart';

class AuthDatasource {
  final Dio client;

  AuthDatasource(this.client);

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
  Future<(int, UserLoginModel?)> login(
    String email,
    String password,
  ) async {
    int statusCode = -1;
    UserLoginModel? model;

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
      if(statusCode == 200){
        JwtUtils(const FlutterSecureStorage()).saveJWT(response.data['token']);
      }
      statusCode = response.statusCode ?? -1;
      model = UserLoginModel.fromJson(response.data);
    } on DioException catch (e) {
      (statusCode, model) = (e.response?.statusCode ?? -1, null);
    }

    return (statusCode, model);
  }
}
