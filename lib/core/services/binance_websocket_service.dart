import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService {

  WebSocketChannel? _channel;

  void connect({

    required String symbol,

    required Function(double)
        onPriceUpdate,

  }) {

    disconnect();

    final streamName =
        symbol.toLowerCase();

    final url =
        'wss://stream.binance.com:9443/ws/$streamName@trade';

    _channel =
        WebSocketChannel.connect(
      Uri.parse(url),
    );

    _channel!.stream.listen(

      (message) {

        final data =
            jsonDecode(message);

        final price =
            double.parse(data['p']);

        onPriceUpdate(price);
      },

      onError: (error) {

        print(
          'WebSocket erro: $error',
        );
      },

      onDone: () {

        print(
          'WebSocket fechado',
        );
      },
    );
  }

  void disconnect() {

    _channel?.sink.close();
  }
}