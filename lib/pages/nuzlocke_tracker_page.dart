import 'package:flutter/material.dart';
import 'package:poke_tools/models/nuzlocke_run.dart';
import 'package:poke_tools/models/pokemon_game_names.dart';
import 'package:poke_tools/repositories/nuzlocke_run_repository.dart';
import 'package:poke_tools/theme.dart';
import 'package:poke_tools/pages/run_detail_page.dart';
import 'package:poke_tools/components/dialogs/confirmation_delete_dialog.dart';

class NuzlockeTrackerPage extends StatefulWidget {
  const NuzlockeTrackerPage({super.key});

  @override
  State<NuzlockeTrackerPage> createState() => _NuzlockeTrackerPageState();
}

class _NuzlockeTrackerPageState extends State<NuzlockeTrackerPage> {
  final NuzlockeRunRepository repository = NuzlockeRunRepository();

  List<NuzlockeRun> runs = [];

  @override
  void initState() {
    super.initState();
    _loadRuns();
  }

  Future<void> _loadRuns() async {
    final loadedRuns = await repository.loadRuns();
    setState(() {
      runs = loadedRuns;
    });
  }

  Future<void> _saveRuns() async {
    await repository.saveRuns(runs);
  }

  void _deleteRun(int index) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDeletionDialog(
        title: 'Confirm Deletion',
        content: 'Are you sure you want to delete run "${runs[index].name}"?',
        onDelete: () {
          setState(() {
            runs.removeAt(index);
          });
          _saveRuns();
        },
      ),
    );
  }

  void _addRun(String name, PokemonGameNames game) {
    setState(() {
      runs.add(NuzlockeRun(name: name, game: game));
    });
    _saveRuns();
  }

  void _showAddRunDialog() {
    final nameController = TextEditingController();
    PokemonGameNames selectedGame = PokemonGameNames.red;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Nuzlocke Run'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Run Name'),
                onSubmitted: (_) {
                  if (nameController.text.isNotEmpty) {
                    _addRun(nameController.text, selectedGame);
                    Navigator.pop(context);
                  }
                },
              ),
              DropdownButton<PokemonGameNames>(
                value: selectedGame,
                isExpanded: true,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setDialogState(() => selectedGame = newValue);
                  }
                },
                items: PokemonGameNames.values
                    .map((game) => DropdownMenuItem(
                          value: game,
                          child: Text(game.displayName),
                        ))
                    .toList(),
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
                if (nameController.text.isNotEmpty) {
                  _addRun(nameController.text, selectedGame);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuzlocke Runs'),
      ),
      body: runs.isEmpty
          ? const Center(child: Text('No runs available.'))
          : ListView.builder(
              itemCount: runs.length,
              itemBuilder: (context, index) {
                final run = runs[index];
                return Card(
                  color: run.isWon
                      ? runWon
                      : run.pokemons.every((duo) => !duo.areAlive) &&
                              run.pokemons.isNotEmpty
                          ? runLost
                          : ThemeData.dark().cardTheme.color,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    title: Text(
                      run.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text(run.game.displayName),
                        Text(" - "),
                        Text('${run.player1} & ${run.player2}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteRun(index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunDetailPage(run: run),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRunDialog,
        foregroundColor: Colors.white,
        backgroundColor: PokeToolsTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
