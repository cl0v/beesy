import 'package:app/src/core/services/fcm.dart';
import 'package:app/src/modules/auth/data/datasources/auth_datasource.dart';
import 'package:app/src/modules/auth/data/utils/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginUsecase {
  static Future<String?> call(
    String email,
    String password,
  ) async {
    final client = Dio();

    final (model, error) = await AuthDatasource(client).login(
      email,
      password,
    );

    if (model != null) {
      UserAuthUtils utils = UserAuthUtils(
        await SharedPreferences.getInstance(),
      );

      await utils.saveUser(model);

      subscribeToTopic(model.id).catchError((_) {
        // Não funciona em emulador iOS
        debugPrint('Log Error');
      });
    }
    return error;
  }
}
