import 'package:flutter/material.dart';
import 'package:poke_tools/components/utils/string_utils.dart';
import 'package:poke_tools/models/nuzlocke_run.dart';
import 'package:poke_tools/models/pokemon_duo.dart';
import 'package:poke_tools/components/dialogs/confirmation_delete_dialog.dart';
import 'package:poke_tools/pages/add_pokemon_duo_page.dart';
import 'package:poke_tools/repositories/areas_repository.dart';
import 'package:poke_tools/repositories/nuzlocke_run_repository.dart';
import 'package:poke_tools/theme.dart';

class RunDetailPage extends StatefulWidget {
  final NuzlockeRun run;

  const RunDetailPage({super.key, required this.run});

  @override
  State<RunDetailPage> createState() => _RunDetailPageState();
}

class _RunDetailPageState extends State<RunDetailPage> {
  final NuzlockeRunRepository runRepository = NuzlockeRunRepository();
  final AreasRepository areasRepository = AreasRepository();

  Future<void> _saveRun() async {
    await runRepository.saveRun(widget.run);
  }

  void _deletePokemonDuo(int index) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDeletionDialog(
        title: 'Confirm Deletion',
        content:
            'Are you sure you want to delete duo "${widget.run.pokemons[index].pokemon1}" and "${widget.run.pokemons[index].pokemon2}"?',
        onDelete: () {
          setState(() {
            widget.run.pokemons.removeAt(index);
          });
          _saveRun();
        },
      ),
    );
  }

  void _showEditPlayerNamesDialog() {
    final player1Controller = TextEditingController(text: widget.run.player1);
    final player2Controller = TextEditingController(text: widget.run.player2);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Player Names'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: player1Controller,
              decoration: const InputDecoration(labelText: 'Player 1 Name'),
            ),
            TextField(
              controller: player2Controller,
              decoration: const InputDecoration(labelText: 'Player 2 Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.run.player1 = player1Controller.text.trim();
                widget.run.player2 = player2Controller.text.trim();
              });
              _saveRun();
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.run.name)),
      body: Container(
        color: widget.run.isWon
            ? runWon
            : widget.run.pokemons.every((duo) => !duo.areAlive) &&
                    widget.run.pokemons.isNotEmpty
                ? runLost
                : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Game: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: widget.run.game.displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Player 1: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.run.player1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Player 2: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.run.player2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditPlayerNamesDialog(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Finished:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Switch(
                        value: widget.run.isWon,
                        activeColor: Colors.white,
                        activeTrackColor: pokemonRed,
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.run.isWon = newValue;
                          });
                          _saveRun();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pokemon List (${widget.run.player1} - ${widget.run.player2})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.run.pokemons.where((duo) => duo.areAlive).length}/${widget.run.pokemons.length} alive',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.run.pokemons.length,
                itemBuilder: (context, index) {
                  var duo = widget.run.pokemons[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: duo.areAlive,
                        onChanged: (bool? value) {
                          setState(() => duo.areAlive = value ?? true);
                          _saveRun();
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${duo.pokemon1} - ${duo.pokemon2}"),
                          Text(capitalizeFirst(duo.area ?? "Static encounter")),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: duo.areInParty,
                            activeColor: Colors.white,
                            activeTrackColor: pokemonRed,
                            onChanged: (bool value) {
                              setState(() {
                                duo.areInParty = value;
                              });
                              _saveRun();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deletePokemonDuo(index);
                              _saveRun();
                            },
                          ),
                        ],
                      ),
                      tileColor: duo.areAlive ? runWon : runLost,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: duo.areInParty
                            ? BorderSide(color: pokemonBlue, width: 2)
                            : BorderSide(
                                color: duo.areAlive ? runWon : runLost,
                                width: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<PokemonDuo>(
            context,
            MaterialPageRoute(
              builder: (context) => AddPokemonDuoPage(
                run: widget.run,
                areasRepository: areasRepository,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              widget.run.pokemons.add(result);
            });
            _saveRun();
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: PokeToolsTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
