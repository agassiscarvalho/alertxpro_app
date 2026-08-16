import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const welcome = '/';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile';

  static final routes = <String, WidgetBuilder> {
    welcome: (context) => const WelcomePage(),
    register: (context) => const RegisterPage(),
    login: (context) => const LoginPage(),
    home: (context) => const HomeScreen(),
    profile: (context) => const ProfileScreen(),
  };
}