import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/character.dart';

class InventoryNotifier extends StateNotifier<List<Character>> {
  InventoryNotifier() : super([]);

  void addCharacter(Character character) {
    state = [...state, character];
  }

  void removeCharacter(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<Character>>((ref) {
      return InventoryNotifier();
    });
