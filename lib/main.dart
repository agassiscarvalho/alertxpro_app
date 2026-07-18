import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'package:alertxpro_app/core/services/notification_service.dart';
import 'package:alertxpro_app/routes/app_routes.dart'; // Importamos o seu arquivo de rotas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 Inicializa notificações
  await NotificationService.init();

  // 🔑 Verifica se o usuário já está logado
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Se estiver logado, vai direto para a tela principal. Senão, vai para Boas-Vindas.
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.welcome, 
      routes: AppRoutes.routes,        // Passa o mapa de rotas que configuramos
    );
  }
}