import 'dart:convert';
import 'package:http/http.dart' as http;

class BinanceService {
  static Future<double> getBTCPrice() async {
    final url = Uri.parse(
      'https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT',
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    return double.parse(data['price']);
  }
}