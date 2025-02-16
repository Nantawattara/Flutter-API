import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_flatter_jancode/pokemonlist/models/pokemonlist_response.dart';
import 'package:api_flatter_jancode/pokemondetail/views/pokemondetail_view.dart';
import 'package:http/http.dart' as http;

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<PokemonListItem> _pokemonList = [];
  int _offset = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?limit=20&offset=$_offset'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<PokemonListItem> newPokemonList = (data['results'] as List)
          .map((item) => PokemonListItem.fromJson(item))
          .toList();
      setState(() {
        _pokemonList = newPokemonList;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load Pokemon');
    }
  }

  void _loadMore() {
    setState(() {
      _offset += 20;
    });
    loadData();
  }

  void _loadBack() {
    setState(() {
      if (_offset <= 0) return;
      _offset -= 20;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _pokemonList.length,
            itemBuilder: (context, index) {
              final PokemonListItem pokemon = _pokemonList[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemondetailView(
                      pokemonListItem: pokemon,
                    ),
                  ),
                ),
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1 + _offset}.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        if (!_isLoading)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _loadBack,
                  child: const Text('Back'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _loadMore,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
