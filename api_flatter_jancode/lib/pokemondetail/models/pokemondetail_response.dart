class PokemonDetailResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonDetailitem> results;

  PokemonDetailResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) {
    return PokemonDetailResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<PokemonDetailitem>.from(
          json['results'].map((x) => PokemonDetailitem.fromJson(x))),
    );
  }
}

class Stat {
  final String name;
  final int baseStat;

  Stat({
    required this.name,
    required this.baseStat,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      name: json['stat']['name'],
      baseStat: json['base_stat'],
    );
  }
}

class PokemonDetailitem {
  final String name;
  final List<Stat> stats;
  final String weight;

  PokemonDetailitem({
    required this.name,
    required this.stats,
    required this.weight,
  });

  factory PokemonDetailitem.fromJson(Map<String, dynamic> json) {
    return PokemonDetailitem(
      name: json['name'],
      stats:
          (json['stats'] as List).map((stat) => Stat.fromJson(stat)).toList(),
      weight: json['weight'].toString(), // Ensure it's a string if needed
    );
  }
}
