import 'package:app/src/core/services/getit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/data/models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  /// Abre a tela de notificações quando o usuário toca na notificação vindo do estado background (NOT Terminated)
  /// See more [https://firebase.google.com/docs/cloud-messaging/flutter/receive#handling_interaction]
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _navigateToNotifications(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_navigateToNotifications);
  }

  _navigateToNotifications([msg]) => context.push('/notifications');

  @override
  Widget build(BuildContext context) {
    final user = getIt.get<UserModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _navigateToNotifications,
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
              onPressed: _navigateToNotifications,
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
