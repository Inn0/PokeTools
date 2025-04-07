enum PokemonGameNames {
  red('Pokémon Red'),
  blue('Pokémon Blue'),
  yellow('Pokémon Yellow'),
  gold('Pokémon Gold'),
  silver('Pokémon Silver'),
  crystal('Pokémon Crystal'),
  ruby('Pokémon Ruby'),
  sapphire('Pokémon Sapphire'),
  emerald('Pokémon Emerald'),
  fireRed('Pokémon FireRed'),
  leafGreen('Pokémon LeafGreen'),
  diamond('Pokémon Diamond'),
  pearl('Pokémon Pearl'),
  platinum('Pokémon Platinum'),
  heartGold('Pokémon HeartGold'),
  soulSilver('Pokémon SoulSilver'),
  black('Pokémon Black'),
  white('Pokémon White'),
  black2('Pokémon Black 2'),
  white2('Pokémon White 2'),
  x('Pokémon X'),
  y('Pokémon Y'),
  omegaRuby('Pokémon Omega Ruby'),
  alphaSapphire('Pokémon Alpha Sapphire'),
  sun('Pokémon Sun'),
  moon('Pokémon Moon'),
  ultraSun('Pokémon Ultra Sun'),
  ultraMoon('Pokémon Ultra Moon'),
  sword('Pokémon Sword'),
  shield('Pokémon Shield'),
  brilliantDiamond('Pokémon Brilliant Diamond'),
  shiningPearl('Pokémon Shining Pearl'),
  legendsArceus('Pokémon Legends: Arceus'),
  scarlet('Pokémon Scarlet'),
  violet('Pokémon Violet');

  final String displayName;
  const PokemonGameNames(this.displayName);

  factory PokemonGameNames.fromString(String value) {
    return PokemonGameNames.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PokemonGameNames.red,
    );
  }
}
