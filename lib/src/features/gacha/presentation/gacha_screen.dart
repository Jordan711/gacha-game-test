import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../characters/domain/character.dart';
import '../../characters/data/inventory_provider.dart';

class GachaScreen extends ConsumerStatefulWidget {
  const GachaScreen({super.key});

  @override
  ConsumerState<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends ConsumerState<GachaScreen> {
  Character? _lastSummoned;
  bool _isSummoning = false;
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

  void _summon() async {
    setState(() {
      _isSummoning = true;
      _lastSummoned = null;
    });

    // Simulate network/animation delay
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final rarity = Rarity.values[random.nextInt(Rarity.values.length)];
    final names = ['Warrior', 'Mage', 'Archer', 'Rogue', 'Paladin'];
    final name = names[random.nextInt(names.length)];

    final newCharacter = Character.random(name, rarity);

    ref.read(inventoryProvider.notifier).addCharacter(newCharacter);

    if (mounted) {
      await _audioPlayer.play(AssetSource('audio/applause01.ogg'));
      setState(() {
        _isSummoning = false;
        _lastSummoned = newCharacter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summon Gate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSummoning)
              const CircularProgressIndicator()
            else if (_lastSummoned != null)
              _buildSummonResult(_lastSummoned!)
            else
              const Text(
                'Tap to Summon!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSummoning ? null : _summon,
              child: const Text('Summon (100 Gems)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummonResult(Character character) {
    Color rarityColor;
    switch (character.rarity) {
      case Rarity.common:
        rarityColor = Colors.grey;
        break;
      case Rarity.rare:
        rarityColor = Colors.blue;
        break;
      case Rarity.epic:
        rarityColor = Colors.purple;
        break;
      case Rarity.legendary:
        rarityColor = Colors.orange;
        break;
    }

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
