import 'package:flutter/material.dart';

import '../../../data/models/alert_model.dart';

class CreateAlertScreen extends StatefulWidget {

  final String symbol;
  final double currentPrice;
  final double changePercent;

  const CreateAlertScreen({
    super.key,
    required this.symbol,
    required this.currentPrice,
    required this.changePercent,
  });

  @override
  State<CreateAlertScreen> createState() =>
      _CreateAlertScreenState();
}

class _CreateAlertScreenState
    extends State<CreateAlertScreen> {

  // =========================
  // CONTROLLERS
  // =========================
  final TextEditingController
      highController =
      TextEditingController();

  final TextEditingController
      lowController =
      TextEditingController();

  // =========================
  // SWITCHES
  // =========================
  bool enableHigh = true;
  bool enableLow = false;

  @override
  Widget build(BuildContext context) {

    final isUp =
        widget.changePercent >= 0;

    return Scaffold(

      backgroundColor:
          const Color(0xFF0B0F1A),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF0B0F1A),

        elevation: 0,

        centerTitle: true,

        title: const Text(

          'Criar Alertas',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =====================
            // ATIVO
            // =====================
            Center(
              child: Column(
                children: [

                  Text(

                    widget.symbol,

                    style: const TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    '\$${widget.currentPrice.toStringAsFixed(2)}',

                    style: const TextStyle(

                      fontSize: 36,

                      fontWeight:
                          FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(

                    '${widget.changePercent.toStringAsFixed(2)}%',

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          isUp
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================
            // ALERTA ALTA
            // =====================
            Container(

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color:
                    const Color(0xFF1A1F2B),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Icon(

                        Icons.arrow_upward,

                        color: Colors.green,

                        size: 26,
                      ),

                      const SizedBox(width: 10),

                      const Text(

                        'Alerta de Alta',

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Switch(

                        value: enableHigh,

                        onChanged: (value) {

                          setState(() {

                            enableHigh =
                                value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextField(

                    controller:
                        highController,

                    enabled: enableHigh,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 16,
                    ),

                    decoration:
                        InputDecoration(

                      hintText:
                          'Preço de alta',

                      hintStyle:
                          const TextStyle(

                        color:
                            Colors.white54,
                      ),

                      filled: true,

                      fillColor:
                          const Color(
                        0xFF111827,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(

                          color:
                              Colors.white12,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(

                          color:
                              Colors.green,

                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =====================
            // ALERTA BAIXA
            // =====================
            Container(

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color:
                    const Color(0xFF1A1F2B),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Icon(

                        Icons.arrow_downward,

                        color: Colors.red,

                        size: 26,
                      ),

                      const SizedBox(width: 10),

                      const Text(

                        'Alerta de Baixa',

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Switch(

                        value: enableLow,

                        onChanged: (value) {

                          setState(() {

                            enableLow =
                                value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextField(

                    controller:
                        lowController,

                    enabled: enableLow,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 16,
                    ),

                    decoration:
                        InputDecoration(

                      hintText:
                          'Preço de baixa',

                      hintStyle:
                          const TextStyle(

                        color:
                            Colors.white54,
                      ),

                      filled: true,

                      fillColor:
                          const Color(
                        0xFF111827,
                      ),

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(

                          color:
                              Colors.white12,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),

                        borderSide:
                            const BorderSide(

                          color:
                              Colors.red,

                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =====================
            // BOTÃO
            // =====================
            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.green,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed: () {

                  double? highPrice;
                  double? lowPrice;

                  if (enableHigh &&
                      highController
                          .text
                          .isNotEmpty) {

                    highPrice =
                        double.tryParse(
                      highController.text,
                    );
                  }

                  if (enableLow &&
                      lowController
                          .text
                          .isNotEmpty) {

                    lowPrice =
                        double.tryParse(
                      lowController.text,
                    );
                  }

                  final alert =
                      AlertModel(

                    symbol:
                        widget.symbol,

                    highPrice:
                        highPrice,

                    highEnabled:
                        enableHigh,

                    lowPrice:
                        lowPrice,

                    lowEnabled:
                        enableLow,
                  );

                  Navigator.pop(
                    context,
                    alert,
                  );
                },

                child: const Text(

                  'Salvar Alertas',

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}