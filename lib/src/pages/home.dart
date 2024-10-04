import 'package:app/getit.dart';
import 'package:app/src/modules/auth/login/page.dart';
import 'package:app/src/modules/auth/utils/user.dart';
import 'package:app/src/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/auth/data/models/user.dart';
import '../modules/notifications/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  fetchUser() async {
    final user = await UserAuthUtils(
      await SharedPreferences.getInstance(),
    ).restoreUser();

    if (!mounted) return;
    if (user == null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<UserModel>()) {
      fetchUser();
      return const SplashScreen();
    }
    final user = getIt.get<UserModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await UserAuthUtils(
                await SharedPreferences.getInstance(),
              ).logout();
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Visibility(
              visible: user.role == UserRole.admin,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Ir para a Dashboard'),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              ),
              child: const Text(
                'Ver histórico de notificações',
              ),
            ),
            ExpansionTile(
              title: const Text(
                'Ver dados de usuário',
              ),
              expandedAlignment: Alignment.centerLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      'ID: ${user.userId} (Usuário não precisa saber o próprio ID)',
                    ),
                    Text(
                      'Email: ${user.email}',
                    ),
                    Text(
                      'Role: ${user.role}',
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
