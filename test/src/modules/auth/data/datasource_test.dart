import 'dart:convert';
import 'package:app/src/common/http/base_url.dart';
import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/data/models/user_registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'datasource_test.mocks.dart';

@GenerateMocks([Dio])
Future<void> main() async {
  const email = "user@example.com";
  const password = "password123";
  final client = MockDio();
  final datasource = AuthDatasource(client);
  group('SignUp', () {
    test('Successful registration', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/register',
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      )).thenAnswer(
        (_) async => Response(
          data: signUpJsonExample,
          statusCode: 201,
          requestOptions: RequestOptions(),
        ),
      );

      //Act
      final response = await datasource.register(
        email,
        password,
      );

      //Assert
      expect(response, (
        201,
        UserRegistrationModel.fromJson(signUpJsonExample),
      ));
    });
    test('Failed registration', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/register',
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      //Act
      final response = await datasource.register(
        email,
        password,
      );

      //Assert
      expect(
        response,
        (400, null),
      );
    });
  });
  group('LogIn', () {
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
      final user = UserModel.fromJson(userJsonExample);
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
}

const signUpJsonExample = {
  "message": "User registered successfully",
  "userId": "unique_user_id"
};


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
