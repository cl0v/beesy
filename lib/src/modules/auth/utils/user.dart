import 'dart:convert';

import 'package:app/getit.dart';
import 'package:app/src/modules/auth/utils/jwt.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthUtils {
  final _key = 'user';

  SharedPreferences prefs;
  

  UserAuthUtils(this.prefs);

  /// Recupera os dados de login do usuário da memória
  Future<UserModel?> restoreUser() async {
    final user = prefs.getString(_key);
    if (user == null) {
      return null;
    }

    final model = UserModel.fromJson(jsonDecode(user));
    getIt.registerSingleton<UserModel>(model);

    return model;
  }

  /// Remove os dados de login do usuário na memória
  Future<void> logout() async {
    await JwtUtils(const FlutterSecureStorage()).logout();
    await getIt.unregister<UserModel>();
    await prefs.remove(_key);
  }

  /// Salva os dados de login do usuário na memória
  Future<void> saveUser(UserModel model) async {
    await prefs.setString(_key, jsonEncode(model.toJson()));
    getIt.registerSingleton<UserModel>(model);
  }
}
