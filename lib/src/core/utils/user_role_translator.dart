import '../../modules/auth/data/models/user.dart';

String translateRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.user:
        return 'Usuário';
      default:
        return '';
    }
  }