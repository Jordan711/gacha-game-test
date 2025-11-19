import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/data/inventory_provider.dart';
import '../../characters/domain/character.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
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
    final inventory = ref.watch(inventoryProvider);

    if (inventory.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Battle Arena')),
        body: const Center(
          child: Text(
            'You need at least one character to battle!\nGo to Summon Gate first.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Pick the strongest character for battle
    final myCharacter = inventory.reduce(
      (curr, next) => curr.attack > next.attack ? curr : next,
    );
    final enemy = Character.random('Monster', Rarity.epic);

    return Scaffold(
      appBar: AppBar(title: const Text('Battle Arena')),
      body: Column(
        children: [
          Expanded(
            child: Center(child: _buildCharacterCard(enemy, isEnemy: true)),
          ),
          const Text(
            'VS',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Expanded(
            child: Center(
              child: _buildCharacterCard(myCharacter, isEnemy: false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _audioPlayer.play(AssetSource('audio/clap03.ogg'));
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Battle Result'),
                      content: Text(
                        myCharacter.attack > enemy.defense
                            ? 'Victory! You dealt ${myCharacter.attack} damage.'
                            : 'Defeat! Enemy defense was too high.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('FIGHT!'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(Character character, {required bool isEnemy}) {
    return Card(
      color: isEnemy
          ? Colors.red.withValues(alpha: 0.2)
          : Colors.blue.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEnemy ? 'ENEMY' : 'YOU',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/images/characters/${character.name.toLowerCase()}.png',
              height: 100,
            ),
            const SizedBox(height: 8),
            Text(character.name, style: const TextStyle(fontSize: 24)),
            Text(
              'ATK: ${character.attack} | DEF: ${character.defense} | HP: ${character.hp}',
            ),
          ],
        ),
      ),
    );
  }
}
