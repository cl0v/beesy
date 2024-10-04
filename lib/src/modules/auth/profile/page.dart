import 'package:app/getit.dart';
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/auth/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/logout/usecase.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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

  bool isIDVisibile = false;

  @override
  Widget build(BuildContext context) {
    final user = getIt.get<UserModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 52,
              child: Icon(
                Icons.person,
                size: 48,
              ),
            ),

            const SizedBox(height: 20),
            ListTile(
              title: Text(
                  'ID: ${isIDVisibile ? user.userId : "Toque para visualizar"}'),
              onTap: () {
                setState(() {
                  isIDVisibile = !isIDVisibile;
                });
              },
            ),
            ListTile(
              title: Text('Email: ${user.email}'),
            ),
            ListTile(
              title: Text('Role: ${translateRole(user.role)}'),
            ),
            ListTile(
              title: const Text('Alterar senha'),
              textColor: Colors.red,
              onTap: () => context.push('/change-password'),
            ),
            // const SizedBox(height: 20),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
                child: ListTile(
                  title: const Text('Sair'),
                  onTap: _onExitApp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onExitApp() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Desconectar",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Tem certeza que deseja desconectar? Você precisará fazer login novamente.',
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await UserLogoutUsecase.call();
              if (!context.mounted) return;
              context.go('/login');
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
