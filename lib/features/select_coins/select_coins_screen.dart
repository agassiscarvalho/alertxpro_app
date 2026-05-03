import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCoinsScreen extends StatefulWidget {
  const SelectCoinsScreen({super.key});

  @override
  State<SelectCoinsScreen> createState() => _SelectCoinsScreenState();
}

class _SelectCoinsScreenState extends State<SelectCoinsScreen> {

  final List<String> allCoins = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'SOLUSDT',
    'XRPUSDT',
  ];

  List<String> selectedCoins = [];

  @override
  void initState() {
    super.initState();
    loadCoins();
  }

  Future<void> loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCoins = prefs.getStringList('coins') ?? [];
    });
  }

  Future<void> saveCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('coins', selectedCoins);
  }

  void toggleCoin(String coin) {
    setState(() {
      if (selectedCoins.contains(coin)) {
        selectedCoins.remove(coin);
      } else {
        selectedCoins.add(coin);
      }
    });
    saveCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Moedas'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: allCoins.length,
        itemBuilder: (context, index) {
          final coin = allCoins[index];
          final isSelected = selectedCoins.contains(coin);

          return ListTile(
            title: Text(
              coin,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (_) => toggleCoin(coin),
            ),
            onTap: () => toggleCoin(coin),
          );
        },
      ),
    );
  }
}