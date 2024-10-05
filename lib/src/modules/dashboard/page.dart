import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel de Administrador"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.push('/dashboard/users');
            },
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Ver usuários'),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Enviar notificação
            },
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Enviar notificação'),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/dashboard/logs');
            },
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Ver Logs'),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
