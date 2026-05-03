import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alertxpro_app/core/services/binance_service.dart';
import 'package:alertxpro_app/core/services/notification_service.dart';
import 'package:alertxpro_app/core/services/alert_service.dart';
import 'package:alertxpro_app/data/models/alert_model.dart';
import 'package:alertxpro_app/features/alerts/screens/create_alert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? currentPrice;
  final String symbol = "BTCUSDT";

  List<AlertModel> alerts = [];

  Timer? _timer;

  // 🔥 SERVICE CORRETO (NÃO recriar!)
  final AlertService alertService = AlertService();

  @override
  void initState() {
    super.initState();
    fetchPrice();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchPrice();
    });
  }

  void fetchPrice() async {
    try {
      double price = await BinanceService.getPrice(symbol);

      print("Preço atual: $price");

      setState(() {
        currentPrice = price;
      });

      // 🔥 AQUI ESTÁ A MÁGICA
      alertService.checkAlerts(price, alerts);

    } catch (e) {
      print("Erro: $e");
    }
  }

  // ➕ CRIAR ALERTA
  void addAlert() async {
    if (currentPrice == null) return;

    final alert = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAlertScreen(
          symbol: symbol,
          currentPrice: currentPrice!,
          changePercent: 0,
        ),
      ),
    );

    if (alert != null) {
      print("Novo alerta: ${alert.targetPrice}");

      setState(() {
        alerts.add(alert);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertx Pro')),
      body: Column(
        children: [
          const SizedBox(height: 20),

          currentPrice == null
              ? const CircularProgressIndicator()
              : Text(
                  'BTC: \$${currentPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: addAlert,
            child: const Text('Criar Alerta'),
          ),

          const SizedBox(height: 10),

          // 🔧 TESTE NOTIFICAÇÃO
          ElevatedButton(
            onPressed: () {
              NotificationService.showNotification(
                "TESTE",
                "FUNCIONANDO",
              );
            },
            child: const Text("Testar Notificação"),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];

                return ListTile(
                  title: Text(alert.symbol),
                  subtitle:
                      Text('${alert.type} - ${alert.targetPrice}'),
                  trailing: Icon(
                    alert.triggered
                        ? Icons.check_circle
                        : Icons.notifications_active,
                    color: alert.triggered ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}