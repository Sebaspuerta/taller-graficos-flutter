// Datos compartidos por TODAS las gráficas (básicas y avanzadas).
//
// A diferencia de la versión anterior (datos inventados a mano), aquí
// los mismos 8 datasets se calculan a partir de datos REALES traídos de
// la API pública de Rick and Morty (https://rickandmortyapi.com/).
//
// IMPORTANTE: como esto ahora requiere internet, hay que llamar
// `await SampleData.load()` UNA vez (en main.dart, antes de mostrar la
// navegación) para que los campos de abajo queden poblados. Los 63
// widgets de basic_charts.dart / advanced_charts.dart NO cambian: siguen
// leyendo `SampleData.monthlySales`, `SampleData.marketShare`, etc.,
// exactamente igual que antes.

import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://rickandmortyapi.com/api';

/// Dato genérico x/y, sirve para línea, columna, barra, área, dispersión, etc.
class ChartData {
  ChartData(this.x, this.y, [this.y2]);
  final String x;
  final double y;
  final double? y2;
}

/// Dato de rango (min/max), para range column / range area / spline range area.
class RangeData {
  RangeData(this.x, this.low, this.high);
  final String x;
  final double low;
  final double high;
}

/// Dato financiero OHLC, para vela (candle), hilo y ohlc.
class FinancialData {
  FinancialData(this.x, this.open, this.high, this.low, this.close);
  final String x;
  final double open;
  final double high;
  final double low;
  final double close;
}

/// Dato para burbuja: necesita un tercer valor (tamaño).
class BubbleChartData {
  BubbleChartData(this.x, this.y, this.size);
  final String x;
  final double y;
  final double size;
}

/// Dato circular (pastel, donut, barra radial).
class CircularData {
  CircularData(this.category, this.value);
  final String category;
  final double value;
}

/// Dato para cascada (waterfall).
class WaterfallChartData {
  WaterfallChartData(this.x, this.y, {this.isIntermediateSum = false, this.isTotal = false});
  final String x;
  final double y;
  final bool isIntermediateSum;
  final bool isTotal;
}

/// Dato para caja y bigotes: una lista de valores por categoría.
class BoxData {
  BoxData(this.x, this.values);
  final String x;
  final List<num> values;
}

class SampleData {
  // Los 8 datasets que usan las 63 gráficas. Antes de llamar load() están
  // vacíos; después de await SampleData.load() quedan poblados con datos
  // reales de Rick and Morty y ya se pueden graficar.
  static List<ChartData> monthlySales = [];
  static List<RangeData> weeklyTemperatureRange = [];
  static List<FinancialData> stockPrices = [];
  static List<BubbleChartData> bubbleMarket = [];
  static List<CircularData> marketShare = [];
  static List<WaterfallChartData> waterfallBudget = [];
  static List<double> histogramValues = [];
  static List<BoxData> boxWhiskerData = [];

  static bool _loaded = false;
  static bool get isLoaded => _loaded;

  /// Descarga TODOS los personajes, episodios y locaciones (siguiendo la
  /// paginación de la API) y calcula los 8 datasets de arriba. Llámalo una
  /// sola vez, por ejemplo en un splash screen, antes de mostrar las
  /// gráficas.
  static Future<void> load() async {
    if (_loaded) return;
    final characters = await _fetchAllPages('$_baseUrl/character');
    final episodes = await _fetchAllPages('$_baseUrl/episode');
    final locations = await _fetchAllPages('$_baseUrl/location');

    _buildAliveDeadBySpecies(characters);
    _buildSeasonEpisodeRange(episodes);
    _buildSeasonOhlc(episodes);
    _buildLocationBubbles(locations);
    _buildSpeciesShare(characters);
    _buildStatusWaterfall(characters);
    _buildEpisodeCountHistogram(characters);
    _buildEpisodeCountBoxByStatus(characters);

    _loaded = true;
  }

  /// La API de Rick and Morty pagina de a 20-100 resultados y da la URL de
  /// la siguiente página en info.next. Aquí seguimos ese enlace hasta que
  /// no haya más páginas.
  static Future<List<Map<String, dynamic>>> _fetchAllPages(String firstUrl) async {
    final results = <Map<String, dynamic>>[];
    String? nextUrl = firstUrl;

    while (nextUrl != null) {
      final response = await http.get(Uri.parse(nextUrl));
      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode} consultando $nextUrl');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final pageResults = (body['results'] as List).cast<Map<String, dynamic>>();
      results.addAll(pageResults);
      nextUrl = body['info']?['next'] as String?;
    }
    return results;
  }

  // ---------------------------------------------------------------------
  // 1) monthlySales -> "Vivos" vs "Muertos" por las 7 especies con más
  //    personajes. Usado en línea, spline, columna, barra, área, apiladas...
  // ---------------------------------------------------------------------
  static void _buildAliveDeadBySpecies(List<Map<String, dynamic>> characters) {
    final alive = <String, int>{};
    final dead = <String, int>{};
    final totalBySpecies = <String, int>{};

    for (final c in characters) {
      final species = (c['species'] as String?)?.trim().isNotEmpty == true
          ? c['species'] as String
          : 'Desconocida';
      final status = c['status'] as String? ?? 'unknown';

      totalBySpecies[species] = (totalBySpecies[species] ?? 0) + 1;
      if (status == 'Alive') {
        alive[species] = (alive[species] ?? 0) + 1;
      } else if (status == 'Dead') {
        dead[species] = (dead[species] ?? 0) + 1;
      }
    }

    final topSpecies = totalBySpecies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    monthlySales = topSpecies.take(7).map((entry) {
      final species = entry.key;
      return ChartData(
        species,
        (alive[species] ?? 0).toDouble(),
        (dead[species] ?? 0).toDouble(),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------
  // 2) weeklyTemperatureRange -> por temporada, mínimo y máximo de
  //    personajes que aparecen en un mismo episodio. Usado en columna de
  //    rango, área de rango y área de rango spline.
  // ---------------------------------------------------------------------
  static void _buildSeasonEpisodeRange(List<Map<String, dynamic>> episodes) {
    final bySeason = <int, List<int>>{};

    for (final ep in episodes) {
      final season = _seasonNumber(ep['episode'] as String? ?? '');
      final charCount = (ep['characters'] as List).length;
      bySeason.putIfAbsent(season, () => []).add(charCount);
    }

    final seasons = bySeason.keys.toList()..sort();
    weeklyTemperatureRange = seasons.take(7).map((season) {
      final counts = bySeason[season]!;
      final low = counts.reduce((a, b) => a < b ? a : b).toDouble();
      final high = counts.reduce((a, b) => a > b ? a : b).toDouble();
      return RangeData('T$season', low, high);
    }).toList();
  }

  // ---------------------------------------------------------------------
  // 3) stockPrices -> por temporada: personajes en el primer episodio
  //    (open), último episodio (close), y el mínimo/máximo (low/high) de
  //    esa temporada. Usado en vela, hilo y OHLC.
  // ---------------------------------------------------------------------
  static void _buildSeasonOhlc(List<Map<String, dynamic>> episodes) {
    final bySeason = <int, List<Map<String, dynamic>>>{};
    for (final ep in episodes) {
      final season = _seasonNumber(ep['episode'] as String? ?? '');
      bySeason.putIfAbsent(season, () => []).add(ep);
    }

    final seasons = bySeason.keys.toList()..sort();
    stockPrices = seasons.take(6).map((season) {
      final eps = bySeason[season]!
        ..sort((a, b) => (a['episode'] as String).compareTo(b['episode'] as String));
      final counts = eps.map((e) => (e['characters'] as List).length).toList();

      return FinancialData(
        'T$season',
        counts.first.toDouble(),
        counts.reduce((a, b) => a > b ? a : b).toDouble(),
        counts.reduce((a, b) => a < b ? a : b).toDouble(),
        counts.last.toDouble(),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------
  // 4) bubbleMarket -> por tipo de locación: cantidad de locaciones de ese
  //    tipo (size) y promedio de residentes por locación (y). Usado en
  //    burbuja.
  // ---------------------------------------------------------------------
  static void _buildLocationBubbles(List<Map<String, dynamic>> locations) {
    final countByType = <String, int>{};
    final residentSumByType = <String, int>{};

    for (final loc in locations) {
      final type = (loc['type'] as String?)?.trim().isNotEmpty == true
          ? loc['type'] as String
          : 'Desconocido';
      countByType[type] = (countByType[type] ?? 0) + 1;
      residentSumByType[type] =
          (residentSumByType[type] ?? 0) + (loc['residents'] as List).length;
    }

    final topTypes = countByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    bubbleMarket = topTypes.take(5).map((entry) {
      final type = entry.key;
      final count = entry.value;
      final avgResidents = residentSumByType[type]! / count;
      return BubbleChartData(type, avgResidents, count.toDouble());
    }).toList();
  }

  // ---------------------------------------------------------------------
  // 5) marketShare -> top 5 especies por cantidad de personajes. Usado en
  //    pastel, donut y barra radial.
  // ---------------------------------------------------------------------
  static void _buildSpeciesShare(List<Map<String, dynamic>> characters) {
    final countBySpecies = <String, int>{};
    for (final c in characters) {
      final species = (c['species'] as String?)?.trim().isNotEmpty == true
          ? c['species'] as String
          : 'Desconocida';
      countBySpecies[species] = (countBySpecies[species] ?? 0) + 1;
    }

    final sorted = countBySpecies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    marketShare = sorted.take(5).map((e) => CircularData(e.key, e.value.toDouble())).toList();
  }

  // ---------------------------------------------------------------------
  // 6) waterfallBudget -> cómo se compone el total de personajes según su
  //    estado: vivos + muertos + desconocido = total. Usado en cascada.
  // ---------------------------------------------------------------------
  static void _buildStatusWaterfall(List<Map<String, dynamic>> characters) {
    int alive = 0, dead = 0, unknown = 0;
    for (final c in characters) {
      switch (c['status'] as String? ?? 'unknown') {
        case 'Alive':
          alive++;
          break;
        case 'Dead':
          dead++;
          break;
        default:
          unknown++;
      }
    }
    final total = alive + dead + unknown;

    waterfallBudget = [
      WaterfallChartData('Inicio', 0, isTotal: true),
      WaterfallChartData('Vivos', alive.toDouble()),
      WaterfallChartData('Muertos', dead.toDouble()),
      WaterfallChartData('Desconocido', unknown.toDouble()),
      WaterfallChartData('Total', total.toDouble(), isTotal: true),
    ];
  }

  // ---------------------------------------------------------------------
  // 7) histogramValues -> en cuántos episodios aparece cada personaje
  //    (distribución). Usado en histograma.
  // ---------------------------------------------------------------------
  static void _buildEpisodeCountHistogram(List<Map<String, dynamic>> characters) {
    histogramValues =
        characters.map((c) => (c['episode'] as List).length.toDouble()).toList();
  }

  // ---------------------------------------------------------------------
  // 8) boxWhiskerData -> distribución de "en cuántos episodios aparece"
  //    agrupada por estado (Vivo / Muerto / Desconocido). Usado en caja y
  //    bigotes.
  // ---------------------------------------------------------------------
  static void _buildEpisodeCountBoxByStatus(List<Map<String, dynamic>> characters) {
    final byStatus = <String, List<num>>{
      'Vivos': [],
      'Muertos': [],
      'Desconocido': [],
    };

    for (final c in characters) {
      final episodeCount = (c['episode'] as List).length;
      final label = switch (c['status'] as String? ?? 'unknown') {
        'Alive' => 'Vivos',
        'Dead' => 'Muertos',
        _ => 'Desconocido',
      };
      byStatus[label]!.add(episodeCount);
    }

    boxWhiskerData = byStatus.entries.map((e) => BoxData(e.key, e.value)).toList();
  }

  /// Extrae el número de temporada de un código de episodio como "S02E05"
  /// -> 2. Si no matchea, devuelve 0 (se agrupa como "temporada 0").
  static int _seasonNumber(String episodeCode) {
    final match = RegExp(r'S(\d+)E\d+').firstMatch(episodeCode);
    if (match == null) return 0;
    return int.parse(match.group(1)!);
  }
}
