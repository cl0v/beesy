import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: Future.value(null),
        builder: (context, snapshot) {
          //TODO: Implementar notificações
          return const Text('Notificações');
        },
      )),
    );
  }
}
