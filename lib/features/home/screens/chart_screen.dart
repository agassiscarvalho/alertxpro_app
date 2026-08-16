import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  InAppWebViewController? webViewController;
  String selectedSymbol = 'BTCUSDT';
  String selectedInterval = '1h';

  final List<String> symbols = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'XRPUSDT', 'BNBUSDT'];
  final List<String> intervals = ['1m', '5m', '15m', '1h', '4h', '1D'];

  // Opções para garantir que o TradingView carregue corretamente no celular
  final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    useWideViewPort: true,
    loadWithOverviewMode: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
  );

  String _generateTradingViewHtml(String symbol, String interval) {
    // Mapeia o intervalo pro formato aceito pelo TradingView
    String tf = '60';
    if (interval == '1m') tf = '1';
    if (interval == '5m') tf = '5';
    if (interval == '15m') tf = '15';
    if (interval == '1h') tf = '60';
    if (interval == '4h') tf = '240';
    if (interval == '1D') tf = 'D';

    final formattedSymbol = 'BINANCE:$symbol';

    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #0D1424;
            overflow: hidden;
          }
          #tradingview_widget {
            width: 100%;
            height: 100%;
          }
        </style>
      </head>
      <body>
        <div id="tradingview_widget"></div>
        <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
        <script type="text/javascript">
          new TradingView.widget({
            "autosize": true,
            "symbol": "$formattedSymbol",
            "interval": "$tf",
            "timezone": "Etc/UTC",
            "theme": "dark",
            "style": "1",
            "locale": "br",
            "toolbar_bg": "#0D1424",
            "enable_publishing": false,
            "hide_top_toolbar": false,
            "hide_legend": false,
            "save_image": false,
            "container_id": "tradingview_widget",
            "studies": [
              "RSI@tv-basicstudies",
              "MACD@tv-basicstudies"
            ]
          });
        </script>
      </body>
    </html>
    ''';
  }

  void _reloadChart() {
    if (webViewController != null) {
      webViewController!.loadData(
        data: _generateTradingViewHtml(selectedSymbol, selectedInterval),
        baseUrl: WebUri("https://s3.tradingview.com"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1424),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1424),
        elevation: 0,
        title: const Text(
          'Gráfico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // BARRA SUPERIOR COM ROLAGEM (Resolve o erro de Overflow!)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF161F33),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Dropdown do Ativo
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF161F33),
                    value: selectedSymbol,
                    underline: const SizedBox(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    items: symbols.map((symbol) {
                      return DropdownMenuItem(value: symbol, child: Text(symbol));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSymbol = value;
                        });
                        _reloadChart();
                      }
                    },
                  ),
                  const SizedBox(width: 16),

                  // Botões de Timeframe (1m, 5m, 15m, 1h, etc)
                  Row(
                    children: intervals.map((tf) {
                      final isSelected = selectedInterval == tf;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedInterval = tf;
                            });
                            _reloadChart();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue.shade600
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tf,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // ÁREA DO GRÁFICO
          Expanded(
            child: InAppWebView(
              initialSettings: _settings,
              initialData: InAppWebViewInitialData(
                data: _generateTradingViewHtml(selectedSymbol, selectedInterval),
                baseUrl: WebUri("https://s3.tradingview.com"),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}