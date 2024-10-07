// Integration tests main file for the app
// To run the tests, run the following command:
// $ flutter test integration_test/app_test.dart
// My favorite approach is to use BOTS to simplify and speed up the tests

import 'package:app/app.dart';
import 'package:app/firebase_options.dart';
import 'package:app/src/core/services/getit.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/ui/login_page.dart';
import 'package:app/src/modules/auth/ui/profile_page.dart';
import 'package:app/src/modules/home/ui/home_page.dart';
import 'package:app/src/modules/notifications/ui/list_notifications_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/bots/auth_bot.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.test");

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    );
  });
  group(' Flow: Login -> Check -> Logout', () {
    testWidgets('Login and Logout', (tester) async {
      await tester.pumpWidget(BeesyApp());

      final AuthBot bot = AuthBot();
      await bot.login(tester, UserRole.user);

      final profileBtn = find.byIcon(Icons.person);
      await tester.tap(profileBtn);
      await tester.pumpAndSettle();
      expect(find.byType(UserProfilePage), findsOneWidget);
      debugPrint('Accessed User Profile Successful');

      await bot.logout(tester, LogoutFrom.profile);
    });

    testWidgets('Verify Dashboard is only visible for Admins', (tester) async {
      await tester.pumpWidget(BeesyApp());

      final AuthBot bot = AuthBot();

      await bot.login(tester, UserRole.user);
      expect(find.byKey(const ValueKey('dashboardButton')), findsNothing);
      await bot.logout(tester, LogoutFrom.home);

      await bot.login(tester, UserRole.admin);
      expect(find.byKey(const ValueKey('dashboardButton')), findsOneWidget);
      await bot.logout(tester, LogoutFrom.home);
    });

    testWidgets('Check Notifications', (tester) async {
      await tester.pumpWidget(BeesyApp());
      final AuthBot bot = AuthBot();

      expect(find.byIcon(Icons.notifications), findsNothing);
      await bot.login(tester, UserRole.user);


      final notificationsBtn = find.byIcon(Icons.notifications);
      expect(notificationsBtn, findsOneWidget);

      await tester.tap(notificationsBtn);
      await tester.pumpAndSettle();
      expect(find.byType(NotificationsPage), findsOneWidget);
      debugPrint('Accessed Notifications Successful');
      final backBtn = find.byType(BackButton);
      await tester.tap(backBtn);
      await tester.pumpAndSettle();

      await bot.logout(tester, LogoutFrom.home);
    });
  });
}
