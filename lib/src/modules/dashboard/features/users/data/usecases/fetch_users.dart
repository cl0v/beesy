import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/dashboard/features/users/data/datasource.dart';
import 'package:dio/dio.dart';

class FetchUsersUsecase {
  static Future<List<UserModel>> call() async {
    final (result, error) = await UserListDatasource(Dio()).fetchUsers();
    if(error != null) {
      throw Exception(error);
    } else if(result == null) {
      throw Exception("Erro ao buscar os usuários");
    } else {
      return result;
    }
  }
}