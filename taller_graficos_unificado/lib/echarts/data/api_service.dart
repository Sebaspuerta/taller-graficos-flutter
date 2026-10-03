import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';
import 'rm_data.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const Duration timeout = Duration(seconds: 15);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await _client.get(Uri.parse(url)).timeout(timeout);
      if (response.statusCode != 200) {
        throw ApiException('La API respondió ${response.statusCode} para $url');
      }
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado (15 s) al consultar $url');
    } on FormatException {
      throw ApiException('Respuesta inválida (JSON) de $url');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error de red: $e');
    }
  }

  /// Personajes de las páginas 1, 2 y 3 (60 personajes).
  Future<List<Character>> fetchCharacters({List<int> pages = const [1, 2, 3]}) async {
    final responses = await Future.wait(pages.map((p) => _getJson('$baseUrl/character?page=$p')));
    return [
      for (final json in responses)
        for (final item in json['results'] as List<dynamic>) Character.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// Todos los episodios siguiendo info.next (51 episodios).
  Future<List<Episode>> fetchEpisodes() async {
    final episodes = <Episode>[];
    String? next = '$baseUrl/episode';
    while (next != null) {
      final json = await _getJson(next);
      episodes.addAll((json['results'] as List<dynamic>).map((e) => Episode.fromJson(e as Map<String, dynamic>)));
      next = (json['info'] as Map<String, dynamic>?)?['next'] as String?;
    }
    return episodes;
  }

  Future<RMData> loadAll() async {
    final results = await Future.wait([fetchCharacters(), fetchEpisodes()]);
    return RMData(
      characters: results[0] as List<Character>,
      episodes: results[1] as List<Episode>,
    );
  }
}
