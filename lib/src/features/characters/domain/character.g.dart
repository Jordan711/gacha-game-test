// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
  id: json['id'] as String?,
  name: json['name'] as String,
  rarity: $enumDecode(_$RarityEnumMap, json['rarity']),
  attack: (json['attack'] as num).toInt(),
  defense: (json['defense'] as num).toInt(),
  hp: (json['hp'] as num).toInt(),
  imageUrl: json['imageUrl'] as String? ?? '',
);

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'rarity': _$RarityEnumMap[instance.rarity]!,
  'attack': instance.attack,
  'defense': instance.defense,
  'hp': instance.hp,
  'imageUrl': instance.imageUrl,
};

const _$RarityEnumMap = {
  Rarity.common: 'common',
  Rarity.rare: 'rare',
  Rarity.epic: 'epic',
  Rarity.legendary: 'legendary',
};
