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

  /// 🔹 CRIAR A PARTIR DO JSON
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      symbol: json['symbol'] ?? '',
      targetPrice: (json['targetPrice'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'up',
      triggered: json['triggered'] ?? false,
    );
  }

  /// 🔹 CONVERTER PARA JSON
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'targetPrice': targetPrice,
      'type': type,
      'triggered': triggered,
    };
  }

  /// 🔥 SALVAR LISTA
  static String encode(List<AlertModel> alerts) {
    return jsonEncode(
      alerts.map((a) => a.toJson()).toList(),
    );
  }

  /// 🔥 CARREGAR LISTA (RESISTENTE A ERROS)
  static List<AlertModel> decode(String data) {
    try {
      final decoded = jsonDecode(data);

      if (decoded is List) {
        return decoded
            .map<AlertModel>((e) => AlertModel.fromJson(e))
            .toList();
      }

      if (decoded is Map<String, dynamic>) {
        return [AlertModel.fromJson(decoded)];
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}