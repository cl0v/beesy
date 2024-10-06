import 'package:app/src/modules/notifications/data/datasources/notifications_datasource.dart';
import 'package:dio/dio.dart';

class SendNotificationUsecase {
  static Future<(String?, String?)> call(
    String title,
    String message,
    List<String> users,
  ) async =>
      NotificationsDatasource(Dio()).sendNotification(
        title,
        message,
        users,
      );
}
