import 'package:flutter/material.dart';
import '../models/pattern_alert.dart';

/// Widget responsável por exibir a lista horizontal de pares de criptomoedas / mercados
/// onde o usuário pode selecionar em quais ativos deseja receber os alertas de padrões.
class MarketSelector extends StatelessWidget {
  final List<CryptoMarketItem> markets;
  final ValueChanged<int> onToggle;
  final VoidCallback? onAddMarketPressed;

  const MarketSelector({
    Key? key,
    required this.markets,
    required this.onToggle,
    this.onAddMarketPressed,
  }) : super(key: key);

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
          // Cabeçalho da Seção com Ícone de Globo e Ação Adicional
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.language, color: Color(0xFF2F7CFF), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Mercados',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Botão opcional para buscar/adicionar mais pares
              if (onAddMarketPressed != null)
                GestureDetector(
                  onTap: onAddMarketPressed,
                  child: const Text(
                    '+ Adicionar',
                    style: TextStyle(
                      color: Color(0xFF2F7CFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(markets.length, (index) {
                final market = markets[index];
                return _buildMarketCard(
                  market: market,
                  onTap: () => onToggle(index),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o card individual de cada moeda com efeito de estado ativo/inativo
  Widget _buildMarketCard({
    required CryptoMarketItem market,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 10),
        width: 86,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: market.isSelected
              ? const Color(0xFF182238)
              : const Color(0xFF1D212F),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: market.isSelected
                ? const Color(0xFF2F7CFF)
                : const Color(0xFF2A3044),
            width: market.isSelected ? 1.5 : 1.0,
          ),
          boxShadow: market.isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2F7CFF).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone da Criptomoeda com Cor da Marca
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: market.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: market.color.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                market.iconLetter,
                style: TextStyle(
                  color: (market.color == const Color(0xFF14F195) ||
                          market.color == const Color(0xFFF3BA2F))
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Símbolo do Par (ex: BTCUSDT)
            Text(
              market.symbol,
              style: TextStyle(
                color: market.isSelected
                    ? Colors.white
                    : const Color(0xFF8E93A6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),

            // Ícone de Seleção Check Azul
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: market.isSelected
                    ? const Color(0xFF2F7CFF)
                    : const Color(0xFF272C3D),
                shape: BoxShape.circle,
              ),
              child: market.isSelected
                  ? const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}