import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget(
      {super.key,
      required this.currentCost,
      required this.futureCost,
      required this.costIncrease});

  final double futureCost;
  final double currentCost;
  final String costIncrease;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dagens räntekostnad / månad: '),
              Text(
                '${currentCost.toStringAsFixed(0)} kr',
                style: const TextStyle(fontSize: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kommande räntekostnad / månad: '),
              Text(
                '${futureCost.toStringAsFixed(0)} kr',
                style: const TextStyle(fontSize: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Förändring / månad: '),
              Text(
                costIncrease,
                style: const TextStyle(fontSize: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
