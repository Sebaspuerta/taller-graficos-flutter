import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'fl_data.dart';
import 'models.dart';

class FlApiException implements Exception {
  final String message;
  FlApiException(this.message);

  @override
  String toString() => message;
}

class FlApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const Duration timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(timeout);
      if (response.statusCode != 200) {
        throw FlApiException('La API respondió ${response.statusCode} para $url');
      }
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on TimeoutException {
      throw FlApiException('Tiempo de espera agotado (15 s) al consultar $url');
    } on FormatException {
      throw FlApiException('Respuesta inválida (JSON) de $url');
    } on FlApiException {
      rethrow;
    } catch (e) {
      throw FlApiException('Error de red: $e');
    }
  }

  /// Los 20 personajes de /character?page=1, igual que el documento de graphic.
  Future<List<FlCharacter>> fetchCharacters() async {
    final json = await _getJson('$baseUrl/character?page=1');
    return [
      for (final item in json['results'] as List<dynamic>)
        FlCharacter.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// Todos los episodios siguiendo info.next (51 episodios).
  Future<List<FlEpisode>> fetchEpisodes() async {
    final episodes = <FlEpisode>[];
    String? next = '$baseUrl/episode';
    while (next != null) {
      final json = await _getJson(next);
      episodes.addAll([
        for (final item in json['results'] as List<dynamic>)
          FlEpisode.fromJson(item as Map<String, dynamic>),
      ]);
      next = (json['info'] as Map<String, dynamic>?)?['next'] as String?;
    }
    return episodes;
  }

  Future<FlData> loadAll() async {
    final results = await Future.wait([fetchCharacters(), fetchEpisodes()]);
    final characters = results[0] as List<FlCharacter>;
    final episodes = results[1] as List<FlEpisode>;
    // Las gráficas usan los IDs 1–20 y las 5 temporadas; con menos datos
    // varias quedarían vacías, así que se avisa en vez de seguir.
    if (characters.length < 20) {
      throw FlApiException('La API devolvió ${characters.length} personajes; se necesitan 20.');
    }
    if (episodes.isEmpty) {
      throw FlApiException('La API no devolvió episodios.');
    }
    return FlData(characters: characters, episodes: episodes);
  }
}
