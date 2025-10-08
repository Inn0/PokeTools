import 'package:flutter/material.dart';
import '../models/pokemon_game_names.dart';
import '../repositories/levelcaps_repository.dart';

class LevelCapsPage extends StatefulWidget {
  const LevelCapsPage({super.key});

  @override
  LevelCapsPageState createState() => LevelCapsPageState();
}

class LevelCapsPageState extends State<LevelCapsPage> {
  PokemonGameNames _selectedGame = PokemonGameNames.red;
  late LevelCapsRepository _levelCapsRepository;

  @override
  void initState() {
    super.initState();
    _levelCapsRepository = LevelCapsRepository();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(title: const Text('Level Caps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<PokemonGameNames>(
              value: _selectedGame,
              onChanged: (PokemonGameNames? newGame) {
                if (newGame != null) {
                  setState(() => _selectedGame = newGame);
                }
              },
              items: PokemonGameNames.values
                  .map((game) => DropdownMenuItem<PokemonGameNames>(
                        value: game,
                        child: Text(game.displayName),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, int>>(
                future: _levelCapsRepository.getLevelCaps(_selectedGame),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final caps = snapshot.data;
                  if (caps == null || caps.isEmpty) {
                    return const Center(
                        child: Text('No level caps available.'));
                  }

                  final entries = caps.entries.toList();

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return ListTile(
                        title: Text(entry.key, style: textStyle),
                        trailing: Text('Lv. ${entry.value}', style: textStyle),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
