import 'dart:convert';

import 'package:app/src/modules/auth/utils/jwt.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

import '../../../../common/http/base_url.dart';

class AuditLogsDatasource {
  final Dio client;
  final secure_storage.FlutterSecureStorage secure;

  const AuditLogsDatasource(
    this.client, {
    this.secure = const secure_storage.FlutterSecureStorage(),
  });

  Future<(dynamic, String?)> fetchAuditLogs() async {
    final token = await JwtUtils(secure).getJWT();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      final result = await client.get(
        '$baseUrl/audit/logs',
        options: options,
      );
      return (jsonDecode(result.data), null);
    } on DioException catch (e) {
      return (null, jsonDecode(e.response?.data)['message'] as String?);
    }
  }
}
