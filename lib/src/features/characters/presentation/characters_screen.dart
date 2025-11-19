import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game/src/core/theme/rarity_colors.dart';
import '../../characters/data/inventory_provider.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  late final AudioPlayer _audioPlayer;

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

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: inventory.isEmpty
          ? const Center(
              child: Text(
                'You currently have no characters, please summon some now!',
              ),
            )
          : ListView.builder(
              itemCount: inventory.length,
              itemBuilder: (context, index) {
                final character = inventory[index];
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          character.name,
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/${character.name.toLowerCase()}.png',
                              height: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              character.rarity.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: rarityColors[character.rarity],
                              ),
                            ),
                            Text(
                              'ATK: ${character.attack}  DEF: ${character.defense}  HP: ${character.hp}',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: Image.asset(
                    'assets/images/${character.name.toLowerCase()}.png',
                    height: 50,
                  ),
                  title: Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    character.rarity.name.toUpperCase(),
                    style: TextStyle(color: rarityColors[character.rarity]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Character'),
                          content: Text(
                            'Are you sure you want to delete this character? This is a ${character.rarity.name} character!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(inventoryProvider.notifier)
                                    .removeCharacter(character.id);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
