import 'package:app/src/core/services/getit.dart';
import 'package:app/src/core/services/fcm.dart';
import 'package:app/src/modules/auth/data/datasources/auth_datasource.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/user.dart';

class UserLogoutUsecase {
  static Future<bool> call() async {
    final userId = getIt.get<UserModel>().id;
    await AuthDatasource(Dio()).logout();

    final utils = UserAuthUtils(getIt.get<SharedPreferences>());
    await utils.logout();

    unsubscribeFromTopic(userId).onError((_, __) {
      debugPrint('Erro ao desconectar do topico');
    });
    
    return true;
  }
}
