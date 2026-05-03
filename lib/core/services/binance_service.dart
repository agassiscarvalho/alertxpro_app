import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceData {
  final double price;
  final double changePercent;

  PriceData({
    required this.price,
    required this.changePercent,
  });
}

class BinanceService {
  /// 🔹 PREÇO SIMPLES (caso você só precise do preço)
  static Future<double> getPrice(String symbol) async {
    final url = Uri.parse(
      'https://api.binance.com/api/v3/ticker/price?symbol=$symbol',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    return double.parse(data['price']);
  }

  /// 🔥 PREÇO + VARIAÇÃO (PROFISSIONAL)
  static Future<PriceData> getFullData(String symbol) async {
    final url = Uri.parse(
      'https://api.binance.com/api/v3/ticker/24hr?symbol=$symbol',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    return PriceData(
      price: double.parse(data['lastPrice']),
      changePercent: double.parse(data['priceChangePercent']),
    );
  }
}