import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


/// "Instala" o sistema de notificações push
/// Solicita a permissão do usuário -> Garante o recebimento em background -> Observa as mensagens em foreground
Future<void> setupFirebaseMessagingHandler() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Solicita a permissão do usuário para receber notificações
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  /// Garante que as notificações em background sejam observadas em produção.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Recebe e lê a mensagem de notificação quando o usuário vem do estado de Terminated (App fechado != Background)
  /// See more [https://firebase.google.com/docs/cloud-messaging/flutter/receive#handling_interaction]
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    debugPrint('From terminated Message also contains: ${initialMessage.data}');
  }

  /// Para interceptar as mensagens quando o aplicativo está aberto.
  /// See more [https://firebase.google.com/docs/cloud-messaging/flutter/receive#foreground_messages]
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    // Algumas alterações seriam necessárias caso tenha necessidade de fazer navegação entre telas.

    if (message.notification != null) {
      debugPrint(
        'Message also contained a notification: ${message.notification}',
      );
    }
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

/// Inscreve o usuário em um tópico com base no ID
Future<void> subscribeToTopic(String userId) =>
    FirebaseMessaging.instance.subscribeToTopic(userId);
