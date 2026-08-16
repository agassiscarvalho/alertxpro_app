import 'dart:convert';

import 'package:http/http.dart' as http;

class BinanceService {

  // =========================
  // BUSCAR PREÇO
  // =========================
  Future<double> fetchPrice(
    String symbol,
  ) async {

    final response = await http.get(

      Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=$symbol',
      ),
    );

    final data =
        jsonDecode(response.body);

    return double.parse(
      data['price'],
    );
  }

  // =========================
  // VARIAÇÃO 24H
  // =========================
  Future<double> fetch24hChange(
    String symbol,
  ) async {

    final response = await http.get(

      Uri.parse(
        'https://api.binance.com/api/v3/ticker/24hr?symbol=$symbol',
      ),
    );

    final data =
        jsonDecode(response.body);

    return double.parse(
      data['priceChangePercent'],
    );
  }

  // =========================
  // LISTA DE ATIVOS DISPONÍVEIS
  // =========================
  Future<List<String>> fetchAvailableSymbols() async {
    return [
      'BTCUSDT',
      'ETHUSDT',
      'SOLUSDT',
      'BNBUSDT',
      'XRPUSDT',
      'ADAUSDT',
      'DOGEUSDT',
    ];
  }
}