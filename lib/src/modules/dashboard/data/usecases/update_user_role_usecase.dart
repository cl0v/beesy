import 'package:app/src/core/services/getit.dart';
import 'package:app/src/modules/dashboard/data/datasources/list_users_datasource.dart';
import 'package:dio/dio.dart';

import '../../../auth/data/models/user.dart';

class UpdateUserRoleUsecase {
  static Future<(String?, String?)> call(UserRole role, String userId) async {
    final user = getIt.get<UserModel>();

    if (user.role != UserRole.admin) {
      return (null, "Você não tem permissão para realizar esta operação");
    }

    return UserListDatasource(Dio()).updateUserRole(userId, role);
  }
}
