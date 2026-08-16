import 'package:flutter/material.dart';

/// Widget responsável pela seleção do tempo gráfico (1m, 5m, 15m, 1h, 1D, 1S)
class TimeframeSelector extends StatelessWidget {
  final String selectedTimeframe;
  final ValueChanged<String> onSelect;

  const TimeframeSelector({
    Key? key,
    required this.selectedTimeframe,
    required this.onSelect,
  }) : super(key: key);

  static const List<String> timeframes = ['1m', '5m', '15m', '1h', '1D', '1S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151822),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1F2433), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com ícone de relógio e título
          Row(
            children: const [
              Icon(Icons.access_time, color: Color(0xFF2F7CFF), size: 18),
              SizedBox(width: 8),
              Text(
                'Tempo gráfico',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Grade 3x2 com as opções de tempo gráfico
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: timeframes.length,
            itemBuilder: (context, index) {
              final tf = timeframes[index];
              final isSelected = selectedTimeframe == tf;

              return GestureDetector(
                onTap: () => onSelect(tf),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2F7CFF)
                        : const Color(0xFF1D212F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2F7CFF)
                          : const Color(0xFF2A3044),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2F7CFF).withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tf,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF8E93A6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}