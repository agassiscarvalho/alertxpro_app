import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
class BackendService {

  static const String baseUrl =
      'https://unhelpful-professed-engraver.ngrok-free.dev/api';

  static Future<bool> createAlert({
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

      return response.statusCode == 200;

    } catch (e) {

      debugPrint('❌ Erro Backend: $e');

      return false;
    }
  }
}