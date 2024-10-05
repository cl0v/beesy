import 'package:app/src/modules/notifications/data/datasource.dart';
import 'package:dio/dio.dart';

import 'model.dart';

class NotificationsUsecase {
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
