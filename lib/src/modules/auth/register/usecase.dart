import 'package:app/src/modules/auth/data/datasource.dart';
import 'package:app/src/modules/auth/login/usecase.dart';
import 'package:dio/dio.dart';

class RegisterUserUsecase {
  static Future<(String? registrationError, String? logginError)> call(
    String email,
    String password,
  ) async {
    final client = Dio();
    String? loginError;

    final (model, registrationError) = await AuthDatasource(client).register(
      email,
      password,
    );

    if (model != null) {
      // Apenas por que não gosto de registrar e ter que fazer login logo em seguida
      // resolvi fazer o login logo após o registro ser concluído.
      loginError = await UserLoginUsecase.call(
        email,
        password,
      );
    }

    return (registrationError, loginError);
  }
}
