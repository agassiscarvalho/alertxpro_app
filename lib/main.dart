import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'package:alertxpro_app/core/services/notification_service.dart';
import 'package:alertxpro_app/features/home/screens/home_screen.dart';

// ======================================================
// BACKGROUND HANDLER
// ======================================================
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {

  // INICIALIZA FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // MOSTRA NOTIFICAÇÃO
  await NotificationService.showNotification(
    title: message.notification?.title ?? 'ALERTX PRO',
    body: message.notification?.body ?? '',
  );
}

// ======================================================
// MAIN
// ======================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ======================================================
  // FIREBASE
  // ======================================================
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ======================================================
  // NOTIFICAÇÕES LOCAIS
  // ======================================================
  await NotificationService.init();

  // ======================================================
  // BACKGROUND FCM
  // ======================================================
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // ======================================================
  // PEDIR PERMISSÕES
  // ======================================================
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('PERMISSION: ${settings.authorizationStatus}');

  // ======================================================
  // TOKEN FCM
  // ======================================================
  final token = await FirebaseMessaging.instance.getToken();

  print('');
  print('========================================');
  print('FCM TOKEN:');
  print(token);
  print('========================================');
  print('');

  // ======================================================
  // APP ABERTO
  // ======================================================
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {

      print('NOTIFICAÇÃO RECEBIDA FOREGROUND');

      await NotificationService.showNotification(
        title: message.notification?.title ?? 'ALERTX PRO',
        body: message.notification?.body ?? '',
      );
    },
  );

  // ======================================================
  // USUÁRIO ABRIU A NOTIFICAÇÃO
  // ======================================================
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {

      print('USUÁRIO ABRIU A NOTIFICAÇÃO');
    },
  );

  runApp(const MyApp());
}

// ======================================================
// APP
// ======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Alertx Pro',

      theme: ThemeData.dark(),

      home: const HomeScreen(),
    );
  }
}