import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:app/src/modules/auth/utils/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginUsecase {
  static Future<bool> call(
    String email,
    String password,
  ) async {
    final client = Dio();

    final (statusCode, model) = await AuthDatasource(client).login(
      email,
      password,
    );

    if (statusCode == 200 && model != null) {
      UserAuthUtils utils = UserAuthUtils(
        await SharedPreferences.getInstance(),
      );
      
      await utils.saveUser(model);
      return true;
    }
    return false;
  }
}
