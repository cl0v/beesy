import 'dart:convert';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/utils/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('User auth save user', () {
    const user = UserModel(
      // token: 'token',
      email: 'user@example.com',
      userId: 'userId',
      role: UserRole.user,
    );
    final prefs = MockSharedPreferences();
    final utils = UserAuthUtils(prefs);

    setUp(() {
      GetIt.I.reset();
      when(prefs.setString('user', jsonEncode(user.toJson()))).thenAnswer(
        (_) async => true,
      );
    });

    test('Success with Save', () async {
      expect(utils.saveUser(user), completes);
    });
    test('Success with not saved', () async {
      when(prefs.setString('user', jsonEncode(user.toJson()))).thenAnswer(
        (_) async => false,
      );
      expect(utils.saveUser(user), completes);
    });

    test('GetIt should retrieve user after saved', () async {
      await utils.saveUser(user);
      expect(GetIt.I.get<UserModel>(), user);
    });
  });
  group('User auth restore User and set globally with GetIt', () {
    const user = UserModel(
      // token: 'token',
      email: 'user@example.com',
      userId: 'userId',
      role: UserRole.user,
    );
    final prefs = MockSharedPreferences();
    final utils = UserAuthUtils(prefs);

    setUp(() async {
      // Reset values to avoid singleton registrations
      await GetIt.I.reset();
      when(prefs.setString('user', jsonEncode(user.toJson()))).thenAnswer(
        (_) async => true,
      );
    });

    test('Success', () async {
      when(prefs.getString('user')).thenAnswer(
        (_) => jsonEncode(user.toJson()),
      );
      expect(await utils.restoreUser(), user);
      expect(GetIt.I.get<UserModel>(), user);
    });

    test('Error', () async {
      when(prefs.getString('user')).thenAnswer(
        (_) => null,
      );
      final u = await utils.restoreUser();
      expect(u, null);
      expect(GetIt.I.isRegistered<UserModel>(), false);
    });
  });

  group('User auth clear user', () {
    const user = UserModel(
      // token: 'token',
      userId: 'userId',
      role: UserRole.user, email: 'user@example.com',
    );
    final prefs = MockSharedPreferences();
    final utils = UserAuthUtils(prefs);
    setUp(() {
      when(prefs.getString('user')).thenAnswer(
        (_) => jsonEncode(user.toJson()),
      );
      GetIt.I.registerSingleton<UserModel>(user);
    });
    test('Successful logout', () async {
      when(prefs.remove('user')).thenAnswer(
        (_) async => true,
      );
      await expectLater(utils.logout(), completes);
      expect(GetIt.I.isRegistered<UserModel>(), false);
    });
    test('Failed to logout', () async {
      when(prefs.remove('user')).thenAnswer(
        (_) async => false,
      );
      await expectLater(utils.logout(), completes);
      expect(GetIt.I.isRegistered<UserModel>(), false);
    });
  });
}
