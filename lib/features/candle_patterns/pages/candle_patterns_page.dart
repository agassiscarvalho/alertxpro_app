import 'package:flutter/material.dart';
import '../features/candle_patterns/models/pattern_alert.dart';
import '../features/candle_patterns/widgets/timeframe_selector.dart';
import '../features/candle_patterns/widgets/pattern_item_tile.dart';
import '../features/candle_patterns/widgets/market_selector.dart';

/// Parte 5: Tela principal (Page) reunindo todas as partes da funcionalidade.
/// Gerencia o estado dos alertas de padrões de candle, tempo gráfico e seleção de mercados.
class CandlePatternsPage extends StatefulWidget {
  const CandlePatternsPage({Key? key}) : super(key: key);

  @override
  State<CandlePatternsPage> createState() => _CandlePatternsPageState();
}

class _CandlePatternsPageState extends State<CandlePatternsPage> {
  late PatternAlert _alertConfig;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Carrega as configurações padrões
    _alertConfig = PatternAlert.defaultInitial();
  }

  /// Atualiza a escolha do tempo gráfico
  void _onTimeframeChanged(String timeframe) {
    setState(() {
      _alertConfig.selectedTimeframe = timeframe;
    });
  }

  /// Ativa/desativa um padrão individual de candle
  void _onPatternToggled(CandlePatternItem pattern, bool isEnabled) {
    setState(() {
      pattern.isEnabled = isEnabled;
    });
  }

  /// Alterna a seleção de um par de moeda/criptomoeda
  void _onMarketToggled(int index) {
    setState(() {
      _alertConfig.markets[index].isSelected =
          !_alertConfig.markets[index].isSelected;
    });
  }

  /// Exibe caixa de diálogo para inclusão de novos pares
  void _showAddMarketDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151822),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1F2433)),
        ),
        title: Row(
          children: const [
            Icon(Icons.add_chart, color: Color(0xFF2F7CFF), size: 20),
            SizedBox(width: 8),
            Text(
              'Adicionar Mercado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite o símbolo do par (ex: LINKUSDT):',
              style: TextStyle(color: Color(0xFF8E93A6), fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1D212F),
                hintText: 'Símbolo do par',
                hintStyle: const TextStyle(color: Color(0xFF53586B)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A3044)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2F7CFF)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF8E93A6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F7CFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final symbol = textController.text.trim().toUpperCase();
              if (symbol.isNotEmpty) {
                setState(() {
                  _alertConfig.markets.add(
                    CryptoMarketItem(
                      symbol: symbol,
                      name: symbol,
                      color: const Color(0xFF2F7CFF),
                      iconLetter: symbol[0],
                      isSelected: true,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Adicionar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Salva as configurações com animação e feedback visual
  Future<void> _saveConfiguration() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSaving = false);

    final activePatterns =
        _alertConfig.patterns.where((p) => p.isEnabled).length;
    final selectedMarkets =
        _alertConfig.markets.where((m) => m.isSelected).length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF182238),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF2F7CFF), width: 1.5),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF2F7CFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuração Salva!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'TF: ${_alertConfig.selectedTimeframe} • $activePatterns padrões • $selectedMarkets mercados',
                    style: const TextStyle(color: Color(0xFF8E93A6), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtra os padrões entre reversão e continuação
    final reversaoPatterns = _alertConfig.patterns
        .where((p) => p.category == PatternCategory.reversao)
        .toList();

    final continuacaoPatterns = _alertConfig.patterns
        .where((p) => p.category == PatternCategory.continuacao)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1017),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Alertas de Padrões',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Configure notificações para padrões de candles.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7E8497),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 1. Tempo Gráfico
                  TimeframeSelector(
                    selectedTimeframe: _alertConfig.selectedTimeframe,
                    onSelect: _onTimeframeChanged,
                  ),
                  const SizedBox(height: 16),

                  // 2. Padrões de Reversão
                  _buildSectionCard(
                    title: 'Padrões de Reversão',
                    icon: Icons.show_chart,
                    child: Column(
                      children: reversaoPatterns.map((pattern) {
                        return PatternItemTile(
                          pattern: pattern,
                          onChanged: (val) => _onPatternToggled(pattern, val),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Padrões de Continuação
                  _buildSectionCard(
                    title: 'Padrões de Continuação',
                    icon: Icons.trending_up,
                    child: Column(
                      children: continuacaoPatterns.map((pattern) {
                        return PatternItemTile(
                          pattern: pattern,
                          onChanged: (val) => _onPatternToggled(pattern, val),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Mercados
                  MarketSelector(
                    markets: _alertConfig.markets,
                    onToggle: _onMarketToggled,
                    onAddMarketPressed: _showAddMarketDialog,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Botão Fixo Inferior
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF0E1017),
                border: Border(
                  top: BorderSide(color: Color(0xFF191C28), width: 1),
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F7CFF),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF2F7CFF).withOpacity(0.4),
                ),
                onPressed: _isSaving ? null : _saveConfiguration,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.save_outlined, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Salvar Configuração',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151822),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1F2433), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2F7CFF), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}