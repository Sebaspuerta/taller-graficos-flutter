// Datos para graphic_screen.dart: CharData y fetchCharData().
//
// graphic_screen.dart usa `d.chars` y además 4 listas agregadas:
//   - byStatus / byGender / bySpecies: [{label, value(int)}]
//   - bySG: [{status, gender, count(int)}]  (estado x género)
// Todo se calcula a partir de los 20 personajes de /character?page=1.

import 'dart:convert';
import 'package:http/http.dart' as http;

// Orden fijo de categorías para que los colores de las paletas de
// graphic_screen.dart (_sc, _gc) caigan siempre en la misma categoría.
const _statusOrder = ['Alive', 'Dead', 'unknown'];
const _genderOrder = ['Male', 'Female', 'unknown', 'Genderless'];

class CharData {
  CharData({required this.chars})
      : byStatus = _countBy(chars, 'status', _statusOrder),
        byGender = _countBy(chars, 'gender', _genderOrder),
        bySpecies = _countBy(chars, 'species', const []),
        bySG = _countStatusGender(chars);

  /// Cada elemento: {id, idStr, name, episodes, status, gender, species}
  final List<Map<String, dynamic>> chars;

  /// [{label, value}] — conteo por estado.
  final List<Map<String, dynamic>> byStatus;

  /// [{label, value}] — conteo por género.
  final List<Map<String, dynamic>> byGender;

  /// [{label, value}] — conteo por especie (de mayor a menor).
  final List<Map<String, dynamic>> bySpecies;

  /// [{status, gender, count}] — cruce estado x género.
  final List<Map<String, dynamic>> bySG;
}

List<Map<String, dynamic>> _countBy(
  List<Map<String, dynamic>> chars,
  String key,
  List<String> order,
) {
  final counts = <String, int>{};
  for (final c in chars) {
    final k = c[key] as String;
    counts[k] = (counts[k] ?? 0) + 1;
  }
  final labels = <String>[
    ...order.where(counts.containsKey),
    ...(counts.keys.where((k) => !order.contains(k)).toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!))),
  ];
  return [
    for (final l in labels) {'label': l, 'value': counts[l]!},
  ];
}

List<Map<String, dynamic>> _countStatusGender(List<Map<String, dynamic>> chars) {
  final counts = <String, Map<String, int>>{};
  for (final c in chars) {
    final s = c['status'] as String;
    final g = c['gender'] as String;
    final row = counts.putIfAbsent(s, () => {});
    row[g] = (row[g] ?? 0) + 1;
  }
  final statuses = [
    ..._statusOrder.where(counts.containsKey),
    ...counts.keys.where((s) => !_statusOrder.contains(s)),
  ];
  final genders = <String>{for (final r in counts.values) ...r.keys};
  final genderList = [
    ..._genderOrder.where(genders.contains),
    ...genders.where((g) => !_genderOrder.contains(g)),
  ];
  // Se incluyen todas las combinaciones (aunque sean 0) para que cada estado
  // tenga los mismos géneros en el mismo orden al apilar/agrupar.
  return [
    for (final s in statuses)
      for (final g in genderList)
        {'status': s, 'gender': g, 'count': counts[s]![g] ?? 0},
  ];
}

Future<CharData> fetchCharData() async {
  // Los primeros 20 personajes (1 sola página de la API), igual que el
  // documento de graphic (usa IDs 1–10 y 11–20).
  final response = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/character?page=1'))
      .timeout(const Duration(seconds: 15));
  if (response.statusCode != 200) {
    throw Exception('Error ${response.statusCode} al consultar /character');
  }
  final body =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  final results = (body['results'] as List).cast<Map<String, dynamic>>();

  final chars = results.map((c) {
    final id = c['id'] as int;
    return <String, dynamic>{
      'id': id,
      'idStr': id.toString(),
      'name': c['name'] as String,
      'episodes': (c['episode'] as List).length,
      'status': c['status'] as String,
      'gender': c['gender'] as String,
      'species': c['species'] as String,
    };
  }).toList();

  return CharData(chars: chars);
}
