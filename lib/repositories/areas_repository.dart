import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pokemon_game_names.dart';

class AreasRepository {
  Future<List<String>> getAreas(PokemonGameNames gameName) async {
    final String response = await rootBundle.loadString('assets/areas.json');
    final Map<String, dynamic> data = jsonDecode(response);

    if (data.containsKey(gameName.name)) {
      List<dynamic> areas = data[gameName.name];
      return areas.map((area) => area.toString()).toList();
    } else {
      return [];
    }
  }
}
