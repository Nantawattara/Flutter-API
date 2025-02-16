import 'dart:convert';
import 'package:api_flatter_jancode/pokemondetail/models/pokemondetail_response.dart';
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
  PokemonDetailResponse? data;
  late Future<List<PokemonDetailitem>> _list;

  @override
  void initState() {
    super.initState();
    _list = loadData();
  }

  Future<List<PokemonDetailitem>> loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      final PokemonDetailResponse data =
          PokemonDetailResponse.fromJson(jsonDecode(response.body));
      return data.results;
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
      body: FutureBuilder<List<PokemonDetailitem>>(
          future: _list,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Pokemon found'));
            } else {
              final List<PokemonDetailitem> response =
                  snapshot.data as List<PokemonDetailitem>;

              return ListView.builder(
                itemCount: response.length,
                itemBuilder: (context, index) {
                  final PokemonDetailitem pokemon = response[index];
                  return ListTile(
                    title: Text(pokemon.name),
                  );
                },
              );
            }
          }),
    );
  }
}
