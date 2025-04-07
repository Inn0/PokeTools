import 'package:flutter/material.dart';

const Color pokemonYellow = Color(0xFFffcc00);
const Color pokemonRed = Color(0xFFe3350d);
const Color pokemonBlue = Color(0xFF375ba9);
const Color runWon = Color.fromARGB(255, 24, 82, 1);
const Color runLost = Color.fromARGB(255, 56, 56, 56);
const Color runActive = pokemonRed;

ThemeData PokeToolsTheme = ThemeData.dark().copyWith(
  primaryColor: pokemonRed,
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: pokemonRed,
        onPrimary:
            Colors.white, // Set the text color for primary-colored backgrounds
      ),
);
