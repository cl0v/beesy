import 'package:app/src/modules/notifications/data/datasources/notifications_datasource.dart';
import 'package:dio/dio.dart';

import '../models/notification_model.dart';

class ListNotificationsUsecase {
  static Future<List<NotificationModel>> call() async {
    final (result, error) = await NotificationsDatasource(Dio()).fetchNotifications();
    if(error != null) {
      throw Exception(error);
    } else if(result == null) {
      throw Exception("Erro ao buscar as notificações");
    } else {
      return result;
    }
  }
}
