import 'package:flutter/material.dart';
import 'package:alertxpro_app/data/models/alert_model.dart';

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
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  String alertType = "up";

  @override
  Widget build(BuildContext context) {
    final isUp = widget.changePercent >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B0F1A),
              Color(0xFF111827),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      widget.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 20),

                /// PREÇO
                Text(
                  widget.currentPrice.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// VARIAÇÃO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isUp ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${isUp ? "+" : ""}${widget.changePercent.toStringAsFixed(2)}%",
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Preço de alerta",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 12),

                /// INPUT
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.03),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Digite o preço",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => alertType = "up"),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_upward,
                                color: alertType == "up"
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => alertType = "down"),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_downward,
                                color: alertType == "down"
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// MENSAGEM
                TextField(
                  controller: messageController,
                  maxLength: 200,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Mensagem opcional...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const Spacer(),

                /// BOTÃO CRIAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      final text = priceController.text;

                      if (text.isEmpty) return;

                      final price = double.tryParse(text);
                      if (price == null) return;

                      final alert = AlertModel(
                        symbol: widget.symbol,
                        targetPrice: price,
                        type: alertType,
                      );

                      Navigator.pop(context, alert);
                    },
                    child: const Text(
                      "Criar alerta",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}