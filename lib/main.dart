import 'package:flutter/material.dart';
import 'package:alertxpro_app/core/services/notification_service.dart';
import 'package:alertxpro_app/features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 Inicializa notificações
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // ✅ TELA INICIAL CORRETA
    );
  }
}