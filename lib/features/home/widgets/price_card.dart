import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {

  final String symbol;
  final double price;
  final double dailyChange;

  const PriceCard({
    super.key,
    required this.symbol,
    required this.price,
    required this.dailyChange,
  });

  @override
  Widget build(BuildContext context) {

    final isPositive = dailyChange >= 0;

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        children: [

          Text(
            symbol,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '\$ ${price.toStringAsFixed(2)}',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Icon(
                isPositive
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,

                color:
                    isPositive
                        ? Colors.green
                        : Colors.red,
              ),

              const SizedBox(width: 6),

              Text(
                '${dailyChange.toStringAsFixed(2)}%',

                style: TextStyle(
                  color:
                      isPositive
                          ? Colors.green
                          : Colors.red,

                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}