import 'dart:convert';

import 'package:app/src/modules/auth/utils/jwt.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

import '../../../../common/http/base_url.dart';

class SendNotificationDatasource {
  final secure_storage.FlutterSecureStorage secure;
  final Dio client;

  const SendNotificationDatasource(
    this.client, {
    this.secure = const secure_storage.FlutterSecureStorage(),
  });

  Future<(String?, String?)> sendNotification(
    String title,
    String message,
    List<String> users,
  ) async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );
    try {
      final result = await client.post(
        '$baseUrl/notifications/send',
        options: options,
        data: jsonEncode(
          {
            "title": title,
            "message": message,
            "recipients": users,
          },
        ),
      );

      return (jsonDecode(result.data)?['message'] as String?, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }
}
