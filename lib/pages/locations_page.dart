import 'package:flutter/material.dart';
import 'package:poke_tools/constants.dart';
import '../models/pokemon_game_names.dart';
import '../repositories/areas_repository.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends State<LocationsPage> {
  PokemonGameNames _selectedGame = PokemonGameNames.red;
  late AreasRepository _areasRepository;

  @override
  void initState() {
    super.initState();
    _areasRepository = AreasRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LOCATIONS_PAGE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<PokemonGameNames>(
              value: _selectedGame,
              onChanged: (PokemonGameNames? newGame) {
                if (newGame != null) {
                  setState(() {
                    _selectedGame = newGame;
                  });
                }
              },
              items: PokemonGameNames.values
                  .map<DropdownMenuItem<PokemonGameNames>>(
                    (game) => DropdownMenuItem<PokemonGameNames>(
                      value: game,
                      child: Text(game.displayName),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _areasRepository.getAreas(_selectedGame),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No locations available.'));
                  }

                  final areas = snapshot.data!;

                  return ListView.builder(
                    itemCount: areas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(areas[index]),
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
