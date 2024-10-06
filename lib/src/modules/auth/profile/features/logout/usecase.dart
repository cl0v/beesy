import 'package:app/getit.dart';
import 'package:app/src/fcm.dart';
import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/user.dart';

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
