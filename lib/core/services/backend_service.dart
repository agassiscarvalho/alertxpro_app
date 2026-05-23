import 'dart:convert';

import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://10.0.0.70:3000';

  static Future<void> createAlert({
    required String symbol,
    required double price,
    required String type,
    required String fcmToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-alert'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'symbol': symbol,
          'price': price,
          'type': type,
          'fcmToken': fcmToken,
        }),
      );

      print('BACKEND RESPONSE: ${response.body}');
    } catch (e) {
      print('ERRO BACKEND: $e');
    }
  }
}