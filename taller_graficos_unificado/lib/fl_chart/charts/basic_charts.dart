// 31 gráficas básicas (B01–B31) de fl_chart: un solo tipo simple (barras,
// líneas, áreas o puntos), una sola serie, estáticas (touch desactivado) y
// con los datos tal como vienen de /character?page=1.
// Misma numeración y tema que el documento de la librería graphic.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'chart_def.dart';

// ---------------------------------------------------------------------------
// Constructores estáticos reutilizados por las básicas
// ---------------------------------------------------------------------------

/// Barras simples: una barra por etiqueta. [colors] colorea cada barra (por
/// categoría); si es null, todas usan [color].
Widget _bars(
  List<String> labels,
  List<num> values, {
  Color color = Colors.teal,
  List<Color>? colors,
  int quarterTurns = 0,
  double labelAngle = 0,
  double labelReserved = 28,
  String? xName,
  String yName = 'Episodios',
  String empty = 'Sin datos',
}) {
  if (values.isEmpty) return emptyChart(empty);
  final maxY = niceMax(values.fold<num>(0, (a, b) => a > b ? a : b));
  return BarChart(
    BarChartData(
      rotationQuarterTurns: quarterTurns,
      maxY: maxY,
      minY: 0,
      alignment: BarChartAlignment.spaceAround,
      barTouchData: const BarTouchData(enabled: false),
      gridData: horizontalGrid,
      borderData: simpleBorder,
      titlesData: basicTitles(
        bottom: categoryTitles(labels, name: xName, angle: labelAngle, reserved: labelReserved),
        left: valueTitles(maxY, name: yName),
      ),
      barGroups: [
        for (var i = 0; i < values.length; i++)
          BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: values[i].toDouble(),
              color: colors != null ? colors[i] : color,
              width: values.length > 12 ? 9 : 16,
              borderRadius: BorderRadius.circular(2),
            ),
          ]),
      ],
    ),
  );
}

/// Barras de episodios por personaje con nombres rotados abajo.
Widget _characterBars(List<FlCharacter> cs, {Color color = Colors.teal, List<Color>? colors, String empty = 'Sin datos'}) =>
    _bars(
      cs.map((c) => c.shortName).toList(),
      cs.map((c) => c.episodeCount).toList(),
      color: color,
      colors: colors,
      labelAngle: -0.9,
      labelReserved: 58,
      empty: empty,
    );

/// Barras de conteo por categoría (estado, género, especie).
Widget _countBars(Map<String, int> counts, Color Function(String) colorOf, String xName) => _bars(
      counts.keys.toList(),
      counts.values.toList(),
      colors: counts.keys.map(colorOf).toList(),
      xName: xName,
      yName: 'Personajes',
    );

/// Línea / área de episodios por ID. Con [area] y [line] se combinan los
/// estilos: solo línea, solo área o área + línea; [dots] agrega los puntos.
Widget _line(
  List<FlCharacter> cs, {
  Color color = Colors.teal,
  bool curved = false,
  bool dots = false,
  bool area = false,
  bool line = true,
  bool step = false,
  double dotRadius = 3,
  String empty = 'Sin datos',
}) {
  if (cs.isEmpty) return emptyChart(empty);
  final maxY = niceMax(cs.map((c) => c.episodeCount).reduce((a, b) => a > b ? a : b));
  final minX = cs.first.id.toDouble();
  final maxX = cs.last.id.toDouble();
  return LineChart(
    LineChartData(
      minX: minX == maxX ? minX - 1 : minX,
      maxX: minX == maxX ? maxX + 1 : maxX,
      minY: 0,
      maxY: maxY,
      lineTouchData: const LineTouchData(enabled: false),
      gridData: horizontalGrid,
      borderData: simpleBorder,
      titlesData: basicTitles(bottom: idTitles(cs.length), left: valueTitles(maxY, name: 'Episodios')),
      lineBarsData: [
        LineChartBarData(
          spots: [for (final c in cs) FlSpot(c.id.toDouble(), c.episodeCount.toDouble())],
          isCurved: curved,
          preventCurveOverShooting: true,
          isStepLineChart: step,
          color: line ? color : Colors.transparent,
          barWidth: 2.5,
          dotData: FlDotData(
            show: dots,
            getDotPainter: (_, _, _, _) => FlDotCirclePainter(
              radius: dotRadius,
              color: color,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(show: area, color: color.withValues(alpha: line ? 0.25 : 0.55)),
        ),
      ],
    ),
  );
}

/// Dispersión de episodios por ID.
Widget _scatter(List<FlCharacter> cs, {Color color = Colors.teal, double radius = 5, String empty = 'Sin datos'}) {
  if (cs.isEmpty) return emptyChart(empty);
  final maxY = niceMax(cs.map((c) => c.episodeCount).reduce((a, b) => a > b ? a : b));
  return ScatterChart(
    ScatterChartData(
      minX: cs.first.id - 1,
      maxX: cs.last.id + 1,
      minY: 0,
      maxY: maxY,
      scatterTouchData: ScatterTouchData(enabled: false),
      gridData: const FlGridData(show: true),
      borderData: simpleBorder,
      titlesData: basicTitles(bottom: idTitles(cs.length), left: valueTitles(maxY, name: 'Episodios')),
      scatterSpots: [
        for (final c in cs)
          ScatterSpot(
            c.id.toDouble(),
            c.episodeCount.toDouble(),
            dotPainter: FlDotCirclePainter(radius: radius, color: color.withValues(alpha: 0.85)),
          ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// B01–B31
// ---------------------------------------------------------------------------

final List<FlChartDef> basicCharts = [
  FlChartDef(
    code: 'B01',
    title: 'Barras verticales: episodios por personaje',
    explanation: 'BarChart con un BarChartGroupData por personaje (IDs 1–20) y una sola BarChartRodData cuya altura '
        '(toY) es el número de episodios. Las etiquetas del eje X se rotan con SideTitleWidget(angle) para que '
        'quepan los 20 nombres. Touch desactivado (BarTouchData(enabled: false)).',
    build: (d) => _characterBars(d.characters),
  ),
  FlChartDef(
    code: 'B02',
    title: 'Barras horizontales: episodios por personaje',
    explanation: 'Los mismos 20 personajes que B01, pero con BarChartData.rotationQuarterTurns: 1: fl_chart gira el '
        'gráfico 90° y las barras crecen hacia la derecha. SideTitleWidget contrarrota las etiquetas, así los '
        'nombres se leen en horizontal a la izquierda.',
    build: (d) => _bars(
      d.characters.map((c) => c.shortName).toList(),
      d.characters.map((c) => c.episodeCount).toList(),
      color: Colors.orange,
      quarterTurns: 1,
      labelReserved: 78,
    ),
  ),
  FlChartDef(
    code: 'B03',
    title: 'Línea: episodios por ID',
    explanation: 'LineChart con una LineChartBarData recta (isCurved: false). Cada FlSpot es (ID, episodios) de los '
        '20 personajes; minX/maxX se ajustan al primer y último ID. Sin puntos ni área: solo la tendencia.',
    build: (d) => _line(d.characters, color: Colors.indigo),
  ),
  FlChartDef(
    code: 'B04',
    title: 'Línea curva: episodios por ID',
    explanation: 'Los mismos datos que B03 con isCurved: true, que traza una curva de Bézier entre los puntos. '
        'preventCurveOverShooting evita que la curva baje de 0 entre dos valores muy distintos.',
    build: (d) => _line(d.characters, color: Colors.purple, curved: true),
  ),
  FlChartDef(
    code: 'B05',
    title: 'Dispersión: episodios vs ID',
    explanation: 'ScatterChart con un ScatterSpot por personaje: X = ID, Y = número de episodios. Cada punto usa '
        'FlDotCirclePainter de radio 5; los datos son los episodios reales, sin desplazamientos aleatorios.',
    build: (d) => _scatter(d.characters),
  ),
  FlChartDef(
    code: 'B06',
    title: 'Área: episodios por ID',
    explanation: 'LineChart con la línea transparente y belowBarData (BarAreaData) visible: lo que se ve es solo el '
        'área rellena bajo los episodios de cada ID.',
    build: (d) => _line(d.characters, color: Colors.blue, area: true, line: false),
  ),
  FlChartDef(
    code: 'B07',
    title: 'Área curva: episodios por ID',
    explanation: 'Igual que B06 pero con isCurved: true: el borde superior del área es una curva suave en lugar de '
        'segmentos rectos.',
    build: (d) => _line(d.characters, color: Colors.teal, area: true, line: false, curved: true),
  ),
  FlChartDef(
    code: 'B08',
    title: 'Conteo por estado',
    explanation: 'Se cuentan los 20 personajes por status (Alive / Dead / unknown) y se dibuja una barra por estado. '
        'Cada barra tiene el color de su categoría (verde, rojo, gris); sigue siendo una sola serie.',
    build: (d) => _countBars(d.byStatus, statusColor, 'Estado'),
  ),
  FlChartDef(
    code: 'B09',
    title: 'Conteo por género',
    explanation: 'Conteo de personajes por gender. Una barra por género con su color (azul Male, rosa Female, '
        'naranja unknown, morado Genderless).',
    build: (d) => _countBars(d.byGender, genderColor, 'Género'),
  ),
  FlChartDef(
    code: 'B10',
    title: 'Conteo por especie',
    explanation: 'Conteo de personajes por species, de mayor a menor. Cada especie toma un color de la paleta de '
        'categorías.',
    build: (d) {
      final keys = d.bySpecies.keys.toList();
      return _countBars(d.bySpecies, (s) => paletteAt(keys.indexOf(s)), 'Especie');
    },
  ),
  FlChartDef(
    code: 'B11',
    title: 'Barras coloreadas por género',
    explanation: 'Episodios por personaje (IDs 1–20) donde el color de cada BarChartRodData depende del género del '
        'personaje. Es una sola serie: el color solo identifica la categoría.',
    build: (d) => _characterBars(d.characters, colors: d.characters.map((c) => genderColor(c.gender)).toList()),
  ),
  FlChartDef(
    code: 'B12',
    title: 'Barras coloreadas por estado',
    explanation: 'Episodios por personaje con el color según el estado (verde vivo, rojo muerto, gris desconocido).',
    build: (d) => _characterBars(d.characters, colors: d.characters.map((c) => statusColor(c.status)).toList()),
  ),
  FlChartDef(
    code: 'B13',
    title: 'Barras apiladas estado × género',
    explanation: 'Una barra por estado con rodStackItems: cada tramo (BarChartRodStackItem fromY→toY) es un género. '
        'Se mantiene en básicas solo para conservar la numeración del documento de graphic (excepción a "sin apilar").',
    build: (d) {
      final statuses = d.statuses;
      final genders = d.genders;
      final maxY = niceMax(d.byStatus.values.fold(0, (m, v) => v > m ? v : m));
      return withLegend(
        BarChart(
          BarChartData(
            maxY: maxY,
            barTouchData: const BarTouchData(enabled: false),
            gridData: horizontalGrid,
            borderData: simpleBorder,
            titlesData: basicTitles(
              bottom: categoryTitles(statuses, name: 'Estado'),
              left: valueTitles(maxY, name: 'Personajes'),
            ),
            barGroups: [
              for (var i = 0; i < statuses.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: d.byStatus[statuses[i]]!.toDouble(),
                    width: 36,
                    borderRadius: BorderRadius.zero,
                    rodStackItems: () {
                      var from = 0.0;
                      return [
                        for (final g in genders)
                          () {
                            final n = d.countStatusGender(statuses[i], g).toDouble();
                            final item = BarChartRodStackItem(from, from + n, genderColor(g));
                            from += n;
                            return item;
                          }(),
                      ];
                    }(),
                  ),
                ]),
            ],
          ),
        ),
        {for (final g in genders) g: genderColor(g)},
      );
    },
  ),
  FlChartDef(
    code: 'B14',
    title: 'Línea + puntos',
    explanation: 'LineChart recto con FlDotData(show: true): además del trazo se dibuja un FlDotCirclePainter en cada '
        'FlSpot (ID, episodios), para ver el valor exacto de cada personaje.',
    build: (d) => _line(d.characters, color: Colors.deepPurple, dots: true),
  ),
  FlChartDef(
    code: 'B15',
    title: 'Área + línea',
    explanation: 'Una sola LineChartBarData con la línea visible y belowBarData semitransparente: el trazo marca el '
        'valor y el área bajo él da sensación de volumen.',
    build: (d) => _line(d.characters, color: Colors.green, area: true),
  ),
  FlChartDef(
    code: 'B16',
    title: 'Histograma por rangos de episodios',
    explanation: 'Se agrupa a los 20 personajes en rangos de episodios (1-5, 6-10, 11-20, 21-30, 31+) y se cuenta '
        'cuántos caen en cada uno. Barras pegadas (groupsSpace pequeño) como un histograma.',
    build: (d) {
      const ranges = ['1-5', '6-10', '11-20', '21-30', '31+'];
      final counts = List.filled(5, 0);
      for (final c in d.characters) {
        final e = c.episodeCount;
        counts[e <= 5 ? 0 : e <= 10 ? 1 : e <= 20 ? 2 : e <= 30 ? 3 : 4]++;
      }
      return _bars(ranges, counts, color: Colors.amber.shade700, xName: 'Episodios', yName: 'Personajes');
    },
  ),
  FlChartDef(
    code: 'B17',
    title: 'Barras ordenadas: top 10 en episodios',
    explanation: 'Los 20 personajes ordenados de mayor a menor número de episodios; se muestran los 10 primeros. '
        'El orden se hace en Dart antes de crear los BarChartGroupData.',
    build: (d) {
      final sorted = [...d.characters]..sort((a, b) => b.episodeCount.compareTo(a.episodeCount));
      return _characterBars(sorted.take(10).toList(), color: Colors.deepOrange);
    },
  ),
  FlChartDef(
    code: 'B18',
    title: 'Barras: solo personajes vivos',
    explanation: 'Filtro status == "Alive" sobre los 20 personajes y una barra de episodios por cada uno.',
    build: (d) => _characterBars(d.where((c) => c.status == 'Alive'), color: Colors.green, empty: 'No hay personajes Alive'),
  ),
  FlChartDef(
    code: 'B19',
    title: 'Barras: solo personajes muertos',
    explanation: 'Filtro status == "Dead": episodios de cada personaje muerto, en rojo.',
    build: (d) => _characterBars(d.where((c) => c.status == 'Dead'), color: Colors.red, empty: 'No hay personajes Dead'),
  ),
  FlChartDef(
    code: 'B20',
    title: 'Línea: solo personajes femeninos',
    explanation: 'Filtro gender == "Female". La línea une los episodios de las personajes femeninas en orden de ID '
        '(el eje X muestra el ID real de cada una).',
    build: (d) => _line(d.where((c) => c.gender == 'Female'), color: Colors.pink, dots: true, empty: 'No hay personajes Female'),
  ),
  FlChartDef(
    code: 'B21',
    title: 'Dispersión: solo personajes masculinos',
    explanation: 'Filtro gender == "Male" y un ScatterSpot (ID, episodios) por cada personaje masculino.',
    build: (d) => _scatter(d.where((c) => c.gender == 'Male'), color: Colors.blue, empty: 'No hay personajes Male'),
  ),
  FlChartDef(
    code: 'B22',
    title: 'Human vs Alien: apariciones totales',
    explanation: 'Dos barras: la suma de episodios en que aparecen los personajes Human y la de los Alien. '
        'Se usa la suma (no el conteo) para no repetir B10, que ya cuenta personajes por especie.',
    build: (d) {
      int total(String s) => d.where((c) => c.species == s).fold(0, (t, c) => t + c.episodeCount);
      return _bars(['Human', 'Alien'], [total('Human'), total('Alien')],
          colors: [Colors.indigo, Colors.cyan], xName: 'Especie', yName: 'Apariciones');
    },
  ),
  FlChartDef(
    code: 'B23',
    title: 'Línea escalonada',
    explanation: 'LineChartBarData con isStepLineChart: true: el valor se mantiene horizontal hasta el siguiente ID '
        'y luego salta, como una escalera.',
    build: (d) => _line(d.characters, color: Colors.lime.shade800, step: true),
  ),
  FlChartDef(
    code: 'B24',
    title: 'Área + línea curvas (naranja)',
    explanation: 'Curva (isCurved: true) naranja con belowBarData del mismo color semitransparente.',
    build: (d) => _line(d.characters, color: Colors.orange, curved: true, area: true),
  ),
  FlChartDef(
    code: 'B25',
    title: 'Barras: IDs 1–10',
    explanation: 'Filtro por ID: solo los personajes 1 al 10, con su número de episodios. A diferencia de B01 '
        '(los 20 IDs), aquí se ve solo la primera mitad de la página.',
    build: (d) => _characterBars(d.idRange(1, 10), color: Colors.teal.shade700),
  ),
  FlChartDef(
    code: 'B26',
    title: 'Puntos grandes',
    explanation: 'Dispersión (ID, episodios) como B05 pero con FlDotCirclePainter de radio 10 para destacar cada '
        'personaje.',
    build: (d) => _scatter(d.characters, color: Colors.purple, radius: 10),
  ),
  FlChartDef(
    code: 'B27',
    title: 'Barras azules: IDs 11–20',
    explanation: 'Barras de un solo color azul con los personajes de ID 11 a 20 (la mitad que no muestra B25).',
    build: (d) => _characterBars(d.idRange(11, 20), color: Colors.blue),
  ),
  FlChartDef(
    code: 'B28',
    title: 'Barras verdes: solo humanos',
    explanation: 'Filtro species == "Human" y barras verdes con los episodios de cada humano.',
    build: (d) => _characterBars(d.where((c) => c.species == 'Human'), color: Colors.green.shade700, empty: 'No hay humanos'),
  ),
  FlChartDef(
    code: 'B29',
    title: 'Barras rojas: solo aliens',
    explanation: 'Filtro species == "Alien" y barras rojas con los episodios de cada alien.',
    build: (d) => _characterBars(d.where((c) => c.species == 'Alien'), color: Colors.red.shade700, empty: 'No hay aliens'),
  ),
  FlChartDef(
    code: 'B30',
    title: 'Línea + puntos: IDs 11–20',
    explanation: 'Línea con puntos (FlDotData) solo para los personajes de ID 11 a 20; minX/maxX van de 11 a 20.',
    build: (d) => _line(d.idRange(11, 20), color: Colors.brown, dots: true),
  ),
  FlChartDef(
    code: 'B31',
    title: 'Área + línea + puntos (cian)',
    explanation: 'Los tres estilos de LineChartBarData a la vez en cian: área (belowBarData), trazo y puntos '
        '(FlDotData).',
    build: (d) => _line(d.characters, color: Colors.cyan.shade700, area: true, dots: true),
  ),
];
