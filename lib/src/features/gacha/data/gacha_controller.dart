import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/characters/data/character_list_provider.dart';
import 'package:game/src/features/characters/domain/character.dart';
import 'package:game/src/features/economy/data/gem_balance_provider.dart';

class GachaState {
  final bool isSummoning;
  final Character? lastSummoned;

  GachaState({this.isSummoning = false, this.lastSummoned});
}

class GachaController extends StateNotifier<GachaState> {
  final Ref ref;

  GachaController(this.ref) : super(GachaState());

  Future<void> summon() async {
    final gemNotifier = ref.read(gemBalanceProvider.notifier);

    // Check and spend gems
    if (!gemNotifier.spend(100)) {
      // Not enough gems - UI should handle this check too, but double check here
      return;
    }

    state = GachaState(isSummoning: true, lastSummoned: null);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final rarity = Rarity.values[random.nextInt(Rarity.values.length)];
    final names = ['Warrior', 'Mage', 'Archer', 'Rogue', 'Paladin'];
    final name = names[random.nextInt(names.length)];

    final newCharacter = Character.random(name, rarity);

    // Add to inventory
    ref.read(characterListProvider.notifier).addCharacter(newCharacter);

    state = GachaState(isSummoning: false, lastSummoned: newCharacter);
  }
}

final gachaControllerProvider =
    StateNotifierProvider<GachaController, GachaState>((ref) {
      return GachaController(ref);
    });
