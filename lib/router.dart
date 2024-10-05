import 'package:app/getit.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/login/page.dart';
import 'package:app/src/modules/auth/register/page.dart';
import 'package:app/src/modules/dashboard/features/audit_logs/page.dart';
import 'package:app/src/modules/dashboard/page.dart';
import 'package:app/src/pages/home.dart';
import 'package:go_router/go_router.dart';
import 'src/modules/auth/profile/features/change_password/page.dart';
import 'src/modules/auth/profile/page.dart';
import 'src/modules/dashboard/features/notifications/page.dart';
import 'src/modules/dashboard/features/users/page.dart';
import 'src/modules/notifications/page.dart';

final router = GoRouter(
  redirect: (_, state) {
    // Sisteminha arcaico
    if (_needToLoggin(state)) {
      return '/login';
    } else if (_isTryingToAccessAdminPanel(state) && !_userIsAdmin(state)) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const UserProfilePage(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersListPage(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const SendNotificationPage(),
        ),
        GoRoute(
          path: '/logs',
          builder: (context, state) => const AuditLogsPage(),
        ),
      ]
    )
  ],
);

bool _needToLoggin(state) {
  final user = getIt.isRegistered<UserModel>();
  return !user && (state.fullPath != '/login' && state.fullPath != '/register');
}

bool _isTryingToAccessAdminPanel(state) {
  return state.fullPath.contains('/dashboard');
}

bool _userIsAdmin(state) {
  final user = getIt.get<UserModel>();
  return user.role == UserRole.admin;
}
