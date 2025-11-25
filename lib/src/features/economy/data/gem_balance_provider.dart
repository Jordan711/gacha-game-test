import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/characters/domain/character.dart';

class GemBalanceNotifier extends StateNotifier<int> {
  GemBalanceNotifier() : super(0);

  void add(int amount) {
    if (amount == 0) return;
    state = (state + amount).clamp(0, 9223372036854775807); // int64 max
  }

  bool spend(int cost) {
    if (cost <= state) {
      state -= cost;
      return true;
    }
    return false;
  }

  int getCharacterCost(Character character) {
    switch (character.rarity) {
      case Rarity.common:
        return 5;
      case Rarity.rare:
        return 10;
      case Rarity.epic:
        return 20;
      case Rarity.legendary:
        return 50;
    }
  }
}

final gemBalanceProvider = StateNotifierProvider<GemBalanceNotifier, int>(
  (ref) => GemBalanceNotifier(),
);
