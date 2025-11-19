import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/economy/data/gem_balance_provider.dart';

class GemBalanceWidget extends ConsumerWidget {
  const GemBalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gemBalance = ref.watch(gemBalanceProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.diamond, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '$gemBalance',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
