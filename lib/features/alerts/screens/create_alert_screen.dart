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
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  // ==========================================
  // CONTROLLERS & ESTADOS
  // ==========================================
  final TextEditingController priceController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isHighType = true; // true = Alta (↑), false = Baixa (↓)
  
  // Listas de opções para os Dropdowns
  final List<String> soundOptions = ['som1.mp3', 'som2.mp3', 'som3.mp3', 'padrão'];
  final List<String> vibrationOptions = ['Curta', 'Longa', 'Contínua', 'Desativada'];

  String selectedSound = 'padrão';
  String selectedVibration = 'Curta';

  // ==========================================
  // FUNÇÃO AUXILIAR DE PRECISÃO
  // ==========================================
  String _formatPrice(double price) {
    if (price < 10) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  @override
  void initState() {
    super.initState();
    // Preenche com a precisão correta baseada no preço atual
    int decimals = widget.currentPrice < 10 ? 4 : 2;
    priceController.text = widget.currentPrice.toStringAsFixed(decimals);
  }

  @override
  void dispose() {
    priceController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUp = widget.changePercent >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // CABEÇALHO (Compacto estilo EUR/USD da imagem)
            // ==========================================
            Center(
              child: Column(
                children: [
                  Text(
                    widget.symbol,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatPrice(widget.currentPrice).replaceAll('\$', ''),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isUp ? Colors.green : Colors.red,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isUp ? '+' : ''}${widget.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: isUp ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // SEÇÃO: PREÇO DE ALERTA
            // ==========================================
            const Center(
              child: Text(
                'preço de alerta',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone decorativo esquerdo (Play/Moeda verde da imagem)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                // Input do Preço menor e elegante
                SizedBox(
                  width: 120,
                  height: 45,
                  child: TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      filled: true,
                      fillColor: const Color(0xFF1A1D24),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botão Seletor Alta/Baixa (Baseado no círculo azul da imagem)
                InkWell(
                  onTap: () {
                    setState(() {
                      isHighType = !isHighType;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isHighType ? Colors.green : Colors.red, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isHighType ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isHighType ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isHighType ? 'alta' : 'baixa',
                          style: TextStyle(
                            color: isHighType ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==========================================
            // DROPDOWN: SOM
            // ==========================================
            const Text('Som', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            _buildDropdown(
              icon: Icons.volume_up,
              value: selectedSound,
              items: soundOptions,
              onChanged: (val) => setState(() => selectedSound = val!),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // DROPDOWN: VIBRAÇÃO
            // ==========================================
            const Text('vibração', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            _buildDropdown(
              icon: Icons.vibration,
              value: selectedVibration,
              items: vibrationOptions,
              onChanged: (val) => setState(() => selectedVibration = val!),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // INPUT: MENSAGEM PERSONALIZADA
            // ==========================================
            const Text('Mensagem', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLength: 200,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem personalizada aqui...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFF1A1D24),
                counterStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // BOTÃO: CRIAR ALERTA (Estilo Neon da Imagem)
            // ==========================================
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F1115),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    onPressed: () {
                      double? targetPrice = double.tryParse(priceController.text);

                      // Mapeia de volta para o AlertModel existente do app
                      final alert = AlertModel(
                        symbol: widget.symbol,
                        highPrice: isHighType ? targetPrice : null,
                        highEnabled: isHighType,
                        lowPrice: !isHighType ? targetPrice : null,
                        lowEnabled: !isHighType,
                      );

                      Navigator.pop(context, alert);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'criar alerta',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.add_alert, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para montar os Dropdowns compactos de forma padronizada
  Widget _buildDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: const Color(0xFF1A1D24),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(icon, color: Colors.white54, size: 18),
                const SizedBox(width: 12),
                Text(item),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}