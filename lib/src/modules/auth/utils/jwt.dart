import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtUtils {
  final _key = 'jwt_token';
  final FlutterSecureStorage storage;

  JwtUtils(this.storage);

  Future<void> logout() => storage.delete(key: _key);

  Future<void>  saveJWT(String jwt) async => storage.write(key: _key, value: jwt);

  Future<String?> getJWT() async => storage.read(key: _key);
}
