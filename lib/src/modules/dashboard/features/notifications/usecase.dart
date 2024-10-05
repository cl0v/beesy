import 'package:dio/dio.dart';

import 'datasource.dart';

class SendNotificationUsecase {

  static Future<String> call(String title, String message, List<String> users) async {
    final (result, error) = await SendNotificationDatasource(Dio()).sendNotification(title, message, users);

    if(error != null) {
      throw Exception(error);
    } else if(result == null) {
      throw Exception("Erro ao enviar a notificação");
    } else {
      return result;
    }
  }
}