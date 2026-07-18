import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/backend_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/alert_service.dart';
import '../../../core/services/binance_service.dart';
import '../../../data/models/alert_model.dart';

import '../widgets/price_card.dart';
import '../../alerts/screens/create_alert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BinanceService _binanceService = BinanceService();
  final AlertService _alertService = AlertService();

  Timer? _timer;
  String selectedSymbol = 'BTCUSDT';
  final List<String> symbols = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'XRPUSDT', 'BNBUSDT'];

  double currentPrice = 0;
  double previousPrice = 0;
  double dailyChange = 0;

  List<AlertModel> alerts = [];
  int _currentIndex = 0;
  
  // Variável para guardar o token do Firebase
  String? _fcmToken;

  // ==========================================
  // FUNÇÃO AUXILIAR DE PRECISÃO DINÂMICA
  // ==========================================
  String _formatPrice(double price, String symbol) {
    if (symbol.toUpperCase().contains('XRP') || price < 10) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  @override
  void initState() {
    super.initState();
    _initFcm(); 
    _loadAlerts();
    _startRealtime();
  }

  void _startRealtime() {
    _loadPrice();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _loadPrice());
  }

  Future<void> _initFcm() async {
    try {
      final token = await NotificationService.getFcmToken();
      setState(() {
        _fcmToken = token;
      });
      debugPrint("🔥 FCM TOKEN: $token");
    } catch (e) {
      debugPrint("Erro FCM: $e");
    }
  }

  Future<void> _loadPrice() async {
    try {
      final price = await _binanceService.fetchPrice(selectedSymbol);
      final change = await _binanceService.fetch24hChange(selectedSymbol);

      if (!mounted) return;

      setState(() {
        previousPrice = currentPrice;
        currentPrice = price;
        dailyChange = change;
      });

      _alertService.checkAlerts(previousPrice, currentPrice, alerts);
      _saveAlerts();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _saveAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alerts', AlertModel.encode(alerts));
  }

  Future<void> _loadAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('alerts');
    if (data != null) {
      setState(() {
        alerts = AlertModel.decode(data);
      });
    }
  }

  Future<void> _addAlert(AlertModel alert) async {
    final existingIndex = alerts.indexWhere((a) => a.symbol == alert.symbol);

    if (existingIndex != -1) {
      final existing = alerts[existingIndex];
      if (alert.highPrice != null) {
        existing.highPrice = alert.highPrice;
        existing.highEnabled = alert.highEnabled;
        existing.highTriggered = false;
      }
      if (alert.lowPrice != null) {
        existing.lowPrice = alert.lowPrice;
        existing.lowEnabled = alert.lowEnabled;
        existing.lowTriggered = false;
      }
    } else {
      alerts.add(alert);
    }

    setState(() {});
    _saveAlerts();

    // --- CORREÇÃO DO SALVAMENTO DO TOKEN ---
    String? tokenEnvio = _fcmToken ?? await NotificationService.getFcmToken();

    if (tokenEnvio != null) {
      if (alert.highPrice != null) {
        await BackendService.createAlert(
          symbol: alert.symbol,
          price: alert.highPrice!,
          type: 'high',
          fcmToken: tokenEnvio,
        );
      }
      if (alert.lowPrice != null) {
        await BackendService.createAlert(
          symbol: alert.symbol,
          price: alert.lowPrice!,
          type: 'low',
          fcmToken: tokenEnvio,
        );
      }
    } else {
      debugPrint("⚠️ Não foi possível enviar ao servidor: FCM Token continua nulo no dispositivo.");
    }
  }

  void _toggleHigh(AlertModel alert, bool value) {
    setState(() {
      alert.highEnabled = value;
      if (value) alert.highTriggered = false;
    });
    _saveAlerts();
  }

  void _toggleLow(AlertModel alert, bool value) {
    setState(() {
      alert.lowEnabled = value;
      if (value) alert.lowTriggered = false;
    });
    _saveAlerts();
  }

  void _deleteAlert(int index) {
    setState(() {
      alerts.removeAt(index);
    });
    _saveAlerts();
  }

  Future<void> _navigateToCreateAlert() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAlertScreen(
          symbol: selectedSymbol,
          currentPrice: currentPrice,
          changePercent: dailyChange,
        ),
      ),
    );

    if (result != null) {
      _addAlert(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    const appBgColor = Color(0xFF0D1424); 

    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CABEÇALHO: Título do App e Ícone de Perfil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AlertX Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. IDENTIDADE: Boas-vindas
              const Text(
                'Olá,',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Text(
                'Erlich Bachman',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // Seletor de Ativos
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF161F33),
                  value: selectedSymbol,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  items: symbols.map((symbol) {
                    return DropdownMenuItem(value: symbol, child: Text(symbol));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSymbol = value!;
                    });
                    _loadPrice();
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Card de preço real
              PriceCard(
                symbol: selectedSymbol,
                price: currentPrice,
                dailyChange: dailyChange,
              ),
              const SizedBox(height: 16),

              // 3. CONTEÚDO PRINCIPAL (Lista de Alertas ou o Botão Gigante)
              Expanded(
                child: alerts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _navigateToCreateAlert,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.04),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.blue.shade400,
                                  size: 55,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Adicionar Novo Alarme',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: alerts.length,
                        itemBuilder: (_, index) {
                          final alert = alerts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.03),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(alert.symbol, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () => _deleteAlert(index),
                                      icon: const Icon(Icons.delete_outline, color: Colors.white60),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white10),
                                if (alert.highPrice != null)
                                  _buildAlertTile(
                                    icon: Icons.arrow_upward,
                                    iconColor: Colors.green,
                                    title: 'Alta',
                                    price: alert.highPrice!,
                                    symbol: alert.symbol,
                                    enabled: alert.highEnabled,
                                    triggered: alert.highTriggered,
                                    onChanged: (value) => _toggleHigh(alert, value),
                                  ),
                                if (alert.lowPrice != null)
                                  _buildAlertTile(
                                    icon: Icons.arrow_downward,
                                    iconColor: Colors.red,
                                    title: 'Baixa',
                                    price: alert.lowPrice!,
                                    symbol: alert.symbol,
                                    enabled: alert.lowEnabled,
                                    triggered: alert.lowTriggered,
                                    onChanged: (value) => _toggleLow(alert, value),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  'Preço atual: ${_formatPrice(currentPrice, alert.symbol)}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // 4. BOTÃO FLUTUANTE DE ADIÇÃO (Só aparece se a lista NÃO estiver vazia)
      floatingActionButton: alerts.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.blue.shade400,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: _navigateToCreateAlert,
              child: const Icon(Icons.add, size: 28),
            )
          : null,

      // 5. BARRA DE NAVEGAÇÃO INFERIOR INTEGRADA
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: appBgColor,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0 && alerts.isEmpty) {
              _navigateToCreateAlert();
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue.shade400,
          unselectedItemColor: Colors.white38,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.notifications_none_outlined),
              ),
              label: 'Alertas',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.bar_chart_outlined),
              ),
              label: 'Indicadores',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.candlestick_chart_outlined),
              ),
              label: 'Gráfico',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double price,
    required String symbol,
    required bool enabled,
    required bool triggered,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1424).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(_formatPrice(price, symbol), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  triggered ? '🔔 Disparado' : '⏳ Aguardando',
                  style: TextStyle(color: triggered ? Colors.green : Colors.orange, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(value: enabled, onChanged: onChanged),
        ],
      ),
    );
  }
}