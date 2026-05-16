import '../../data/models/alert_model.dart';
import 'notification_service.dart';

class AlertService {

  // =====================================================
  // VERIFICA TODOS ALERTAS
  // =====================================================
  void checkAlerts(
    double previousPrice,
    double currentPrice,
    List<AlertModel> alerts,
  ) {

    for (final alert in alerts) {

      // =====================================================
      // ROMPIMENTO DE ALTA
      // =====================================================
      if (

          alert.highPrice != null &&
          alert.highEnabled &&
          !alert.highTriggered &&

          previousPrice < alert.highPrice! &&
          currentPrice >= alert.highPrice!
      ) {

        // MARCA COMO DISPARADO
        alert.highTriggered = true;

        // DESATIVA ALERTA
        alert.highEnabled = false;

        // NOTIFICAÇÃO
        NotificationService.showNotification(
          title: '🚀 ALERTA DE ALTA',
          body:
              '${alert.symbol} rompeu ${alert.highPrice}',
        );

        print(
          'ALERTA DE ALTA DISPARADO',
        );
      }

      // =====================================================
      // ROMPIMENTO DE BAIXA
      // =====================================================
      if (

          alert.lowPrice != null &&
          alert.lowEnabled &&
          !alert.lowTriggered &&

          previousPrice > alert.lowPrice! &&
          currentPrice <= alert.lowPrice!
      ) {

        // MARCA COMO DISPARADO
        alert.lowTriggered = true;

        // DESATIVA ALERTA
        alert.lowEnabled = false;

        // NOTIFICAÇÃO
        NotificationService.showNotification(
          title: '📉 ALERTA DE BAIXA',
          body:
              '${alert.symbol} perdeu ${alert.lowPrice}',
        );

        print(
          'ALERTA DE BAIXA DISPARADO',
        );
      }
    }
  }
}