// Contenedor de datos compartido y helpers de agregación (Dart puro).

import 'models.dart';

class RMData {
  final List<Character> characters;
  final List<Episode> episodes;

  RMData({required List<Character> characters, required List<Episode> episodes})
      : characters = List.unmodifiable([...characters]..sort((a, b) => a.id.compareTo(b.id))),
        episodes = List.unmodifiable([...episodes]..sort((a, b) => a.id.compareTo(b.id)));

  /// Primeros [n] personajes por id.
  List<Character> firstById(int n) => characters.take(n).toList();

  /// Personajes cuyo id está en [from, to].
  List<Character> idRange(int from, int to) =>
      characters.where((c) => c.id >= from && c.id <= to).toList();

  List<Character> where(bool Function(Character) test) => characters.where(test).toList();
}

/// Valores fijos de estado y género (orden estable para ejes y leyendas).
const List<String> kStatuses = ['Alive', 'Dead', 'unknown'];
const List<String> kGenders = ['Male', 'Female', 'Genderless', 'unknown'];

/// Cuenta elementos agrupados por la clave que devuelve [key].
/// Conserva el orden de primera aparición.
Map<String, int> countBy<T>(Iterable<T> items, String Function(T) key) {
  final result = <String, int>{};
  for (final item in items) {
    final k = key(item);
    result[k] = (result[k] ?? 0) + 1;
  }
  return result;
}

/// Cuenta usando un orden fijo de claves (las ausentes quedan en 0).
Map<String, int> countByKeys<T>(Iterable<T> items, String Function(T) key, List<String> keys) {
  final counts = countBy(items, key);
  return {for (final k in keys) k: counts[k] ?? 0};
}

/// Entradas ordenadas por valor descendente (empates por clave).
List<MapEntry<String, int>> sortedDesc(Map<String, int> map) {
  final entries = map.entries.toList()
    ..sort((a, b) {
      final byValue = b.value.compareTo(a.value);
      return byValue != 0 ? byValue : a.key.compareTo(b.key);
    });
  return entries;
}

/// Las [n] entradas de mayor valor.
List<MapEntry<String, int>> topN(Map<String, int> map, int n) => sortedDesc(map).take(n).toList();

/// Top [n] entradas y el resto agrupado en [otherLabel] (si existe resto).
List<MapEntry<String, int>> topNWithOthers(Map<String, int> map, int n, {String otherLabel = 'Otros'}) {
  final sorted = sortedDesc(map);
  final top = sorted.take(n).toList();
  final rest = sorted.skip(n).fold<int>(0, (sum, e) => sum + e.value);
  if (rest > 0) top.add(MapEntry(otherLabel, rest));
  return top;
}

/// Lista ordenada por una clave numérica.
List<T> sortedBy<T>(Iterable<T> items, num Function(T) key, {bool descending = false}) {
  final list = items.toList()
    ..sort((a, b) => descending ? key(b).compareTo(key(a)) : key(a).compareTo(key(b)));
  return list;
}

/// Resumen de cinco números [mín, Q1, mediana, Q3, máx] (cuartiles por interpolación lineal).
/// Con lista vacía devuelve ceros.
List<double> fiveNumberSummary(List<num> values) {
  if (values.isEmpty) return [0, 0, 0, 0, 0];
  final s = values.map((v) => v.toDouble()).toList()..sort();
  double q(double p) {
    final pos = (s.length - 1) * p;
    final lo = pos.floor();
    final hi = pos.ceil();
    return s[lo] + (s[hi] - s[lo]) * (pos - lo);
  }

  return [s.first, q(0.25), q(0.5), q(0.75), s.last];
}

/// Redondea a [decimals] decimales.
double round(num value, [int decimals = 1]) {
  var f = 1.0;
  for (var i = 0; i < decimals; i++) {
    f *= 10;
  }
  return (value * f).roundToDouble() / f;
}
