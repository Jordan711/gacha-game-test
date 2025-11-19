import 'package:flutter/material.dart';
import 'package:game/src/features/characters/domain/character.dart';

/// Global map that assigns a color to each [Rarity] value.
final Map<Rarity, Color> rarityColors = {
  Rarity.common: Colors.grey,
  Rarity.rare: Colors.blue,
  Rarity.epic: Colors.purple,
  Rarity.legendary: Colors.orange,
};
