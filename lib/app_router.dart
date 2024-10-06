import 'package:app/src/core/services/getit.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/ui/login_page.dart';
import 'package:app/src/modules/auth/ui/register_page.dart';
import 'package:app/src/modules/dashboard/ui/audit_logs_page.dart';
import 'package:app/src/modules/dashboard/ui/dashboard_page.dart';
import 'package:app/src/modules/home/ui/home_page.dart';
import 'package:go_router/go_router.dart';
import 'src/modules/auth/ui/change_password_page.dart';
import 'src/modules/auth/ui/profile_page.dart';
import 'src/modules/notifications/ui/send_notifications_page.dart';
import 'src/modules/dashboard/ui/users_page.dart';
import 'src/modules/notifications/ui/list_notifications_page.dart';

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
