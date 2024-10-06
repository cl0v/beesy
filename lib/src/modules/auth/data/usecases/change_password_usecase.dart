import 'package:app/src/modules/auth/data/datasources/auth_datasource.dart';
import 'package:dio/dio.dart';

class UserChangePasswordUsecase {
  static Future<(String?, String?)> call(
    String oldPwd,
    String newPwd,
  ) =>
      AuthDatasource(Dio()).changePassword(
        oldPwd,
        newPwd,
      );
}
