import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
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
                  subtitle: Text(character.rarity.name.toUpperCase()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(inventoryProvider.notifier)
                          .removeCharacter(character.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
