import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/economy/data/gem_balance_provider.dart';
import 'package:game/src/features/economy/widgets/gem_balance_widget.dart';

class PurchaseGemsScreen extends ConsumerStatefulWidget {
  const PurchaseGemsScreen({super.key});

  @override
  ConsumerState<PurchaseGemsScreen> createState() => _PurchaseGemsScreenState();
}

class _PurchaseGemsScreenState extends ConsumerState<PurchaseGemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Gems')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GemBalanceWidget(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(gemBalanceProvider.notifier).add(100);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('100 gems purchased!')),
                );
              },
              child: const Text('Purchase Gems'),
            ),
          ],
        ),
      ),
    );
  }
}
