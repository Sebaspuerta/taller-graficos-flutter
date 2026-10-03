// Datos ya descargados + consultas comunes que usan las 63 gráficas.

import 'models.dart';

const statusOrder = ['Alive', 'Dead', 'unknown'];
const genderOrder = ['Male', 'Female', 'unknown', 'Genderless'];

class FlData {
  /// Los 20 personajes de /character?page=1 (mismos que el documento de graphic).
  final List<FlCharacter> characters;

  /// Los 51 episodios de /episode (todas las páginas).
  final List<FlEpisode> episodes;

  FlData({required this.characters, required this.episodes})
      : _seasonByEpisode = {for (final e in episodes) e.id: e.season};

  final Map<int, int> _seasonByEpisode;

  /// Temporadas presentes en /episode, ordenadas (1..5).
  List<int> get seasons => (episodes.map((e) => e.season).toSet().toList()..sort());

  /// Episodios de una temporada, en orden.
  List<FlEpisode> episodesOfSeason(int season) =>
      episodes.where((e) => e.season == season).toList()..sort((a, b) => a.id.compareTo(b.id));

  /// Cuántos episodios de la temporada [season] tiene el personaje [c].
  int appearancesInSeason(FlCharacter c, int season) =>
      c.episodeIds.where((id) => _seasonByEpisode[id] == season).length;

  /// Número de temporadas distintas en las que aparece [c].
  int seasonsOf(FlCharacter c) =>
      c.episodeIds.map((id) => _seasonByEpisode[id]).whereType<int>().toSet().length;

  FlCharacter? byId(int id) {
    for (final c in characters) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<FlCharacter> where(bool Function(FlCharacter c) test) => characters.where(test).toList();

  /// IDs entre [from] y [to] (inclusive).
  List<FlCharacter> idRange(int from, int to) => where((c) => c.id >= from && c.id <= to);

  /// Conteo por una clave. Las claves de [order] van primero (si aparecen) y
  /// el resto después, de mayor a menor.
  Map<String, int> countBy(String Function(FlCharacter c) key, [List<String> order = const []]) {
    final raw = <String, int>{};
    for (final c in characters) {
      raw[key(c)] = (raw[key(c)] ?? 0) + 1;
    }
    final rest = raw.keys.where((k) => !order.contains(k)).toList()
      ..sort((a, b) => raw[b]!.compareTo(raw[a]!));
    return {
      for (final k in order.where(raw.containsKey)) k: raw[k]!,
      for (final k in rest) k: raw[k]!,
    };
  }

  Map<String, int> get byStatus => countBy((c) => c.status, statusOrder);
  Map<String, int> get byGender => countBy((c) => c.gender, genderOrder);
  Map<String, int> get bySpecies => countBy((c) => c.species);

  /// Estados presentes (en orden fijo) y géneros presentes (en orden fijo).
  List<String> get statuses => byStatus.keys.toList();
  List<String> get genders => byGender.keys.toList();

  /// Personajes con estado [status] y género [gender].
  int countStatusGender(String status, String gender) =>
      characters.where((c) => c.status == status && c.gender == gender).length;

  int get maxEpisodes =>
      characters.fold(0, (m, c) => c.episodeCount > m ? c.episodeCount : m);

  double get averageEpisodes => characters.isEmpty
      ? 0
      : characters.fold(0, (s, c) => s + c.episodeCount) / characters.length;
}
