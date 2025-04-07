import 'package:poke_tools/models/pokemon_game_names.dart';
import 'package:poke_tools/models/pokemon_duo.dart';
import 'package:uuid/uuid.dart';

class NuzlockeRun {
  String id;
  String name;
  PokemonGameNames game;
  String player1;
  String player2;
  List<PokemonDuo> pokemons;
  bool isWon;

  NuzlockeRun({
    required this.name,
    required this.game,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
    List<PokemonDuo>? pokemons,
    this.isWon = false,
  })  : id = Uuid().v4(),
        pokemons = pokemons ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'game': game.name,
        'player1': player1,
        'player2': player2,
        'pokemons': pokemons.map((duo) => duo.toJson()).toList(),
        'isWon': isWon,
      };

  factory NuzlockeRun.fromJson(Map<String, dynamic> json) {
    var pokemonList = (json['pokemons'] as List)
        .map((duoJson) => PokemonDuo.fromJson(duoJson))
        .toList();

    return NuzlockeRun(
      name: json['name'],
      game: PokemonGameNames.fromString(json['game']),
      player1: json['player1'] ?? "Player 1",
      player2: json['player2'] ?? "Player 2",
      pokemons: pokemonList,
      isWon: json['isWon'] ?? false,
    )..id = json['id'];
  }
}
