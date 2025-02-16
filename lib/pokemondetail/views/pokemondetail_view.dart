import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_flatter_jancode/pokemonlist/models/pokemonlist_response.dart';
import 'package:api_flatter_jancode/pokemondetail/models/pokemondetail_response.dart';
import 'package:http/http.dart' as http;

class PokemonDetailitem {
  final String name;
  final List<Ability> abilities;
  final List<Stat> stats;
  final List<Type> types;
  final String weight;
  final String height;
  final String sprites;

  PokemonDetailitem({
    required this.name,
    required this.sprites,
    required this.abilities,
    required this.stats,
    required this.types,
    required this.weight,
    required this.height,
  });

  factory PokemonDetailitem.fromJson(Map<String, dynamic> json) {
    return PokemonDetailitem(
      name: json['name'],
      abilities: (json['abilities'] as List)
          .map((ability) => Ability.fromJson(ability))
          .toList(),
      stats:
          (json['stats'] as List).map((stat) => Stat.fromJson(stat)).toList(),
      types:
          (json['types'] as List).map((type) => Type.fromJson(type)).toList(),
      weight: json['weight'].toString(),
      height: json['height'].toString(),
      sprites: json['sprites']['other']['home']['front_default'].toString(),
    );
  }
}

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({super.key, required this.pokemonListItem});

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  late Future<PokemonDetailitem> _pokemonDetail;

  @override
  void initState() {
    super.initState();
    _pokemonDetail = loadData();
  }

  Future<PokemonDetailitem> loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PokemonDetailitem.fromJson(data);
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'grass':
        return Colors.green;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow;
      case 'ice':
        return Colors.lightBlue;
      case 'fighting':
        return Colors.brown;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown[300]!;
      case 'flying':
        return Colors.lightBlue[200]!;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurple;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PokemonDetailitem>(
        future: _pokemonDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No Pokemon details found'));
          } else {
            final pokemon = snapshot.data!;
            final abilities =
                pokemon.abilities.map((ability) => ability.name).join(', ');
            final stats = pokemon.stats
                .map((stat) => '${stat.name.toUpperCase()}: ${stat.baseStat}')
                .join('\n');
            final types =
                pokemon.types.map((type) => type.name.toUpperCase()).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 500,
                        width: 500,
                        child: Image.network(
                          pokemon.sprites,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text('Name: ${pokemon.name.toUpperCase()}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text('Abilities: $abilities',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      const Text('Stats:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(stats, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      const Text('Types:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8.0,
                        children: types.map((type) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: getTypeColor(type),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text('Weight: ${pokemon.weight}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Height: ${pokemon.height}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
