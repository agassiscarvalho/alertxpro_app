import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      _notifications = FlutterLocalNotificationsPlugin();

  // =====================================================
  // CHANNEL
  // =====================================================
  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'alert_channel',
    'Alertas de Preço',
    description: 'Canal de alertas do Alertx Pro',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  // =====================================================
  // INIT
  // =====================================================
  static Future<void> init() async {

    // ANDROID INIT
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    // INIT PLUGIN
    await _notifications.initialize(settings);

    // PERMISSÃO
    await _requestPermission();

    // CANAL
    await _createChannel();
  }

  // =====================================================
  // PERMISSÃO
  // =====================================================
  static Future<void> _requestPermission() async {

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // =====================================================
  // CREATE CHANNEL
  // =====================================================
  static Future<void> _createChannel() async {

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      _channel,
    );
  }

  // =====================================================
  // SHOW NOTIFICATION
  // =====================================================
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alert_channel',
      'Alertas de Preço',

      channelDescription:
          'Canal de alertas do Alertx Pro',

      importance: Importance.max,
      priority: Priority.high,

      playSound: true,
      enableVibration: true,

      ticker: 'ticker',
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  // =====================================================
  // ALERTA FORTE
  // =====================================================
  static Future<void> showAlertNotification({
    required String title,
    required String body,
  }) async {

    await showNotification(
      title: title,
      body: body,
    );
  }
}