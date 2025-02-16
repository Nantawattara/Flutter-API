import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_flatter_jancode/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({super.key, required this.pokemonListItem});

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  late Future<Map<String, dynamic>> _pokemonDetail;

  @override
  void initState() {
    super.initState();
    _pokemonDetail = loadData();
  }

  Future<Map<String, dynamic>> loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load Pokemon details');
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
      body: FutureBuilder<Map<String, dynamic>>(
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
            final abilities = (pokemon['abilities'] as List)
                .map((ability) => ability['ability']['name'])
                .join(', ');
            final stats = (pokemon['stats'] as List)
                .map((stat) => '${stat['stat']['name']}: ${stat['base_stat']}')
                .join('\n');

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${pokemon['name']}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Abilities: $abilities',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text('Stats:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(stats, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
