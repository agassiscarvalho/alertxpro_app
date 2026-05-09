import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/alert_service.dart';
import '../../../core/services/binance_service.dart';
import '../../../core/services/notification_service.dart';

import '../../../data/models/alert_model.dart';

import '../widgets/price_card.dart';
import '../../alerts/screens/create_alert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  // =========================
  // SERVICES
  // =========================
  final BinanceService _binanceService =
      BinanceService();

  final AlertService _alertService =
      AlertService();

  // =========================
  // TIMER
  // =========================
  Timer? _timer;

  // =========================
  // ATIVOS
  // =========================
  String selectedSymbol = 'BTCUSDT';

  final List<String> symbols = [

    'BTCUSDT',
    'ETHUSDT',
    'SOLUSDT',
    'BNBUSDT',
  ];

  // =========================
  // PREÇOS
  // =========================
  double currentPrice = 0;

  double previousPrice = 0;

  double dailyChange = 0;

  // =========================
  // ALERTAS
  // =========================
  List<AlertModel> alerts = [];

  @override
  void initState() {

    super.initState();

    _loadAlerts();

    _startRealtime();
  }

  // =========================
  // TEMPO REAL
  // =========================
  void _startRealtime() {

    _loadPrice();

    _timer?.cancel();

    _timer = Timer.periodic(

      const Duration(seconds: 2),

      (_) {

        _loadPrice();
      },
    );
  }

  // =========================
  // BUSCA PREÇO
  // =========================
  Future<void> _loadPrice()
  async {

    try {

      final price =
          await _binanceService.fetchPrice(
        selectedSymbol,
      );

      final change =
          await _binanceService
              .fetch24hChange(
        selectedSymbol,
      );

      if (!mounted) return;

      setState(() {

        previousPrice = currentPrice;

        currentPrice = price;

        dailyChange = change;
      });

      _alertService.checkAlerts(

        previousPrice,

        currentPrice,

        alerts,
      );

      _saveAlerts();

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  // =========================
  // SALVAR ALERTAS
  // =========================
  Future<void> _saveAlerts()
  async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(

      'alerts',

      AlertModel.encode(alerts),
    );
  }

  // =========================
  // CARREGAR ALERTAS
  // =========================
  Future<void> _loadAlerts()
  async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final data =
        prefs.getString('alerts');

    if (data != null) {

      setState(() {

        alerts =
            AlertModel.decode(data);
      });
    }
  }

  // =========================
  // ADICIONAR ALERTA
  // =========================
  void _addAlert(
    AlertModel alert,
  ) {

    final existingIndex =
        alerts.indexWhere(

      (a) =>
          a.symbol == alert.symbol,
    );

    if (existingIndex != -1) {

      final existing =
          alerts[existingIndex];

      if (alert.highPrice != null) {

        existing.highPrice =
            alert.highPrice;

        existing.highEnabled =
            alert.highEnabled;

        existing.highTriggered =
            false;
      }

      if (alert.lowPrice != null) {

        existing.lowPrice =
            alert.lowPrice;

        existing.lowEnabled =
            alert.lowEnabled;

        existing.lowTriggered =
            false;
      }

    } else {

      alerts.add(alert);
    }

    setState(() {});

    _saveAlerts();
  }

  // =========================
  // TOGGLE ALTA
  // =========================
  void _toggleHigh(
    AlertModel alert,
    bool value,
  ) {

    setState(() {

      alert.highEnabled = value;

      if (value) {

        alert.highTriggered =
            false;
      }
    });

    _saveAlerts();
  }

  // =========================
  // TOGGLE BAIXA
  // =========================
  void _toggleLow(
    AlertModel alert,
    bool value,
  ) {

    setState(() {

      alert.lowEnabled = value;

      if (value) {

        alert.lowTriggered =
            false;
      }
    });

    _saveAlerts();
  }

  // =========================
  // EXCLUIR
  // =========================
  void _deleteAlert(
    int index,
  ) {

    setState(() {

      alerts.removeAt(index);
    });

    _saveAlerts();
  }

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0E1117),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF0E1117),

        elevation: 0,

        centerTitle: true,

        title: const Text(

          'ALERTAS',

          style: TextStyle(

            fontWeight:
                FontWeight.bold,

            fontSize: 22,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            Colors.green,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () async {

          final result =
              await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  CreateAlertScreen(

                symbol:
                    selectedSymbol,

                currentPrice:
                    currentPrice,

                changePercent:
                    dailyChange,
              ),
            ),
          );

          if (result != null) {

            _addAlert(result);
          }
        },
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            // =====================
            // DROPDOWN
            // =====================
            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              decoration: BoxDecoration(

                color:
                    const Color(0xFF1A1F2B),

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: DropdownButton<String>(

                dropdownColor:
                    const Color(0xFF1A1F2B),

                value: selectedSymbol,

                isExpanded: true,

                underline:
                    const SizedBox(),

                style: const TextStyle(

                  color: Colors.white,

                  fontWeight:
                      FontWeight.w600,
                ),

                items:
                    symbols.map((symbol) {

                  return DropdownMenuItem(

                    value: symbol,

                    child: Text(symbol),
                  );

                }).toList(),

                onChanged: (value) {

                  setState(() {

                    selectedSymbol =
                        value!;
                  });

                  _loadPrice();
                },
              ),
            ),

            const SizedBox(height: 18),

            // =====================
            // PREÇO
            // =====================
            PriceCard(

              symbol: selectedSymbol,

              price: currentPrice,

              dailyChange:
                  dailyChange,
            ),

            const SizedBox(height: 18),

            Expanded(

              child: alerts.isEmpty

                  ? const Center(

                      child: Text(

                        'Nenhum alerta criado',

                        style: TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),
                    )

                  : ListView.builder(

                      itemCount:
                          alerts.length,

                      itemBuilder:
                          (_, index) {

                        final alert =
                            alerts[index];

                        return Container(

                          margin:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),

                          padding:
                              const EdgeInsets.all(
                            14,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                const Color(
                              0xFF1A1F2B,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Column(

                            children: [

                              // HEADER
                              Row(
                                children: [

                                  Text(

                                    alert.symbol,

                                    style:
                                        const TextStyle(

                                      color:
                                          Colors.white,

                                      fontSize: 18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const Spacer(),

                                  IconButton(

                                    onPressed:
                                        () {

                                      _deleteAlert(
                                        index,
                                      );
                                    },

                                    icon:
                                        const Icon(

                                      Icons.delete_outline,

                                      color:
                                          Colors.white70,
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(
                                color:
                                    Colors.white10,
                              ),

                              // ALTA
                              if (alert.highPrice !=
                                  null)

                                _buildAlertTile(

                                  icon:
                                      Icons.arrow_upward,

                                  iconColor:
                                      Colors.green,

                                  title:
                                      'Alta',

                                  price:
                                      alert.highPrice!,

                                  enabled:
                                      alert.highEnabled,

                                  triggered:
                                      alert.highTriggered,

                                  onChanged:
                                      (value) {

                                    _toggleHigh(
                                      alert,
                                      value,
                                    );
                                  },
                                ),

                              // BAIXA
                              if (alert.lowPrice !=
                                  null)

                                _buildAlertTile(

                                  icon:
                                      Icons.arrow_downward,

                                  iconColor:
                                      Colors.red,

                                  title:
                                      'Baixa',

                                  price:
                                      alert.lowPrice!,

                                  enabled:
                                      alert.lowEnabled,

                                  triggered:
                                      alert.lowTriggered,

                                  onChanged:
                                      (value) {

                                    _toggleLow(
                                      alert,
                                      value,
                                    );
                                  },
                                ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(

                                'Preço atual: \$${currentPrice.toStringAsFixed(2)}',

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white70,

                                  fontSize: 14,
                                ),
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
    );
  }

  // =========================
  // TILE ALERTA
  // =========================
  Widget _buildAlertTile({

    required IconData icon,

    required Color iconColor,

    required String title,

    required double price,

    required bool enabled,

    required bool triggered,

    required Function(bool)
        onChanged,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 10,
      ),

      decoration: BoxDecoration(

        color:
            const Color(0xFF111827),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    color: Colors.white,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 2),

                Text(

                  '\$${price.toStringAsFixed(2)}',

                  style: const TextStyle(

                    color: Colors.white70,

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                Text(

                  triggered
                      ? '🔔 Disparado'
                      : '⏳ Aguardando',

                  style: TextStyle(

                    color: triggered
                        ? Colors.green
                        : Colors.orange,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: enabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}