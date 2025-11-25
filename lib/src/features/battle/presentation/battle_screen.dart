import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/battle/data/battle_controller.dart';
import '../../characters/data/character_list_provider.dart';
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
    // Initialize or reset battle state when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final characterList = ref.read(characterListProvider);
      if (characterList.isNotEmpty) {
        ref
            .read(battleControllerProvider.notifier)
            .initializeBattle(characterList);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showBattleResult(bool victory, String enemyName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(victory ? 'Victory!' : 'Defeat!'),
        content: Text(
          victory
              ? 'You defeated the $enemyName!'
              : 'You were defeated by the $enemyName...',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              final characterList = ref.read(characterListProvider);
              ref
                  .read(battleControllerProvider.notifier)
                  .initializeBattle(characterList);
            },
            child: const Text('Fight new monster'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Leave Arena'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterList = ref.watch(characterListProvider);
    final battleState = ref.watch(battleControllerProvider);

    // Listen for battle end
    ref.listen(battleControllerProvider, (previous, next) {
      if (previous?.battleEnded == false && next.battleEnded == true) {
        final victory = next.enemyHp <= 0;
        _showBattleResult(victory, next.enemyCharacter?.name ?? 'Enemy');
      }
      // Play sound on player attack
      if (previous?.isPlayerTurn == true && next.isPlayerTurn == false) {
        _audioPlayer.play(AssetSource('audio/clap03.ogg'));
      }
    });

    if (characterList.isEmpty) {
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

    // Show loading while initializing
    if (battleState.playerCharacter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Battle Arena')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _buildCharacterCard(
                battleState.enemyCharacter!,
                hp: battleState.enemyHp,
                maxHp: battleState.enemyMaxHp,
                isEnemy: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              battleState.battleLog,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _buildCharacterCard(
                battleState.playerCharacter!,
                hp: battleState.playerHp,
                maxHp: battleState.playerMaxHp,
                isEnemy: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (battleState.isPlayerTurn && !battleState.battleEnded)
                    ? () => ref
                          .read(battleControllerProvider.notifier)
                          .playerAttack()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  battleState.isPlayerTurn ? 'ATTACK' : 'ENEMY TURN...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(
    Character character, {
    required int hp,
    required int maxHp,
    required bool isEnemy,
  }) {
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
            const SizedBox(height: 4),
            Text(
              'ATK: ${character.attack} | DEF: ${character.defense}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            // Health Bar
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: maxHp > 0 ? hp / maxHp : 0,
                    backgroundColor: Colors.black26,
                    color: isEnemy ? Colors.red : Colors.green,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$hp / $maxHp HP',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
