import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:app/src/modules/auth/login/usecase.dart';
import 'package:dio/dio.dart';


class RegisterUserUsecase {
  static Future<(bool created, bool loggedIn)> call(
    String email,
    String password,
  ) async {
    final client = Dio();

    final (registrationStatusCode, _) =
        await AuthDatasource(client).register(email, password);

    if (registrationStatusCode == 201) {
      // Apenas por que não gosto de registrar e ter que fazer login logo em seguida
      // resolvi fazer o login logo após o registro ser concluído.
      final login = await UserLoginUsecase.call(email, password);

      return (true, login);
    }

    return (false, false);
  }
}
