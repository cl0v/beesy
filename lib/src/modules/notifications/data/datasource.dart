import 'dart:convert';

import 'package:app/src/common/http/base_url.dart';

import '../../auth/utils/jwt.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

class NotificationsDatasource {
  final secure_storage.FlutterSecureStorage secure;
  final Dio client;

  NotificationsDatasource(
    this.client, {
    this.secure = const secure_storage.FlutterSecureStorage(),
  });

  Future<(List<NotificationModel>?, String?)> fetchNotifications() async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );
    try {
      final result = await client.get(
        '$baseUrl/notifications',
        options: options,
      );

      List<NotificationModel>? notifications = jsonDecode(result.data)
          .map<NotificationModel>((u) => NotificationModel.fromJson(u))
          .toList();
      return (notifications, null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }
}
