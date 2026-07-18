import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  // ⚠️ ATENÇÃO: Substitua o IP abaixo pelo IP da sua rede Wi-Fi local onde o seu Node.js está rodando.
  // Como você mencionou que a comunicação Wi-Fi entre o notebook e o PC está funcionando,
  // coloque aqui o IP correto e a porta do seu backend (ex: 3000, 5000, etc).
  final String baseUrl = 'https://unhelpful-professed-engraver.ngrok-free.dev/api';

  Future<bool> registerUser({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );

      // Se o backend retornar sucesso (Status 200 ou 201 Created)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Salva o estado de logado
        return true;
      } else {
        print('Erro do backend. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão Wi-Fi / Rede: $e');
      return false;
    }
  }

  // Nova função adicionada para o Login tradicional
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'), // Ajuste para a rota de login do seu backend (/auth/login ou apenas /login)
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Salva que está logado
        return true;
      } else {
        print('Erro no login. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão no login: $e');
      return false;
    }
  }
}