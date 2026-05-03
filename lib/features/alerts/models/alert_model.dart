import 'dart:convert';

class AlertModel {
  String symbol;
  double targetPrice;
  String type; // "up" ou "down"
  bool triggered;

  AlertModel({
    required this.symbol,
    required this.targetPrice,
    required this.type,
    this.triggered = false,
  });

  // 🔄 PARA JSON
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'targetPrice': targetPrice,
      'type': type,
      'triggered': triggered,
    };
  }

  // 🔄 DE JSON
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      symbol: json['symbol'],
      targetPrice: (json['targetPrice'] as num).toDouble(),
      type: json['type'],
      triggered: json['triggered'] ?? false,
    );
  }

  // 🔥 SALVAR LISTA
  static String encode(List<AlertModel> alerts) {
    return jsonEncode(
      alerts.map((a) => a.toJson()).toList(),
    );
  }

  // 🔥 CARREGAR LISTA
  static List<AlertModel> decode(String data) {
    final List decoded = jsonDecode(data);

    return decoded
        .map((e) => AlertModel.fromJson(e))
        .toList();
  }
}