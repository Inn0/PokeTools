class PokemonDuo {
  String pokemon1;
  String pokemon2;
  String? area;
  bool areAlive;
  bool areInParty;

  PokemonDuo(this.pokemon1, this.pokemon2, this.area,
      {this.areAlive = true, this.areInParty = false});

  Map<String, dynamic> toJson() => {
        'pokemon1': pokemon1,
        'pokemon2': pokemon2,
        'area': area,
        'areAlive': areAlive,
        'areInParty': areInParty,
      };

  factory PokemonDuo.fromJson(Map<String, dynamic> json) {
    return PokemonDuo(
      json['pokemon1'],
      json['pokemon2'],
      json['area'],
      areAlive: json['areAlive'] ?? true,
      areInParty: json['areInParty'] ?? false,
    );
  }
}
