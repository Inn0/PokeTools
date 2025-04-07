import 'package:flutter/material.dart';
import 'package:poke_tools/components/dialogs/error_dialog.dart';
import 'package:poke_tools/models/nuzlocke_run.dart';
import 'package:poke_tools/models/pokemon_duo.dart';
import 'package:poke_tools/repositories/areas_repository.dart';
import 'package:poke_tools/theme.dart';

class AddPokemonDuoPage extends StatefulWidget {
  final NuzlockeRun run;
  final AreasRepository areasRepository;

  const AddPokemonDuoPage({
    required this.run,
    required this.areasRepository,
    super.key,
  });

  @override
  State<AddPokemonDuoPage> createState() => _AddPokemonDuoPageState();
}

class _AddPokemonDuoPageState extends State<AddPokemonDuoPage> {
  final _pokemon1Controller = TextEditingController();
  final _pokemon2Controller = TextEditingController();
  String? _selectedArea = '';
  late Future<List<String>> _areasFuture;
  bool _isStatic = false;

  @override
  void initState() {
    super.initState();
    _areasFuture = widget.areasRepository.getAreas(widget.run.game);
  }

  void _submit() {
    final pokemon1 = _pokemon1Controller.text.trim();
    final pokemon2 = _pokemon2Controller.text.trim();

    if (pokemon1.isEmpty || pokemon2.isEmpty || _selectedArea!.isEmpty) {
      _showError('All fields must be filled!');
      return;
    }

    final isDuplicate = widget.run.pokemons.any((duo) =>
        duo.pokemon1 == pokemon1 ||
        duo.pokemon2 == pokemon1 ||
        duo.pokemon1 == pokemon2 ||
        duo.pokemon2 == pokemon2);

    if (isDuplicate) {
      _showError('One or both Pokémon are already in a duo!');
      return;
    }

    if (_isStatic) {
      _selectedArea = null;
    }

    final isAreaTaken = widget.run.pokemons.any(
      (duo) => duo.area != null && duo.area == _selectedArea,
    );

    if (isAreaTaken) {
      _showError('This area is already taken by another duo!');
      return;
    }

    final newDuo = PokemonDuo(pokemon1, pokemon2, _selectedArea);
    Navigator.pop(context, newDuo);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pokemon Duo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pokemon1Controller,
              decoration: InputDecoration(
                labelText: "${widget.run.player1}'s Pokemon:",
              ),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _pokemon2Controller,
              decoration: InputDecoration(
                labelText: "${widget.run.player2}'s Pokemon:",
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<String>>(
              future: _areasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final areas = snapshot.data ?? [];
                if (areas.isEmpty) {
                  return const Text('No areas available.');
                }

                if (_selectedArea!.isEmpty) {
                  _selectedArea = areas.first;
                }

                return Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedArea,
                        isExpanded: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedArea = value;
                            });
                          }
                        },
                        items: areas.map((area) {
                          return DropdownMenuItem(
                              value: area, child: Text(area));
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Static encounter'),
                    Switch(
                      value: _isStatic,
                      activeColor: Colors.white,
                      activeTrackColor: pokemonRed,
                      onChanged: (value) {
                        setState(() {
                          _isStatic = value;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Add duo'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
