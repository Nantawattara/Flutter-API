// ignore_for_file: non_constant_identifier_names

class PokemonDetailResponse {
  final List<PokemonDetailitem> results;

  PokemonDetailResponse({
    required this.results,
  });

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) {
    return PokemonDetailResponse(
      results: List<PokemonDetailitem>.from(
          json['results'].map((x) => PokemonDetailitem.fromJson(x))),
    );
  }
}

class PokemonDetailitem {
  final String name;

  PokemonDetailitem({
    required this.name,
  });

  factory PokemonDetailitem.fromJson(Map<String, dynamic> json) {
    return PokemonDetailitem(
      name: json['name'],
    );
  }
}

class Ability {
  final String name;

  Ability({required this.name});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['ability']['name'],
    );
  }
}

class Stat {
  final String name;
  final int baseStat;

  Stat({required this.name, required this.baseStat});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      name: json['stat']['name'],
      baseStat: json['base_stat'],
    );
  }
}

class Type {
  final String name;

  Type({required this.name});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      name: json['type']['name'],
    );
  }
}

class Sprites {
  final String front_default;

  Sprites({
    required this.front_default,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      front_default: json['front_default'],
    );
  }
}
