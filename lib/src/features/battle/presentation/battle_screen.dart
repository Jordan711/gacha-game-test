import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/data/character_list_provider.dart';
import '../../characters/domain/character.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  late final AudioPlayer _audioPlayer;

  Character? _playerCharacter;
  Character? _enemyCharacter;
  int _playerHp = 0;
  int _enemyHp = 0;
  int _playerMaxHp = 1;
  int _enemyMaxHp = 1;
  bool _isPlayerTurn = true;
  String _battleLog = 'Battle Start!';
  bool _battleEnded = false;

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

  void _initializeBattle(List<Character> inventory) {
    if (_playerCharacter != null) return;

    // Pick the strongest character for battle
    _playerCharacter = inventory.reduce(
      (curr, next) => curr.attack > next.attack ? curr : next,
    );
    _enemyCharacter = Character.random('Monster', Rarity.epic);

    _playerHp = _playerCharacter!.hp;
    _playerMaxHp = _playerCharacter!.hp;
    _enemyHp = _enemyCharacter!.hp;
    _enemyMaxHp = _enemyCharacter!.hp;
    _isPlayerTurn = true;
    _battleEnded = false;
    _battleLog = 'A wild ${_enemyCharacter!.name} appeared!';
  }

  Future<void> _playerAttack() async {
    if (!_isPlayerTurn || _battleEnded) return;

    await _audioPlayer.play(AssetSource('audio/clap03.ogg'));

    setState(() {
      final damage = _calculateDamage(_playerCharacter!, _enemyCharacter!);
      _enemyHp = (_enemyHp - damage).clamp(0, _enemyMaxHp);
      _battleLog = 'You dealt $damage damage!';
      _isPlayerTurn = false;
    });

    _checkBattleEnd();

    if (!_battleEnded) {
      Future.delayed(const Duration(seconds: 1), _enemyAttack);
    }
  }

  Future<void> _enemyAttack() async {
    if (_battleEnded) return;

    setState(() {
      final damage = _calculateDamage(_enemyCharacter!, _playerCharacter!);
      _playerHp = (_playerHp - damage).clamp(0, _playerMaxHp);
      _battleLog = 'Enemy dealt $damage damage!';
      _isPlayerTurn = true;
    });

    _checkBattleEnd();
  }

  int _calculateDamage(Character attacker, Character defender) {
    // Damage = max(1, Attacker.ATK - Defender.DEF * 0.5)
    final damage = attacker.attack - (defender.defense * 0.5);
    return max(1, damage.toInt());
  }

  void _checkBattleEnd() {
    if (_enemyHp <= 0) {
      _battleEnded = true;
      _showBattleResult(true);
    } else if (_playerHp <= 0) {
      _battleEnded = true;
      _showBattleResult(false);
    }
  }

  void _showBattleResult(bool victory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(victory ? 'Victory!' : 'Defeat!'),
        content: Text(
          victory
              ? 'You defeated the ${_enemyCharacter!.name}!'
              : 'You were defeated by the ${_enemyCharacter!.name}...',
        ),
        actions: [
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
    final inventory = ref.watch(characterListProvider);

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

    _initializeBattle(inventory);

    return Scaffold(
      appBar: AppBar(title: const Text('Battle Arena')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _buildCharacterCard(
                _enemyCharacter!,
                hp: _enemyHp,
                maxHp: _enemyMaxHp,
                isEnemy: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _battleLog,
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
                _playerCharacter!,
                hp: _playerHp,
                maxHp: _playerMaxHp,
                isEnemy: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isPlayerTurn && !_battleEnded)
                    ? _playerAttack
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isPlayerTurn ? 'ATTACK' : 'ENEMY TURN...',
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
                    value: hp / maxHp,
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
