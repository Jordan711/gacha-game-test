import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gacha Battler')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
