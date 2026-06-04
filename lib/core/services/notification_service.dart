import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'alert_channel';
  static const String _channelName = 'Alertas de Preço';

  // 🔥 INIT COMPLETO
  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _notifications.initialize(initSettings);

    await _requestPermission();
    await _createChannel();

    // 🔥 Firebase Messaging
    await _initializeFirebaseMessaging();
  }

  // 🔥 FIREBASE MESSAGING
  static Future<void> _initializeFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();

    debugPrint('');
    debugPrint('==========================');
    debugPrint('FCM TOKEN: $token');
    debugPrint('==========================');
    debugPrint('');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensagem recebida em foreground');

      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? 'Alertx Pro',
          message.notification!.body ?? '',
        );
      }
    });
  }

  // 🔥 PERMISSÃO ANDROID 13+
  static Future<void> _requestPermission() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // 🔥 CANAL
  static Future<void> _createChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Canal para alertas de preço',
      importance: Importance.max,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  // 🔔 NOTIFICAÇÃO PADRÃO
  static Future<void> showNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Canal para alertas de preço',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  // 🚨 ALERTA FORTE
  static Future<void> showAlertNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Canal para alertas de preço',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}