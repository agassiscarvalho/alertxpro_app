import 'package:shared_preferences/shared_preferences.dart';
import '../../models/alert_model.dart';

class LocalStorage {
  static const String key = 'alerts';

  static Future<void> saveAlerts(List<AlertModel> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = AlertModel.encode(alerts);
    await prefs.setString(key, encoded);
  }

  static Future<List<AlertModel>> loadAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];

    return AlertModel.decode(data);
  }

  // 🔥 ESSENCIAL
  static Future<void> updateAlert(AlertModel updated) async {
    final alerts = await loadAlerts();

    final index = alerts.indexWhere(
      (a) =>
          a.symbol == updated.symbol &&
          a.targetPrice == updated.targetPrice,
    );

    if (index != -1) {
      alerts[index] = updated;
    }

    await saveAlerts(alerts);
  }
}