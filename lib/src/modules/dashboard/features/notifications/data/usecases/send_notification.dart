import 'package:dio/dio.dart';

import '../../datasource.dart';

class SendNotificationUsecase {
  static Future<(String?, String?)> call(
    String title,
    String message,
    List<String> users,
  ) async =>
      SendNotificationDatasource(Dio()).sendNotification(
        title,
        message,
        users,
      );
}
