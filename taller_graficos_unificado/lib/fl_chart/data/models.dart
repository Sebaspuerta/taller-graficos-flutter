// Modelos de la API de Rick and Morty usados por las gráficas de fl_chart.

/// Id numérico al final de una URL de la API (".../episode/28" -> 28).
int idFromUrl(String url) => int.tryParse(url.split('/').last) ?? 0;

class FlCharacter {
  final int id;
  final String name;
  final String status;
  final String gender;
  final String species;

  /// Ids de los episodios en los que aparece (de la lista `episode` de la API).
  final List<int> episodeIds;

  const FlCharacter({
    required this.id,
    required this.name,
    required this.status,
    required this.gender,
    required this.species,
    required this.episodeIds,
  });

  int get episodeCount => episodeIds.length;

  /// Nombre corto para etiquetas de ejes ("Rick Sanchez" -> "Rick S.").
  String get shortName {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length <= 1) return name.trim();
    return '${parts.first} ${parts[1][0]}.';
  }

  factory FlCharacter.fromJson(Map<String, dynamic> json) => FlCharacter(
        id: json['id'] as int,
        name: json['name'] as String,
        status: json['status'] as String,
        gender: json['gender'] as String,
        species: json['species'] as String,
        episodeIds: [
          for (final url in json['episode'] as List<dynamic>) idFromUrl(url as String),
        ],
      );
}

class FlEpisode {
  final int id;
  final String name;

  /// Código "S01E01".
  final String code;

  /// Ids de los personajes que aparecen en el episodio.
  final List<int> characterIds;

  const FlEpisode({
    required this.id,
    required this.name,
    required this.code,
    required this.characterIds,
  });

  /// Temporada sacada del código "SxxEyy".
  int get season => int.tryParse(code.substring(1, 3)) ?? 0;

  int get characterCount => characterIds.length;

  factory FlEpisode.fromJson(Map<String, dynamic> json) => FlEpisode(
        id: json['id'] as int,
        name: json['name'] as String,
        code: json['episode'] as String,
        characterIds: [
          for (final url in json['characters'] as List<dynamic>) idFromUrl(url as String),
        ],
      );
}
