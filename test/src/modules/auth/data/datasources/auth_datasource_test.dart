import 'dart:convert';
import 'package:app/src/core/http/base_url.dart';
import 'package:app/src/modules/auth/data/datasources/auth_datasource.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/data/models/user_registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<FlutterSecureStorage>()])
Future<void> main() async {
  await dotenv.load(fileName: ".env.test");

  const email = "user@example.com";
  const password = "password123";

  final client = MockDio();
  final secureStorage = MockFlutterSecureStorage();
  final datasource = AuthDatasource(client, secure: secureStorage);
  group('SignUp', () {
    test('Successful registration', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/register',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: jsonEncode(signUpJsonExample),
          statusCode: 201,
          requestOptions: RequestOptions(path: '$baseUrl/auth/register'),
        ),
      );

      //Act
      final response = await datasource.register(
        email,
        password,
      );

      //Assert
      expect(response, (
        UserRegistrationModel.fromJson(signUpJsonExample),
        null,
      ));
    });
    test('Failed registration', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/register',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            data: jsonEncode({"message": "Email already exists"}),
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
        (null, "Email already exists"),
      );
    });
  });
  group('LogIn', () {
    setUpAll(() async {
      when(secureStorage.write(
        key: 'jwt_token',
        value: anyNamed('value'),
      )).thenAnswer((_) async => Future<void>.value());
    });
    test('Successful login', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/login',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: jsonEncode(userJsonExample),
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );
      // when(secureStorage.write(
      //   key: 'jwt_token',
      //   value: anyNamed('value'),
      // )).thenAnswer((_) async => Future<void>.value());

      //Act
      final response = await datasource.login(
        email,
        password,
      );
      final user = UserModel.fromJson(userJsonExample);

      //Assert
      expect(
        response,
        (user, null),
      );
      expect(user.role, UserRole.user);
    });

    test('Failed login', () async {
      //Arrange
      when(client.post(
        '$baseUrl/auth/login',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 401,
            data: jsonEncode({"message": "Invalid email or password"}),
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
        (null, "Invalid email or password"),
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
  "email": "user@example.com",
  "role": "user"
};

final adminJsonExample = {
  "token": "jwt_token",
  "userId": "unique_admin_id",
  "role": "admin"
};
