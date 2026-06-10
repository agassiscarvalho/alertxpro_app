
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../data/models/alert_model.dart';
import '../../../data/datasources/local/local_storage.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<AlertModel> alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    alerts = await LocalStorage.loadAlerts();
    setState(() {});
  }

  Future<void> _updateAlert(AlertModel alert) async {
    await LocalStorage.updateAlert(alert);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ALERTAS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return _buildCard(alert);
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B0F1A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alertas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Indicadores",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.candlestick_chart),
            label: "Gráfico",
          ),
        ],
      ),
    );
  }

  // =========================
  // 🧊 CARD PREMIUM (GLASS)
  // =========================
  Widget _buildCard(AlertModel alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          alert.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.delete, color: Colors.white38),
                  ],
                ),

                const SizedBox(height: 16),

                _buildRow(alert, isUp: true),
                const SizedBox(height: 8),
                _buildRow(alert, isUp: false),

                const SizedBox(height: 12),

                Text(
                  "Preço atual: --",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "Última atualização: --",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // 🔥 SWITCH CUSTOM (IGUAL APP)
  // =========================
  Widget _buildRow(AlertModel alert, {required bool isUp}) {
    final bool isActive =
        isUp ? alert.highEnabled : alert.lowEnabled;

    final double? targetPrice =
        isUp ? alert.highPrice : alert.lowPrice;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            Icon(
              isUp ? Icons.arrow_upward : Icons.arrow_downward,
              color: isUp ? Colors.greenAccent : Colors.redAccent,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              isUp ? "Alta" : "Baixa",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),

        Row(
          children: [
            Text(
              targetPrice?.toString() ?? '--',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),

            const SizedBox(width: 12),

            // SWITCH CUSTOM
            GestureDetector(
              onTap: () async {
                if (isUp) {
                  alert.highEnabled =
                      !alert.highEnabled;

                  if (alert.highEnabled) {
                    alert.highTriggered = false;
                  }
                } else {
                  alert.lowEnabled =
                      !alert.lowEnabled;

                  if (alert.lowEnabled) {
                    alert.lowTriggered = false;
                  }
                }

                await _updateAlert(alert);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 26,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isActive
                      ? (isUp ? Colors.green : Colors.red)
                      : Colors.grey[800],
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: isActive
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

