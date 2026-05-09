import '../../data/models/alert_model.dart';
import 'notification_service.dart';

class AlertService {

  // =========================
  // VERIFICA ALERTAS
  // =========================
  void checkAlerts(
    double previousPrice,
    double currentPrice,
    List<AlertModel> alerts,
  ) {

    for (final alert in alerts) {

      // =========================
      // ROMPIMENTO ALTA
      // =========================
      if (

          alert.highPrice != null &&
          alert.highEnabled &&
          !alert.highTriggered &&

          previousPrice <
              alert.highPrice! &&

          currentPrice >=
              alert.highPrice!
      ) {

        alert.highTriggered = true;

        // DESLIGA SWITCH
        alert.highEnabled = false;

        NotificationService.showNotification(

          'ALERTA DE ALTA',

          '${alert.symbol} rompeu '
          '${alert.highPrice}',
        );
      }

      // =========================
      // ROMPIMENTO BAIXA
      // =========================
      if (

          alert.lowPrice != null &&
          alert.lowEnabled &&
          !alert.lowTriggered &&

          previousPrice >
              alert.lowPrice! &&

          currentPrice <=
              alert.lowPrice!
      ) {

        alert.lowTriggered = true;

        // DESLIGA SWITCH
        alert.lowEnabled = false;

        NotificationService.showNotification(

          'ALERTA DE BAIXA',

          '${alert.symbol} perdeu '
          '${alert.lowPrice}',
        );
      }
    }
  }
}