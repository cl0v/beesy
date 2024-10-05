import 'package:app/getit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/auth/data/models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = getIt.get<UserModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(
              Icons.person,
            ),
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: user.role == UserRole.admin,
              child: ElevatedButton(
                onPressed: () => context.push('/dashboard'),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text('Ir para a Dashboard'),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/notifications'),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Ver histórico de notificações ou toque no ícone de sininho',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
