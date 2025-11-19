import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/characters/domain/character.dart';

class BattleState {
  final Character? playerCharacter;
  final Character? enemyCharacter;
  final int playerHp;
  final int enemyHp;
  final int playerMaxHp;
  final int enemyMaxHp;
  final bool isPlayerTurn;
  final String battleLog;
  final bool battleEnded;

  BattleState({
    this.playerCharacter,
    this.enemyCharacter,
    this.playerHp = 0,
    this.enemyHp = 0,
    this.playerMaxHp = 1,
    this.enemyMaxHp = 1,
    this.isPlayerTurn = true,
    this.battleLog = 'Battle Start!',
    this.battleEnded = false,
  });

  BattleState copyWith({
    Character? playerCharacter,
    Character? enemyCharacter,
    int? playerHp,
    int? enemyHp,
    int? playerMaxHp,
    int? enemyMaxHp,
    bool? isPlayerTurn,
    String? battleLog,
    bool? battleEnded,
  }) {
    return BattleState(
      playerCharacter: playerCharacter ?? this.playerCharacter,
      enemyCharacter: enemyCharacter ?? this.enemyCharacter,
      playerHp: playerHp ?? this.playerHp,
      enemyHp: enemyHp ?? this.enemyHp,
      playerMaxHp: playerMaxHp ?? this.playerMaxHp,
      enemyMaxHp: enemyMaxHp ?? this.enemyMaxHp,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      battleLog: battleLog ?? this.battleLog,
      battleEnded: battleEnded ?? this.battleEnded,
    );
  }
}

class BattleController extends StateNotifier<BattleState> {
  BattleController() : super(BattleState());

  void initializeBattle(List<Character> inventory) {
    // Don't re-initialize if we already have a valid battle state
    if (state.playerCharacter != null && !state.battleEnded) return;

    final playerCharacter = inventory.reduce(
      (curr, next) => curr.attack > next.attack ? curr : next,
    );
    final enemyCharacter = Character.random('Monster', Rarity.epic);

    state = BattleState(
      playerCharacter: playerCharacter,
      enemyCharacter: enemyCharacter,
      playerHp: playerCharacter.hp,
      playerMaxHp: playerCharacter.hp,
      enemyHp: enemyCharacter.hp,
      enemyMaxHp: enemyCharacter.hp,
      isPlayerTurn: true,
      battleLog: 'A wild ${enemyCharacter.name} appeared!',
      battleEnded: false,
    );
  }

  void playerAttack() {
    if (!state.isPlayerTurn || state.battleEnded) return;

    final damage = _calculateDamage(
      state.playerCharacter!,
      state.enemyCharacter!,
    );
    final newEnemyHp = (state.enemyHp - damage).clamp(0, state.enemyMaxHp);

    state = state.copyWith(
      enemyHp: newEnemyHp,
      battleLog: 'You dealt $damage damage!',
      isPlayerTurn: false,
    );

    _checkBattleEnd();

    if (!state.battleEnded) {
      Future.delayed(const Duration(seconds: 1), _enemyTurn);
    }
  }

  void _enemyTurn() {
    if (state.battleEnded) return;

    final damage = _calculateDamage(
      state.enemyCharacter!,
      state.playerCharacter!,
    );
    final newPlayerHp = (state.playerHp - damage).clamp(0, state.playerMaxHp);

    state = state.copyWith(
      playerHp: newPlayerHp,
      battleLog: 'Enemy dealt $damage damage!',
      isPlayerTurn: true,
    );

    _checkBattleEnd();
  }

  int _calculateDamage(Character attacker, Character defender) {
    final damage = attacker.attack - (defender.defense * 0.5);
    return max(1, damage.toInt());
  }

  void _checkBattleEnd() {
    if (state.enemyHp <= 0) {
      state = state.copyWith(battleEnded: true, battleLog: 'Victory!');
    } else if (state.playerHp <= 0) {
      state = state.copyWith(battleEnded: true, battleLog: 'Defeat!');
    }
  }
}

final battleControllerProvider =
    StateNotifierProvider<BattleController, BattleState>((ref) {
      return BattleController();
    });
