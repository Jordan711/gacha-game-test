import 'package:flutter/material.dart';
import 'package:game/src/features/economy/widgets/gem_balance_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GemBalanceWidget(),
            const SizedBox(height: 12),
            Image.asset('assets/images/game_banner.png', height: 200),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              title: 'Summon Characters',
              icon: Icons.star,
              color: Colors.purple,
              onTap: () => context.push('/gacha'),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              title: 'Characters',
              icon: Icons.people,
              color: Colors.yellow,
              onTap: () => context.push('/characters'),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              title: 'Battle Arena',
              icon: Icons.sports_kabaddi,
              color: Colors.red,
              onTap: () => context.push('/battle'),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              title: 'Inventory',
              icon: Icons.inventory,
              color: Colors.blue,
              onTap: () {
                // TODO: Implement inventory screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inventory coming soon!')),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              title: 'Purchase Gems',
              icon: Icons.diamond,
              color: Colors.green,
              onTap: () => context.push('/purchase_gems'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
