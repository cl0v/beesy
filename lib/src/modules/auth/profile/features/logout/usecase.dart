import 'package:app/getit.dart';
import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/user.dart';

class UserLogoutUsecase {
  static Future<bool> call() async {
    await AuthDatasource(Dio()).logout();

    final utils = UserAuthUtils(
      getIt.get<SharedPreferences>()
    );
    await utils.logout();
    
    return true;
  }
}