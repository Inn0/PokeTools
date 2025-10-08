import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pokemon_game_names.dart';

class LevelCapsRepository {
  Future<Map<String, int>> getLevelCaps(PokemonGameNames gameName) async {
    final String response =
        await rootBundle.loadString('assets/levelCaps.json');
    final Map<String, dynamic> data = jsonDecode(response);

    if (data.containsKey(gameName.name)) {
      final Map<String, dynamic> caps = data[gameName.name];
      return caps.map((key, value) => MapEntry(key.toString(), value as int));
    } else {
      return {};
    }
  }
}
