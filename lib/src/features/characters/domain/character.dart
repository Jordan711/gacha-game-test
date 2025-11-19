import 'dart:math';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'character.g.dart';

enum Rarity { common, rare, epic, legendary }

@JsonSerializable()
class Character {
  final String id;
  final String name;
  final Rarity rarity;
  final int attack;
  final int defense;
  final int hp;
  final String imageUrl; // Placeholder for now

  Character({
    String? id,
    required this.name,
    required this.rarity,
    required this.attack,
    required this.defense,
    required this.hp,
    this.imageUrl = '',
  }) : id = id ?? const Uuid().v4();

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  // Helper to create random stats based on rarity
  factory Character.random(String name, Rarity rarity) {
    final random = Random();
    int multiplier = rarity.index + 1;
    return Character(
      name: name,
      rarity: rarity,
      attack: 10 * multiplier + random.nextInt(10),
      defense: 5 * multiplier + random.nextInt(5),
      hp: 50 * multiplier + random.nextInt(20),
    );
  }
}
