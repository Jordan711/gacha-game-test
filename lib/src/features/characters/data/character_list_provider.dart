import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/character.dart';

class CharacterListNotifier extends StateNotifier<List<Character>> {
  CharacterListNotifier() : super([]);

  void addCharacter(Character character) {
    state = [...state, character];
  }

  void removeCharacter(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final characterListProvider =
    StateNotifierProvider<CharacterListNotifier, List<Character>>((ref) {
      return CharacterListNotifier();
    });
