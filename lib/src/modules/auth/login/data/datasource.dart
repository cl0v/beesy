import 'model.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:app/src/common/http/baseUrl.dart';

class UserLoginDataSource {
  final Dio client;
  UserLoginDataSource(this.client);

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
      statusCode = response.statusCode ?? -1;
      model = UserLoginModel.fromJson(response.data);
    } on DioException catch (e) {
      (statusCode, model) = (e.response?.statusCode ?? -1, null);
    }

    return (statusCode, model);
  }
}
