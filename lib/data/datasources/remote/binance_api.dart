import 'dart:convert';
import 'package:http/http.dart' as http;

class BinanceApi {
  static Future<List<dynamic>> getPrices() async {
    final url = Uri.parse('https://api.binance.com/api/v3/ticker/price');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.where((item) {
        return item['symbol'] == 'BTCUSDT' ||
            item['symbol'] == 'ETHUSDT' ||
            item['symbol'] == 'BNBUSDT';
      }).toList();
    } else {
      throw Exception('Erro ao buscar preços');
    }
  }
}