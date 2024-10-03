import 'dart:convert';
import 'package:app/src/common/http/baseUrl.dart';
import 'package:app/src/modules/auth/register/data/datasource.dart';
import 'package:app/src/modules/auth/register/data/model.dart';
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
  final datasource = UserRegistrationDataSource(client);
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
        data: jsonExample,
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
      UserRegistrationModel.fromJson(jsonExample),
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
}

const jsonExample = {
  "message": "User registered successfully",
  "userId": "unique_user_id"
};
