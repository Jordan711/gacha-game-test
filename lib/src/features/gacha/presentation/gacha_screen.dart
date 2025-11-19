import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game/src/features/economy/data/gem_balance_provider.dart';
import 'package:game/src/features/economy/widgets/gem_balance_widget.dart';
import 'package:game/src/features/gacha/data/gacha_controller.dart';
import '../../characters/domain/character.dart';
import 'package:game/src/core/theme/rarity_colors.dart';

class GachaScreen extends ConsumerStatefulWidget {
  const GachaScreen({super.key});

  @override
  ConsumerState<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends ConsumerState<GachaScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gemBalance = ref.watch(gemBalanceProvider);
    final gachaState = ref.watch(gachaControllerProvider);

    // Listen for summon completion to play sound
    ref.listen(gachaControllerProvider, (previous, next) {
      if (previous?.isSummoning == true &&
          next.isSummoning == false &&
          next.lastSummoned != null) {
        _audioPlayer.play(AssetSource('audio/applause01.ogg'));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Summon Gate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GemBalanceWidget(),
            const SizedBox(height: 20),
            if (gachaState.isSummoning)
              const CircularProgressIndicator()
            else if (gachaState.lastSummoned != null)
              _buildSummonResult(gachaState.lastSummoned!)
            else
              const Text(
                'Tap to Summon!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: gachaState.isSummoning
                  ? null
                  : () {
                      if (gemBalance < 100) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not enough gems!')),
                        );
                        return;
                      }
                      ref.read(gachaControllerProvider.notifier).summon();
                    },
              child: const Text('Summon (100 Gems)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummonResult(Character character) {
    final Color rarityColor = rarityColors[character.rarity] ?? Colors.grey;

    return Card(
      color: rarityColor.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              character.rarity.name.toUpperCase(),
              style: TextStyle(
                color: rarityColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/characters/${character.name.toLowerCase()}.png',
              height: 250,
            ),
            const SizedBox(height: 10),
            Text(
              character.name,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStat('ATK', character.attack),
                const SizedBox(width: 20),
                _buildStat('DEF', character.defense),
                const SizedBox(width: 20),
                _buildStat('HP', character.hp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
