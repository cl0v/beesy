import 'dart:convert';

import 'package:app/src/common/http/baseUrl.dart';
import 'package:app/src/modules/auth/login/data/datasource.dart';
import 'package:app/src/modules/auth/login/data/model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../register/data/datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  const email = "user@example.com";
  const password = "password123";
  final client = MockDio();
  final datasource = UserLoginDataSource(client);

  group('User login', () {
    test('Successful login', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/login',
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      )).thenAnswer(
        (_) async => Response(
          data: userJsonExample,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      //Act
      final response = await datasource.login(
        email,
        password,
      );

      //Assert
      final user = UserLoginModel.fromJson(userJsonExample);
      expect(
        response,
        (200, user),
      );
      expect(user.role, UserRole.user);
    });

    test('Failed login', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/login',
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      //Act
      final response = await datasource.login(
        email,
        password,
      );

      //Assert
      expect(
        response,
        (401, null),
      );
    });
  });
  group('Admin login', () {
    test('Success admin login', () {});
  });
}

final userJsonExample = {
  "token": "jwt_token",
  "userId": "unique_user_id",
  "role": "user"
};

final adminJsonExample = {
  "token": "jwt_token",
  "userId": "unique_admin_id",
  "role": "admin"
};
