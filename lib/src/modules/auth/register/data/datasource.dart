import 'model.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:app/src/common/http/baseUrl.dart';

class UserRegistrationDataSource {
  final Dio client;
  UserRegistrationDataSource(this.client);

  /// Retorna o StatusCode e o objeto de retorno do servidor
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
}
