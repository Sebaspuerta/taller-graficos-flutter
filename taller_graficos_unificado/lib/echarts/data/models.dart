// Modelos de la API de Rick and Morty (Dart puro, sin Flutter).

class Character {
  final int id;
  final String name;
  final String status; // Alive / Dead / unknown
  final String species;
  final String type; // "Sin tipo" si la API lo devuelve vacío
  final String gender; // Male / Female / Genderless / unknown
  final String originName;
  final String locationName;
  final int episodeCount;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.episodeCount,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] as String? ?? '').trim();
    return Character(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? 'unknown',
      type: rawType.isEmpty ? 'Sin tipo' : rawType,
      gender: json['gender'] as String? ?? 'unknown',
      originName: (json['origin'] as Map<String, dynamic>?)?['name'] as String? ?? 'unknown',
      locationName: (json['location'] as Map<String, dynamic>?)?['name'] as String? ?? 'unknown',
      episodeCount: (json['episode'] as List<dynamic>? ?? const []).length,
      image: json['image'] as String? ?? '',
    );
  }
}

class Episode {
  final int id;
  final String name;
  final String airDateRaw; // "December 2, 2013"
  final DateTime? airDate;
  final String code; // "S01E01"
  final int season;
  final int number;
  final int characterCount;

  const Episode({
    required this.id,
    required this.name,
    required this.airDateRaw,
    required this.airDate,
    required this.code,
    required this.season,
    required this.number,
    required this.characterCount,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final code = json['episode'] as String? ?? '';
    final match = RegExp(r'S(\d+)E(\d+)').firstMatch(code);
    final airRaw = json['air_date'] as String? ?? '';
    return Episode(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      airDateRaw: airRaw,
      airDate: parseAirDate(airRaw),
      code: code,
      season: match != null ? int.parse(match.group(1)!) : 0,
      number: match != null ? int.parse(match.group(2)!) : 0,
      characterCount: (json['characters'] as List<dynamic>? ?? const []).length,
    );
  }

  static const Map<String, int> _months = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  /// Parsea "December 2, 2013" sin usar intl. Devuelve null si no coincide.
  static DateTime? parseAirDate(String raw) {
    final m = RegExp(r'^([A-Za-z]+)\s+(\d{1,2}),\s*(\d{4})$').firstMatch(raw.trim());
    if (m == null) return null;
    final month = _months[m.group(1)];
    if (month == null) return null;
    return DateTime(int.parse(m.group(3)!), month, int.parse(m.group(2)!));
  }
}
