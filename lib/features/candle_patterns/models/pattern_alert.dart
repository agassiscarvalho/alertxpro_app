import 'package:flutter/material.dart';

/// Categorias dos padrões de candle
enum PatternCategory {
  reversao,
  continuacao,
}

/// Modelo individual para cada Padrão de Candle
class CandlePatternItem {
  final String id;
  final String name;
  final bool isBullish; // true = Alta (Verde), false = Baixa (Vermelho)
  final PatternCategory category;
  bool isEnabled;

  CandlePatternItem({
    required this.id,
    required this.name,
    required this.isBullish,
    required this.category,
    this.isEnabled = false,
  });

  /// Converte o objeto para Map (para salvar em JSON ou Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isBullish': isBullish,
      'category': category.name,
      'isEnabled': isEnabled,
    };
  }

  /// Cria um objeto a partir de um Map
  factory CandlePatternItem.fromJson(Map<String, dynamic> json) {
    return CandlePatternItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isBullish: json['isBullish'] ?? true,
      category: json['category'] == 'continuacao'
          ? PatternCategory.continuacao
          : PatternCategory.reversao,
      isEnabled: json['isEnabled'] ?? false,
    );
  }
}

/// Modelo para os pares de mercado (BTCUSDT, ETHUSDT, etc.)
class CryptoMarketItem {
  final String symbol;
  final String name;
  final Color color;
  final String iconLetter;
  bool isSelected;

  CryptoMarketItem({
    required this.symbol,
    required this.name,
    required this.color,
    required this.iconLetter,
    this.isSelected = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'isSelected': isSelected,
    };
  }

  factory CryptoMarketItem.fromJson(Map<String, dynamic> json, Color color, String iconLetter) {
    return CryptoMarketItem(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      color: color,
      iconLetter: iconLetter,
      isSelected: json['isSelected'] ?? true,
    );
  }
}

/// Modelo principal de Configuração do Alerta de Padrão
class PatternAlert {
  String? id;
  String selectedTimeframe;
  List<CandlePatternItem> patterns;
  List<CryptoMarketItem> markets;
  bool isActive;

  PatternAlert({
    this.id,
    required this.selectedTimeframe,
    required this.patterns,
    required this.markets,
    this.isActive = true,
  });

  /// Lista Padrão Inicial com os dados idênticos à tela da imagem
  static PatternAlert defaultInitial() {
    return PatternAlert(
      selectedTimeframe: '1m',
      patterns: [
        // --- PADRÕES DE REVERSÃO ---
        CandlePatternItem(
          id: 'engolfo_alta',
          name: 'Engolfo de Alta',
          isBullish: true,
          category: PatternCategory.reversao,
          isEnabled: true,
        ),
        CandlePatternItem(
          id: 'engolfo_baixa',
          name: 'Engolfo de Baixa',
          isBullish: false,
          category: PatternCategory.reversao,
          isEnabled: false,
        ),
        CandlePatternItem(
          id: 'martelo',
          name: 'Martelo',
          isBullish: true,
          category: PatternCategory.reversao,
          isEnabled: true,
        ),
        CandlePatternItem(
          id: 'martelo_invertido',
          name: 'Martelo Invertido',
          isBullish: true,
          category: PatternCategory.reversao,
          isEnabled: false,
        ),
        CandlePatternItem(
          id: 'estrela_manha',
          name: 'Estrela da Manhã',
          isBullish: true,
          category: PatternCategory.reversao,
          isEnabled: true,
        ),
        CandlePatternItem(
          id: 'estrela_noite',
          name: 'Estrela da Noite',
          isBullish: false,
          category: PatternCategory.reversao,
          isEnabled: false,
        ),

        // --- PADRÕES DE CONTINUAÇÃO ---
        CandlePatternItem(
          id: 'marubozu_alta',
          name: 'Marubozu de Alta',
          isBullish: true,
          category: PatternCategory.continuacao,
          isEnabled: true,
        ),
        CandlePatternItem(
          id: 'marubozu_baixa',
          name: 'Marubozu de Baixa',
          isBullish: false,
          category: PatternCategory.continuacao,
          isEnabled: false,
        ),
        CandlePatternItem(
          id: 'tres_soldados',
          name: 'Três Soldados Brancos',
          isBullish: true,
          category: PatternCategory.continuacao,
          isEnabled: false,
        ),
        CandlePatternItem(
          id: 'tres_corvos',
          name: 'Três Corvos Negros',
          isBullish: false,
          category: PatternCategory.continuacao,
          isEnabled: false,
        ),
      ],
      markets: [
        CryptoMarketItem(
          symbol: 'BTCUSDT',
          name: 'Bitcoin',
          color: const Color(0xFFF7931A),
          iconLetter: '₿',
          isSelected: true,
        ),
        CryptoMarketItem(
          symbol: 'ETHUSDT',
          name: 'Ethereum',
          color: const Color(0xFF627EEA),
          iconLetter: 'Ξ',
          isSelected: true,
        ),
        CryptoMarketItem(
          symbol: 'SOLUSDT',
          name: 'Solana',
          color: const Color(0xFF14F195),
          iconLetter: 'S',
          isSelected: true,
        ),
        CryptoMarketItem(
          symbol: 'XRPUSDT',
          name: 'Ripple',
          color: const Color(0xFF23292F),
          iconLetter: '✕',
          isSelected: true,
        ),
        CryptoMarketItem(
          symbol: 'BNBUSDT',
          name: 'BNB',
          color: const Color(0xFFF3BA2F),
          iconLetter: 'B',
          isSelected: true,
        ),
      ],
    );
  }

  /// Converte para Map completo para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selectedTimeframe': selectedTimeframe,
      'patterns': patterns.map((p) => p.toJson()).toList(),
      'markets': markets.map((m) => m.toJson()).toList(),
      'isActive': isActive,
    };
  }
}