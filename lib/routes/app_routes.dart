import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/login_page.dart'; // Importação adicionada

class AppRoutes {
  static const welcome = '/';
  static const register = '/register';
  static const login = '/login'; // Rota adicionada
  static const home = '/home';

  static final routes = <String, WidgetBuilder>{
    welcome: (context) => const WelcomePage(),
    register: (context) => const RegisterPage(),
    login: (context) => const LoginPage(), // Mapeamento adicionado
    home: (context) => const HomeScreen(),
  };
}