import 'dart:convert';

class AlertModel {

  String symbol;

  double targetPrice;

  String type;

  bool triggered;

  bool isActive;

  AlertModel({

    required this.symbol,

    required this.targetPrice,

    required this.type,

    this.triggered = false,

    this.isActive = true,
  });

  // =========================
  // TO JSON
  // =========================
  Map<String, dynamic> toJson() {

    return {

      'symbol': symbol,

      'targetPrice': targetPrice,

      'type': type,

      'triggered': triggered,

      'isActive': isActive,
    };
  }

  // =========================
  // FROM JSON
  // =========================
  factory AlertModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return AlertModel(

      symbol: json['symbol'],

      targetPrice:
          (json['targetPrice'] as num)
              .toDouble(),

      type: json['type'],

      triggered:
          json['triggered'] ?? false,

      isActive:
          json['isActive'] ?? true,
    );
  }

  // =========================
  // ENCODE
  // =========================
  static String encode(
    List<AlertModel> alerts,
  ) {

    return jsonEncode(

      alerts.map((alert) {

        return alert.toJson();

      }).toList(),
    );
  }

  // =========================
  // DECODE
  // =========================
  static List<AlertModel> decode(
    String alerts,
  ) {

    final decoded = jsonDecode(alerts);

    return decoded.map<AlertModel>((item) {

      return AlertModel.fromJson(item);

    }).toList();
  }
}