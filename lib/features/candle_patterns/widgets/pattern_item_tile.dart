import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/pattern_alert.dart';

/// Widget responsável por exibir cada item da lista de Padrões de Candle
/// com ícone gráfico desenhado via CustomPainter e comutador Switch iOS.
class PatternItemTile extends StatelessWidget {
  final CandlePatternItem pattern;
  final ValueChanged<bool> onChanged;

  const PatternItemTile({
    Key? key,
    required this.pattern,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cor do gráfico baseada na tendência do padrão (Verde para Alta, Vermelho para Baixa)
    final Color iconColor = pattern.isBullish
        ? const Color(0xFF00C853)
        : const Color(0xFFFF3B30);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ícone e Nome do Padrão
          Row(
            children: [
              _buildCandleIcon(pattern.id, iconColor),
              const SizedBox(width: 12),
              Text(
                pattern.name,
                style: const TextStyle(
                  color: Color(0xFFE2E4EB),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Botão Switch estilo iOS / Cupertino
          CupertinoSwitch(
            activeColor: const Color(0xFF2F7CFF),
            trackColor: const Color(0xFF272C3D),
            value: pattern.isEnabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Gera a área de pintura personalizada do ícone do candle
  Widget _buildCandleIcon(String patternId, Color color) {
    return SizedBox(
      width: 24,
      height: 28,
      child: CustomPaint(
        painter: CandlePainter(patternId: patternId, mainColor: color),
      ),
    );
  }
}

/// Painter customizado para desenhar as representações fieis das velas de cada padrão
class CandlePainter extends CustomPainter {
  final String patternId;
  final Color mainColor;

  CandlePainter({
    required this.patternId,
    required this.mainColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = mainColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final redPaint = Paint()
      ..color = const Color(0xFFFF3B30)
      ..style = PaintingStyle.fill;

    final greenPaint = Paint()
      ..color = const Color(0xFF00C853)
      ..style = PaintingStyle.fill;

    // --- 1. ENGOLFO (Duas velas: 1 menor, 1 maior que engloba a anterior) ---
    if (patternId.contains('engolfo')) {
      // Primeira vela pequena
      canvas.drawLine(const Offset(4, 6), const Offset(4, 20), strokePaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(2, 9, 4, 9),
          const Radius.circular(1),
        ),
        paint,
      );

      // Segunda vela engolfando
      canvas.drawLine(const Offset(14, 2), const Offset(14, 24), strokePaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(11, 4, 6, 17),
          const Radius.circular(1),
        ),
        paint,
      );
    }
    // --- 2. MARTELO / MARTELO INVERTIDO (Corpo pequeno com pavio longo) ---
    else if (patternId.contains('martelo')) {
      canvas.drawLine(const Offset(12, 2), const Offset(12, 24), strokePaint);
      if (patternId == 'martelo') {
        // Martelo Tradicional (Corpo no topo, sombra/pavio longo abaixo)
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(8, 4, 8, 7),
            const Radius.circular(1),
          ),
          paint,
        );
      } else {
        // Martelo Invertido (Corpo na base, sombra/pavio longo acima)
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(8, 15, 8, 7),
            const Radius.circular(1),
          ),
          paint,
        );
      }
    }
    // --- 3. ESTRELA (Manhã / Noite: Conjunto de 3 velas) ---
    else if (patternId.contains('estrela')) {
      final isManha = patternId == 'estrela_manha';
      // Vela 1
      canvas.drawRect(
        const Rect.fromLTWH(2, 4, 4, 12),
        isManha ? redPaint : greenPaint,
      );
      // Vela 2 (Doji/pequena no fundo ou topo)
      canvas.drawRect(
        const Rect.fromLTWH(9, 16, 4, 4),
        isManha ? greenPaint : redPaint,
      );
      // Vela 3
      canvas.drawRect(
        const Rect.fromLTWH(16, 6, 4, 14),
        isManha ? greenPaint : redPaint,
      );
    }
    // --- 4. MARUBOZU (Vela cheia, sem sombra/pavio) ---
    else if (patternId.contains('marubozu')) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(7, 2, 10, 24),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    // --- 5. TRÊS SOLDADOS BRANCOS / CORVOS NEGROS (Sequência de 3 velas) ---
    else if (patternId.contains('tres_')) {
      final isUp = patternId == 'tres_soldados';
      final p = isUp ? greenPaint : redPaint;

      canvas.drawRect(Rect.fromLTWH(2, isUp ? 14 : 2, 4, 8), p);
      canvas.drawRect(const Rect.fromLTWH(9, 8, 4, 10), p);
      canvas.drawRect(Rect.fromLTWH(16, isUp ? 2 : 12, 4, 10), p);
    }
    // --- 6. ÍCONE GENÉRICO DE CANDLE (Fallback) ---
    else {
      canvas.drawLine(const Offset(12, 2), const Offset(12, 24), strokePaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(8, 6, 8, 12),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}