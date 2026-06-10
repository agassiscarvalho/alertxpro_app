import 'dart:async';
import '../../data/datasources/remote/binance_api.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/models/alert_model.dart';
import '../../core/services/notification_service.dart';

class AlertChecker {
  Timer? _timer;

  final Map<String, double> _previousPrices = {};

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final prices = await BinanceApi.getPrices();
        if (prices.isEmpty) return;

        final Map<String, double> priceMap = {};

        for (var item in prices) {
          final symbol = item['symbol'];
          final price = double.tryParse(item['price'].toString());

          if (symbol != null && price != null) {
            priceMap[symbol] = price;
          }
        }

        final alerts = await LocalStorage.loadAlerts();
        if (alerts.isEmpty) return;

        for (var alert in alerts) {
          final currentPrice = priceMap[alert.symbol];
          if (currentPrice == null) continue;

          _handleAlert(alert, currentPrice);
        }

      } catch (e) {
        print("❌ Erro checker: $e");
      }
    });
  }

  void _handleAlert(AlertModel alert, double currentPrice) {
    final previousPrice = _previousPrices[alert.symbol];

    // primeira leitura → só salva referência
    if (previousPrice == null) {
      _previousPrices[alert.symbol] = currentPrice;
      return;
    }

    // 🚫 já disparou → nunca mais dispara
    if (alert.triggered) {
      _previousPrices[alert.symbol] = currentPrice;
      return;
    }

    // =========================
    // 🎯 DISPARO NO TOQUE (SEM ARMAR)
    // =========================

    // 🔼 TOQUE PRA CIMA
    if (alert.type == "up") {
      if (previousPrice < alert.targetPrice &&
          currentPrice >= alert.targetPrice) {

        _triggerAlert(
          alert,
          '🚀 Toque de Alta',
          '${alert.symbol} tocou ${alert.targetPrice} (Atual: $currentPrice)',
        );
      }
    }

    // 🔽 TOQUE PRA BAIXO
    if (alert.type == "down") {
      if (previousPrice > alert.targetPrice &&
          currentPrice <= alert.targetPrice) {

        _triggerAlert(
          alert,
          '📉 Toque de Baixa',
          '${alert.symbol} tocou ${alert.targetPrice} (Atual: $currentPrice)',
        );
      }
    }

    // atualiza histórico
    _previousPrices[alert.symbol] = currentPrice;
  }

  Future<void> _triggerAlert(
    AlertModel alert,
    String title,
    String message,
  ) async {
    print("🔥 ALERTA DISPARADO: ${alert.symbol}");

    await NotificationService.showNotification(title, message);

    alert.triggered = true;
    await LocalStorage.updateAlert(alert);
  }

  void stop() {
    _timer?.cancel();
  }
}