import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/ui/login_page.dart';
import 'package:app/src/modules/auth/ui/profile_page.dart';
import 'package:app/src/modules/home/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum LogoutFrom {
  home,
  profile,
}

class AuthBot {
  Future<void> login(tester, UserRole role) async {
    String email = 'user@example.com';
    String password = 'password123';
    if (role == UserRole.admin) {
      email = 'admin@example.com';
    }

    final emailField = find.byKey(const ValueKey('emailField'));
    final passwordField = find.byKey(const ValueKey('passwordField'));
    final loginBtn = find.byKey(const ValueKey('loginBtn'));

    expect(loginBtn, findsOneWidget);
    expect(find.byType(HomePage), findsNothing);

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();
    final home = find.text('Home');
    expect(find.byKey(const ValueKey('loginBtn')), findsNothing);
    expect(home, findsOneWidget);
    debugPrint('Login successful');
  }

  Future<void> logout(tester, LogoutFrom from) async {
    switch (from) {
      case LogoutFrom.home:
        await navigateToProfilePage(tester);
      case LogoutFrom.profile:
        break;
      default:
        break;
    }
    expect(find.byType(UserProfilePage), findsOneWidget);
    final logoutBtn = find.text('Sair');
    await tester.tap(logoutBtn);
    await tester.pumpAndSettle();
    final confirmBtn = find.text('Confirmar');
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    debugPrint('Logout successful');
  }

  Future<void> navigateToProfilePage(tester) async {
    expect(find.text('Home'), findsOneWidget);
    final profileBtn = find.byIcon(Icons.person);
    await tester.tap(profileBtn);
    await tester.pumpAndSettle();
    expect(find.byType(UserProfilePage), findsOneWidget);
    debugPrint('Accessed User Profile Successful');
  }
}
