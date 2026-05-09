import 'dart:convert';

class AlertModel {

  // =========================
  // ATIVO
  // =========================
  String symbol;

  // =========================
  // ALERTA ALTA
  // =========================
  double? highPrice;

  bool highEnabled;

  bool highTriggered;

  // =========================
  // ALERTA BAIXA
  // =========================
  double? lowPrice;

  bool lowEnabled;

  bool lowTriggered;

  // =========================
  // CONSTRUTOR
  // =========================
  AlertModel({

    required this.symbol,

    this.highPrice,
    this.highEnabled = false,
    this.highTriggered = false,

    this.lowPrice,
    this.lowEnabled = false,
    this.lowTriggered = false,
  });

  // =========================
  // TO JSON
  // =========================
  Map<String, dynamic> toJson() {

    return {

      'symbol': symbol,

      'highPrice': highPrice,
      'highEnabled': highEnabled,
      'highTriggered': highTriggered,

      'lowPrice': lowPrice,
      'lowEnabled': lowEnabled,
      'lowTriggered': lowTriggered,
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

      highPrice:
          json['highPrice'] != null
              ? (json['highPrice'] as num)
                  .toDouble()
              : null,

      highEnabled:
          json['highEnabled'] ?? false,

      highTriggered:
          json['highTriggered'] ?? false,

      lowPrice:
          json['lowPrice'] != null
              ? (json['lowPrice'] as num)
                  .toDouble()
              : null,

      lowEnabled:
          json['lowEnabled'] ?? false,

      lowTriggered:
          json['lowTriggered'] ?? false,
    );
  }

  // =========================
  // ENCODE LIST
  // =========================
  static String encode(
    List<AlertModel> alerts,
  ) {

    return jsonEncode(

      alerts.map(
        (alert) => alert.toJson(),
      ).toList(),
    );
  }

  // =========================
  // DECODE LIST
  // =========================
  static List<AlertModel> decode(
    String alerts,
  ) {

    final List decoded =
        jsonDecode(alerts);

    return decoded.map((item) {

      return AlertModel.fromJson(item);

    }).toList();
  }
}