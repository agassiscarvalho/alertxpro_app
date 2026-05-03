import 'package:alertxpro_app/data/models/alert_model.dart';
import 'notification_service.dart';

class AlertService {
  double? previousPrice;

  void checkAlerts(double currentPrice, List<AlertModel> alerts) {
    if (previousPrice == null) {
      previousPrice = currentPrice;
      return;
    }

    for (var alert in alerts) {
      if (alert.triggered) continue;

      double tolerance = _getTolerance(alert.symbol);

      bool isAbove = currentPrice > alert.targetPrice;
      bool isBelow = currentPrice < alert.targetPrice;

      bool wasAbove = previousPrice! > alert.targetPrice;
      bool wasBelow = previousPrice! < alert.targetPrice;

      // 🔥 ROMPIMENTO REAL PRA CIMA
      bool breakoutUp = wasBelow && isAbove;

      // 🔥 ROMPIMENTO REAL PRA BAIXO
      bool breakoutDown = wasAbove && isBelow;

      // 🔥 TOQUE NO PREÇO (PRECISO)
      bool touch =
          (currentPrice - alert.targetPrice).abs() <= tolerance;

      if (alert.type == "up") {
        if (breakoutUp || touch) {
          _triggerAlert(alert, currentPrice);
          break;
        }
      }

      if (alert.type == "down") {
        if (breakoutDown || touch) {
          _triggerAlert(alert, currentPrice);
          break;
        }
      }
    }

    previousPrice = currentPrice;
  }

  void _triggerAlert(AlertModel alert, double price) {
    alert.triggered = true;

    NotificationService.showNotification(
      "🚨 ${alert.symbol}",
      "Alvo: ${alert.targetPrice} | Atual: $price",
    );
  }

  double _getTolerance(String symbol) {
    if (symbol.contains("BTC")) return 5.0;
    if (symbol.contains("ETH")) return 0.5;
    return 0.01;
  }
}