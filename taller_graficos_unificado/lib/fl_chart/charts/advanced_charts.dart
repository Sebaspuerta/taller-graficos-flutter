// 32 gráficas avanzadas (A01–A32) de fl_chart. Cada una cumple al menos una
// condición de avanzada (la explicación dice cuál):
//   [1] tipo no cartesiano      [2] varias series / variables cruzadas
//   [3] interacción             [4] datos transformados en Dart
//   [5] elementos visuales extra [6] datos de /episode o combinados

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/fl_data.dart';
import '../data/models.dart';
import 'chart_def.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Pastel / dona a partir de un conteo. Omite categorías en 0.
Widget _pie(Map<String, int> counts, Color Function(String) colorOf, {double hole = 0}) {
  final entries = counts.entries.where((e) => e.value > 0).toList();
  final total = entries.fold(0, (s, e) => s + e.value);
  if (total == 0) return emptyChart('Sin datos');
  return withLegend(
    PieChart(
      PieChartData(
        centerSpaceRadius: hole,
        sectionsSpace: 2,
        pieTouchData: PieTouchData(enabled: false),
        sections: [
          for (final e in entries)
            PieChartSectionData(
              value: e.value.toDouble(),
              color: colorOf(e.key),
              title: '${e.value}',
              radius: hole > 0 ? 70 : 110,
              titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
            ),
        ],
      ),
    ),
    {for (final e in entries) '${e.key} (${(e.value * 100 / total).toStringAsFixed(0)} %)': colorOf(e.key)},
  );
}

/// Nombres cortos de los 20 personajes (eje X de las gráficas por personaje).
List<String> _names(List<FlCharacter> cs) => cs.map((c) => c.shortName).toList();

AxisTitles _nameTitles(List<FlCharacter> cs) => categoryTitles(_names(cs), angle: -0.9, reserved: 58);

double _maxOf(Iterable<num> values) => values.isEmpty ? 0 : values.map((v) => v.toDouble()).reduce(math.max);

/// LineChartData base: X = ID, Y = episodios, con touch desactivado.
LineChartData _idLineData(
  List<FlCharacter> cs,
  List<LineChartBarData> bars, {
  double? maxY,
  ExtraLinesData? extraLines,
  LineTouchData? touch,
}) {
  final top = maxY ?? niceMax(_maxOf(cs.map((c) => c.episodeCount)));
  return LineChartData(
    minX: cs.first.id.toDouble(),
    maxX: cs.last.id.toDouble(),
    minY: 0,
    maxY: top,
    lineTouchData: touch ?? const LineTouchData(enabled: false),
    extraLinesData: extraLines,
    gridData: horizontalGrid,
    borderData: simpleBorder,
    titlesData: basicTitles(bottom: idTitles(cs.length), left: valueTitles(top, name: 'Episodios')),
    lineBarsData: bars,
  );
}

List<FlSpot> _episodeSpots(List<FlCharacter> cs) =>
    [for (final c in cs) FlSpot(c.id.toDouble(), c.episodeCount.toDouble())];

/// Etiquetas "T1".."T5" para las temporadas.
List<String> _seasonLabels(FlData d) => d.seasons.map((s) => 'T$s').toList();

/// Barras simples sin interacción a partir de valores (para A25 / A26).
BarChartData _plainBars(List<num> values, AxisTitles bottom, Color color, String yName, {double width = 18}) {
  final maxY = niceMax(_maxOf(values));
  return BarChartData(
    maxY: maxY,
    barTouchData: const BarTouchData(enabled: false),
    gridData: horizontalGrid,
    borderData: simpleBorder,
    titlesData: basicTitles(bottom: bottom, left: valueTitles(maxY, name: yName)),
    barGroups: [
      for (var i = 0; i < values.length; i++)
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: values[i].toDouble(), color: color, width: width, borderRadius: BorderRadius.circular(2)),
        ]),
    ],
  );
}

/// Barra apilada a partir de tramos (valor, color) consecutivos.
BarChartRodData _stackedRod(List<(double, Color)> parts, {double width = 32}) {
  var from = 0.0;
  final items = <BarChartRodStackItem>[];
  for (final (value, color) in parts) {
    items.add(BarChartRodStackItem(from, from + value, color));
    from += value;
  }
  return BarChartRodData(toY: from, width: width, borderRadius: BorderRadius.zero, rodStackItems: items, color: Colors.transparent);
}

// ---------------------------------------------------------------------------
// A01–A32
// ---------------------------------------------------------------------------

final List<FlChartDef> advancedCharts = [
  FlChartDef(
    code: 'A01',
    title: 'Pastel: personajes por estado',
    explanation: 'PieChart con un PieChartSectionData por estado; el ángulo de cada sector es su conteo y la leyenda '
        'muestra el porcentaje. Condición avanzada: [1] tipo no cartesiano (pastel).',
    build: (d) => _pie(d.byStatus, statusColor),
  ),
  FlChartDef(
    code: 'A02',
    title: 'Pastel: personajes por género',
    explanation: 'Un sector por género con los colores de la paleta de género (azul, rosa, naranja, morado). '
        'Condición avanzada: [1] tipo no cartesiano (pastel).',
    build: (d) => _pie(d.byGender, genderColor),
  ),
  FlChartDef(
    code: 'A03',
    title: 'Pastel: personajes por especie',
    explanation: 'Un sector por especie, de mayor a menor. Condición avanzada: [1] tipo no cartesiano (pastel).',
    build: (d) {
      final keys = d.bySpecies.keys.toList();
      return _pie(d.bySpecies, (s) => paletteAt(keys.indexOf(s)));
    },
  ),
  FlChartDef(
    code: 'A04',
    title: 'Dona: personajes por rango de episodios',
    explanation: 'PieChartData.centerSpaceRadius deja un hueco central y convierte el pastel en dona. Muestra cuántos '
        'personajes caen en cada rango de episodios (1-5, 6-10, 11-20, 21-30, 31+). '
        'Condición avanzada: [1] tipo no cartesiano (dona).',
    build: (d) {
      const ranges = ['1-5', '6-10', '11-20', '21-30', '31+'];
      final counts = {for (final r in ranges) r: 0};
      for (final c in d.characters) {
        final e = c.episodeCount;
        final r = ranges[e <= 5 ? 0 : e <= 10 ? 1 : e <= 20 ? 2 : e <= 30 ? 3 : 4];
        counts[r] = counts[r]! + 1;
      }
      return _pie(counts, (r) => paletteAt(ranges.indexOf(r)), hole: 55);
    },
  ),
  FlChartDef(
    code: 'A05',
    title: 'Pastel interactivo: estado × género',
    explanation: 'Un sector por cada combinación estado·género presente. PieTouchData.touchCallback guarda el sector '
        'tocado en el estado del widget y ese sector crece (radius) y muestra su etiqueta. '
        'Condición avanzada: [1] pastel, [2] variables cruzadas, [3] interacción (sector que se resalta).',
    build: (d) => _TouchPie(data: d),
  ),
  FlChartDef(
    code: 'A06',
    title: 'Radar: estado por género',
    explanation: 'RadarChart con 3 ejes (Alive, Dead, unknown) y un RadarDataSet por género: cada polígono muestra '
        'cuántos personajes de ese género hay en cada estado. '
        'Condición avanzada: [1] tipo no cartesiano (radar), [2] varias series (una por género).',
    build: (d) {
      final genders = d.genders;
      return withLegend(
        RadarChart(
          RadarChartData(
            radarShape: RadarShape.polygon,
            radarTouchData: RadarTouchData(enabled: false),
            tickCount: 3,
            ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.black45),
            titleTextStyle: const TextStyle(fontSize: 12),
            getTitle: (i, _) => RadarChartTitle(text: statusOrder[i]),
            dataSets: [
              for (final g in genders)
                RadarDataSet(
                  borderColor: genderColor(g),
                  fillColor: genderColor(g).withValues(alpha: 0.2),
                  entryRadius: 3,
                  dataEntries: [
                    for (final s in statusOrder) RadarEntry(value: d.countStatusGender(s, g).toDouble()),
                  ],
                ),
            ],
          ),
        ),
        {for (final g in genders) g: genderColor(g)},
      );
    },
  ),
  FlChartDef(
    code: 'A07',
    title: 'Radar: Rick, Morty y Summer por temporada',
    explanation: 'Un eje por temporada (T1–T5) y un RadarDataSet por personaje (IDs 1, 2 y 3). El valor de cada eje es '
        'en cuántos episodios de esa temporada aparece, cruzando la lista episode del personaje con /episode. '
        'Condición avanzada: [1] radar, [2] varias series, [6] datos combinados con /episode.',
    build: (d) {
      final seasons = d.seasons;
      final chars = [d.byId(1), d.byId(2), d.byId(3)].whereType<FlCharacter>().toList();
      if (seasons.length < 3 || chars.isEmpty) return emptyChart('Faltan temporadas o personajes');
      const colors = [Colors.cyan, Colors.amber, Colors.pink];
      return withLegend(
        RadarChart(
          RadarChartData(
            radarTouchData: RadarTouchData(enabled: false),
            tickCount: 4,
            ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.black45),
            titleTextStyle: const TextStyle(fontSize: 12),
            getTitle: (i, _) => RadarChartTitle(text: 'T${seasons[i]}'),
            dataSets: [
              for (var k = 0; k < chars.length; k++)
                RadarDataSet(
                  borderColor: colors[k],
                  fillColor: colors[k].withValues(alpha: 0.15),
                  entryRadius: 3,
                  dataEntries: [
                    for (final s in seasons) RadarEntry(value: d.appearancesInSeason(chars[k], s).toDouble()),
                  ],
                ),
            ],
          ),
        ),
        {for (var k = 0; k < chars.length; k++) chars[k].name: colors[k]},
      );
    },
  ),
  FlChartDef(
    code: 'A08',
    title: 'Barras agrupadas: estado × género',
    explanation: 'Un BarChartGroupData por estado con varias BarChartRodData lado a lado (una por género, barsSpace). '
        'Condición avanzada: [2] variables cruzadas (barras agrupadas estado × género).',
    build: (d) {
      final statuses = d.statuses;
      final genders = d.genders;
      final maxY = niceMax(_maxOf([for (final s in statuses) for (final g in genders) d.countStatusGender(s, g)]));
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
                BarChartGroupData(x: i, barsSpace: 3, barRods: [
                  for (final g in genders)
                    BarChartRodData(
                      toY: d.countStatusGender(statuses[i], g).toDouble(),
                      color: genderColor(g),
                      width: 12,
                      borderRadius: BorderRadius.circular(2),
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
    code: 'A09',
    title: 'Barras apiladas horizontales: género × estado',
    explanation: 'Una barra por género, apilada por estado (rodStackItems) y girada con rotationQuarterTurns: 1. '
        'Es el cruce inverso de B13 (allí el eje es el estado). Condición avanzada: [2] variables cruzadas.',
    build: (d) {
      final genders = d.genders;
      final statuses = d.statuses;
      final maxY = niceMax(_maxOf(d.byGender.values));
      return withLegend(
        BarChart(
          BarChartData(
            rotationQuarterTurns: 1,
            maxY: maxY,
            barTouchData: const BarTouchData(enabled: false),
            gridData: horizontalGrid,
            borderData: simpleBorder,
            titlesData: basicTitles(
              bottom: categoryTitles(genders, reserved: 72),
              left: valueTitles(maxY, name: 'Personajes'),
            ),
            barGroups: [
              for (var i = 0; i < genders.length; i++)
                BarChartGroupData(x: i, barRods: [
                  _stackedRod([
                    for (final s in statuses) (d.countStatusGender(s, genders[i]).toDouble(), statusColor(s)),
                  ], width: 28),
                ]),
            ],
          ),
        ),
        {for (final s in statuses) s: statusColor(s)},
      );
    },
  ),
  FlChartDef(
    code: 'A10',
    title: 'Apiladas al 100 %: estado dentro de cada especie',
    explanation: 'Para cada especie se calcula en Dart el porcentaje de personajes Alive / Dead / unknown '
        '(conteo × 100 / total de la especie) y se apila hasta 100. '
        'Condición avanzada: [2] variables cruzadas, [4] porcentajes calculados en Dart.',
    build: (d) {
      final species = d.bySpecies.keys.toList();
      final statuses = d.statuses;
      return withLegend(
        BarChart(
          BarChartData(
            maxY: 100,
            barTouchData: const BarTouchData(enabled: false),
            gridData: horizontalGrid,
            borderData: simpleBorder,
            titlesData: basicTitles(
              bottom: categoryTitles(species, name: 'Especie'),
              left: AxisTitles(
                axisNameWidget: const Text('%', style: TextStyle(fontSize: 11)),
                axisNameSize: 18,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 25,
                  getTitlesWidget: (v, meta) => axisLabel(meta, '${v.toInt()}'),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < species.length; i++)
                BarChartGroupData(x: i, barRods: [
                  () {
                    final total = d.bySpecies[species[i]]!;
                    return _stackedRod([
                      for (final s in statuses)
                        (
                          total == 0
                              ? 0.0
                              : d.where((c) => c.species == species[i] && c.status == s).length * 100 / total,
                          statusColor(s),
                        ),
                    ], width: 40);
                  }(),
                ]),
            ],
          ),
        ),
        {for (final s in statuses) s: statusColor(s)},
      );
    },
  ),
  FlChartDef(
    code: 'A11',
    title: 'Barras con tooltip al tocar',
    explanation: 'BarTouchData con touchTooltipData: al tocar una barra aparece un globo con el nombre completo y los '
        'episodios (getTooltipItem). handleBuiltInTouches se encarga de mostrarlo y ocultarlo. '
        'Condición avanzada: [3] interacción (tooltip).',
    build: (d) {
      final cs = d.characters;
      final maxY = niceMax(_maxOf(cs.map((c) => c.episodeCount)));
      return BarChart(
        BarChartData(
          maxY: maxY,
          gridData: horizontalGrid,
          borderData: simpleBorder,
          titlesData: basicTitles(bottom: _nameTitles(cs), left: valueTitles(maxY, name: 'Episodios')),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                '${cs[group.x].name}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                children: [
                  TextSpan(text: '${rod.toY.toInt()} episodios', style: const TextStyle(color: Colors.amberAccent)),
                ],
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < cs.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: cs[i].episodeCount.toDouble(), color: Colors.indigo, width: 9),
              ]),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A12',
    title: 'Barras con gradiente: conteo por estado',
    explanation: 'Cada BarChartRodData usa gradient (LinearGradient de abajo hacia arriba) en lugar de un color '
        'plano, del tono oscuro al claro del color de su estado. Condición avanzada: [5] gradientes.',
    build: (d) {
      final statuses = d.statuses;
      final maxY = niceMax(_maxOf(d.byStatus.values));
      return BarChart(
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
                  width: 40,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.lerp(statusColor(statuses[i]), Colors.black, 0.35)!,
                      Color.lerp(statusColor(statuses[i]), Colors.white, 0.45)!,
                    ],
                  ),
                ),
              ]),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A13',
    title: 'Barras con fondo: episodios sobre el total de la serie',
    explanation: 'backDrawRodData dibuja detrás de cada barra un fondo hasta el total de episodios de la serie '
        '(longitud de /episode), así se ve qué fracción de la serie aparece cada personaje. '
        'Condición avanzada: [5] elemento visual extra (barra de fondo), [6] total tomado de /episode.',
    build: (d) {
      final cs = d.characters;
      final total = d.episodes.length.toDouble();
      final maxY = niceMax(total);
      return BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: const BarTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: simpleBorder,
          titlesData: basicTitles(bottom: _nameTitles(cs), left: valueTitles(maxY, name: 'Episodios')),
          barGroups: [
            for (var i = 0; i < cs.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: cs[i].episodeCount.toDouble(),
                  color: Colors.teal,
                  width: 9,
                  backDrawRodData: BackgroundBarChartRodData(show: true, toY: total, color: Colors.teal.withValues(alpha: 0.12)),
                ),
              ]),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A14',
    title: 'Línea con tooltip y línea guía',
    explanation: 'LineTouchData con getTouchedSpotIndicator: al tocar se dibuja una línea guía vertical punteada hasta '
        'el punto y un tooltip (LineTouchTooltipData) con el nombre y los episodios. '
        'Condición avanzada: [3] interacción (tooltip + línea guía).',
    build: (d) {
      final cs = d.characters;
      return LineChart(
        _idLineData(
          cs,
          [
            LineChartBarData(
              spots: _episodeSpots(cs),
              color: Colors.deepPurple,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
            ),
          ],
          touch: LineTouchData(
            getTouchedSpotIndicator: (bar, indexes) => [
              for (final _ in indexes)
                TouchedSpotIndicatorData(
                  const FlLine(color: Colors.deepPurple, strokeWidth: 1.5, dashArray: [4, 4]),
                  FlDotData(
                    getDotPainter: (_, _, _, _) =>
                        FlDotCirclePainter(radius: 6, color: Colors.white, strokeWidth: 3, strokeColor: Colors.deepPurple),
                  ),
                ),
            ],
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              fitInsideHorizontally: true,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${d.byId(s.x.toInt())?.name ?? 'ID ${s.x.toInt()}'}\n${s.y.toInt()} episodios',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A15',
    title: 'Línea con promedio',
    explanation: 'Se calcula en Dart el promedio de episodios de los 20 personajes y se dibuja como HorizontalLine '
        'en extraLinesData, con etiqueta. Los puntos sobre la línea están por encima del promedio. '
        'Condición avanzada: [4] promedio calculado en Dart, [5] línea de referencia.',
    build: (d) {
      final cs = d.characters;
      final avg = d.averageEpisodes;
      return LineChart(
        _idLineData(
          cs,
          [
            LineChartBarData(spots: _episodeSpots(cs), color: Colors.blue, barWidth: 2.5, dotData: const FlDotData(show: true)),
          ],
          extraLines: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: avg,
              color: Colors.red,
              strokeWidth: 2,
              dashArray: [6, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                labelResolver: (_) => 'Promedio ${avg.toStringAsFixed(1)}',
              ),
            ),
          ]),
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A16',
    title: 'Varias líneas: apariciones por temporada según estado',
    explanation: 'Tres LineChartBarData (Alive, Dead, unknown). En cada temporada se suman los episodios de esa '
        'temporada en los que aparecen los personajes de cada estado (cruce con /episode). '
        'Condición avanzada: [2] varias líneas, [6] datos combinados con /episode.',
    build: (d) {
      final seasons = d.seasons;
      final statuses = d.statuses;
      if (seasons.isEmpty) return emptyChart('Sin episodios');
      final series = {
        for (final s in statuses)
          s: [
            for (final t in seasons)
              d.where((c) => c.status == s).fold(0, (sum, c) => sum + d.appearancesInSeason(c, t)),
          ],
      };
      final maxY = niceMax(_maxOf(series.values.expand((v) => v)));
      return withLegend(
        LineChart(
          LineChartData(
            minX: 0,
            maxX: seasons.length - 1,
            minY: 0,
            maxY: maxY,
            lineTouchData: const LineTouchData(enabled: false),
            gridData: horizontalGrid,
            borderData: simpleBorder,
            titlesData: basicTitles(
              bottom: categoryTitles(_seasonLabels(d), name: 'Temporada'),
              left: valueTitles(maxY, name: 'Apariciones'),
            ),
            lineBarsData: [
              for (final s in statuses)
                LineChartBarData(
                  spots: [for (var i = 0; i < seasons.length; i++) FlSpot(i.toDouble(), series[s]![i].toDouble())],
                  color: statusColor(s),
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
            ],
          ),
        ),
        {for (final s in statuses) s: statusColor(s)},
      );
    },
  ),
  FlChartDef(
    code: 'A17',
    title: 'Área entre dos líneas: episodios de la temporada vs Jerry',
    explanation: 'Línea superior: episodios de cada temporada (/episode). Línea inferior: en cuántos aparece Jerry '
        '(ID 5). betweenBarsData rellena el área entre ambas = episodios sin Jerry. '
        'Condición avanzada: [2] dos series, [5] área entre dos líneas, [6] /episode.',
    build: (d) {
      final seasons = d.seasons;
      final jerry = d.byId(5);
      if (seasons.isEmpty || jerry == null) return emptyChart('Sin datos');
      final total = [for (final s in seasons) d.episodesOfSeason(s).length];
      final withJerry = [for (final s in seasons) d.appearancesInSeason(jerry, s)];
      final maxY = niceMax(_maxOf(total));
      List<FlSpot> spots(List<int> v) => [for (var i = 0; i < v.length; i++) FlSpot(i.toDouble(), v[i].toDouble())];
      return withLegend(
        LineChart(
          LineChartData(
            minX: 0,
            maxX: seasons.length - 1,
            minY: 0,
            maxY: maxY,
            lineTouchData: const LineTouchData(enabled: false),
            gridData: horizontalGrid,
            borderData: simpleBorder,
            titlesData: basicTitles(
              bottom: categoryTitles(_seasonLabels(d), name: 'Temporada'),
              left: valueTitles(maxY, name: 'Episodios'),
            ),
            betweenBarsData: [BetweenBarsData(fromIndex: 0, toIndex: 1, color: Colors.orange.withValues(alpha: 0.3))],
            lineBarsData: [
              LineChartBarData(spots: spots(total), color: Colors.indigo, barWidth: 3),
              LineChartBarData(spots: spots(withJerry), color: Colors.orange.shade800, barWidth: 3),
            ],
          ),
        ),
        {'Episodios de la temporada': Colors.indigo, 'Con ${jerry.name}': Colors.orange.shade800},
      );
    },
  ),
  FlChartDef(
    code: 'A18',
    title: 'Línea punteada: temporadas en que aparece cada personaje',
    explanation: 'Para cada personaje se cuentan las temporadas distintas de sus episodios (cruce con /episode) y se '
        'traza con LineChartBarData.dashArray [8, 5]. Condición avanzada: [5] línea punteada, [6] /episode.',
    build: (d) {
      final cs = d.characters;
      final maxY = niceMax(_maxOf(d.seasons));
      return LineChart(
        LineChartData(
          minX: cs.first.id.toDouble(),
          maxX: cs.last.id.toDouble(),
          minY: 0,
          maxY: maxY,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: horizontalGrid,
          borderData: simpleBorder,
          titlesData: basicTitles(bottom: idTitles(cs.length), left: valueTitles(maxY, name: 'Temporadas')),
          lineBarsData: [
            LineChartBarData(
              spots: [for (final c in cs) FlSpot(c.id.toDouble(), d.seasonsOf(c).toDouble())],
              color: Colors.brown,
              barWidth: 2.5,
              dashArray: [8, 5],
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A19',
    title: 'Línea con gradiente',
    explanation: 'LineChartBarData.gradient pinta el trazo con un LinearGradient vertical: rojo en los valores bajos '
        'y verde en los altos, así el color refuerza la altura. Condición avanzada: [5] gradiente.',
    build: (d) {
      final cs = d.characters;
      return LineChart(
        _idLineData(cs, [
          LineChartBarData(
            spots: _episodeSpots(cs),
            isCurved: true,
            preventCurveOverShooting: true,
            barWidth: 4,
            isStrokeCapRound: true,
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.red, Colors.amber, Colors.green],
            ),
            dotData: const FlDotData(show: false),
          ),
        ]),
      );
    },
  ),
  FlChartDef(
    code: 'A20',
    title: 'Área con gradiente',
    explanation: 'belowBarData con gradient: el área bajo la curva se desvanece de violeta intenso a transparente. '
        'Condición avanzada: [5] gradiente en el área.',
    build: (d) {
      final cs = d.characters;
      return LineChart(
        _idLineData(cs, [
          LineChartBarData(
            spots: _episodeSpots(cs),
            isCurved: true,
            preventCurveOverShooting: true,
            color: Colors.deepPurple,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple.withValues(alpha: 0.7), Colors.deepPurple.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ]),
      );
    },
  ),
  FlChartDef(
    code: 'A21',
    title: 'Burbujas: temporadas vs ID, tamaño = episodios',
    explanation: 'ScatterChart donde X = ID, Y = temporadas en que aparece (desde /episode) y el radio del '
        'FlDotCirclePainter es proporcional a la raíz de sus episodios (área ∝ episodios). '
        'Condición avanzada: [5] tamaño del punto según un dato (burbujas), [6] /episode.',
    build: (d) {
      final cs = d.characters;
      final maxEp = math.max(1, d.maxEpisodes);
      final maxY = d.seasons.length + 1.0;
      return ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: cs.last.id + 1.0,
          minY: 0,
          maxY: maxY,
          scatterTouchData: ScatterTouchData(enabled: false),
          gridData: const FlGridData(show: true),
          borderData: simpleBorder,
          titlesData: basicTitles(bottom: idTitles(cs.length), left: valueTitles(maxY, name: 'Temporadas')),
          scatterSpots: [
            for (final c in cs)
              ScatterSpot(
                c.id.toDouble(),
                d.seasonsOf(c).toDouble(),
                dotPainter: FlDotCirclePainter(
                  radius: 3 + 15 * math.sqrt(c.episodeCount / maxEp),
                  color: Colors.teal.withValues(alpha: 0.45),
                  strokeWidth: 1,
                  strokeColor: Colors.teal.shade900,
                ),
              ),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A22',
    title: 'Dispersión coloreada por estado',
    explanation: 'Dispersión (ID, episodios) donde cada estado es una serie con su color (verde, rojo, gris) y '
        'leyenda. Condición avanzada: [2] varias series (una por estado).',
    build: (d) {
      final cs = d.characters;
      final maxY = niceMax(d.maxEpisodes);
      return withLegend(
        ScatterChart(
          ScatterChartData(
            minX: 0,
            maxX: cs.last.id + 1.0,
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
                  dotPainter: FlDotCirclePainter(radius: 7, color: statusColor(c.status)),
                ),
            ],
          ),
        ),
        {for (final s in d.statuses) s: statusColor(s)},
      );
    },
  ),
  FlChartDef(
    code: 'A23',
    title: 'Dispersión con tooltip: debut vs última aparición',
    explanation: 'X = episodio de debut y Y = último episodio de cada personaje. ScatterTouchData muestra al tocar un '
        'punto un tooltip (getTooltipItems) con el nombre y el rango de episodios. '
        'Condición avanzada: [3] interacción (tooltip).',
    build: (d) {
      final cs = d.where((c) => c.episodeIds.isNotEmpty);
      if (cs.isEmpty) return emptyChart('Sin datos');
      final maxV = niceMax(_maxOf(cs.expand((c) => c.episodeIds)));
      final byPoint = <(double, double), List<FlCharacter>>{};
      for (final c in cs) {
        byPoint.putIfAbsent((c.episodeIds.reduce(math.min).toDouble(), c.episodeIds.reduce(math.max).toDouble()), () => []).add(c);
      }
      return ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: maxV,
          minY: 0,
          maxY: maxV,
          gridData: const FlGridData(show: true),
          borderData: simpleBorder,
          titlesData: basicTitles(
            bottom: valueTitles(maxV, name: 'Episodio de debut', reserved: 24),
            left: valueTitles(maxV, name: 'Último episodio'),
          ),
          scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (spot) => ScatterTooltipItem(
                '${byPoint[(spot.x, spot.y)]?.map((c) => c.name).join(', ') ?? ''}\n'
                'Ep. ${spot.x.toInt()} → ${spot.y.toInt()}',
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          scatterSpots: [
            for (final p in byPoint.keys)
              ScatterSpot(p.$1, p.$2, dotPainter: FlDotCirclePainter(radius: 7, color: Colors.indigo.withValues(alpha: 0.8))),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A24',
    title: 'Barras positivas y negativas: episodios − promedio',
    explanation: 'Para cada personaje se calcula en Dart episodios − promedio del grupo. Las barras crecen hacia arriba '
        '(verde, por encima del promedio) o hacia abajo (rojo) desde el 0, con minY negativo. '
        'Condición avanzada: [4] diferencia contra el promedio calculada en Dart.',
    build: (d) {
      final cs = d.characters;
      final avg = d.averageEpisodes;
      final diffs = [for (final c in cs) c.episodeCount - avg];
      final limit = niceMax(_maxOf(diffs.map((v) => v.abs())));
      return BarChart(
        BarChartData(
          maxY: limit,
          minY: -limit,
          barTouchData: const BarTouchData(enabled: false),
          gridData: horizontalGrid,
          borderData: simpleBorder,
          extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0, color: Colors.black54, strokeWidth: 1)]),
          titlesData: basicTitles(bottom: _nameTitles(cs), left: valueTitles(limit, name: 'Diferencia')),
          barGroups: [
            for (var i = 0; i < cs.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: diffs[i],
                  color: diffs[i] >= 0 ? Colors.green : Colors.red,
                  width: 9,
                ),
              ]),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A25',
    title: 'Episodios por temporada (/episode)',
    explanation: 'Se descargan todas las páginas de /episode siguiendo info.next, se lee la temporada del código '
        '"SxxEyy" y se cuentan los episodios de cada una. Condición avanzada: [6] datos de otro endpoint.',
    build: (d) {
      final seasons = d.seasons;
      if (seasons.isEmpty) return emptyChart('Sin episodios');
      return BarChart(_plainBars(
        [for (final s in seasons) d.episodesOfSeason(s).length],
        categoryTitles(_seasonLabels(d), name: 'Temporada'),
        Colors.deepPurple,
        'Episodios',
        width: 28,
      ));
    },
  ),
  FlChartDef(
    code: 'A26',
    title: 'Personajes por episodio (51 episodios)',
    explanation: 'Una barra delgada por cada episodio de /episode cuya altura es la longitud de su lista characters. '
        'El eje X muestra el número de episodio cada 5. Condición avanzada: [6] datos de otro endpoint.',
    build: (d) {
      final eps = [...d.episodes]..sort((a, b) => a.id.compareTo(b.id));
      if (eps.isEmpty) return emptyChart('Sin episodios');
      return BarChart(_plainBars(
        [for (final e in eps) e.characterCount],
        categoryTitles([for (final e in eps) '${e.id}'], name: 'Episodio', every: 5),
        Colors.cyan.shade700,
        'Personajes',
        width: 3,
      ));
    },
  ),
  FlChartDef(
    code: 'A27',
    title: 'Acumulado de episodios por ID',
    explanation: 'Se calcula en Dart la suma acumulada de episodios: el valor en el ID n es la suma de los episodios '
        'de los personajes 1..n. La pendiente muestra qué personajes aportan más. '
        'Condición avanzada: [4] acumulado calculado en Dart.',
    build: (d) {
      final cs = d.characters;
      var acc = 0;
      final spots = [
        for (final c in cs) FlSpot(c.id.toDouble(), (acc += c.episodeCount).toDouble()),
      ];
      final maxY = niceMax(acc);
      return LineChart(
        _idLineData(cs, [
          LineChartBarData(
            spots: spots,
            color: Colors.orange.shade800,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.orange.withValues(alpha: 0.2)),
          ),
        ], maxY: maxY),
      );
    },
  ),
  FlChartDef(
    code: 'A28',
    title: 'Barras con etiquetas: apariciones por temporada',
    explanation: 'Suma, por temporada, de los episodios en que aparecen los 20 personajes (cruce con /episode). '
        'BarChartRodLabel escribe el valor encima de cada barra. '
        'Condición avanzada: [5] etiquetas de valor, [6] /episode.',
    build: (d) {
      final seasons = d.seasons;
      if (seasons.isEmpty) return emptyChart('Sin episodios');
      final values = [
        for (final s in seasons) d.characters.fold(0, (sum, c) => sum + d.appearancesInSeason(c, s)),
      ];
      final maxY = niceMax(_maxOf(values) * 1.1);
      return BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: const BarTouchData(enabled: false),
          gridData: horizontalGrid,
          borderData: simpleBorder,
          titlesData: basicTitles(
            bottom: categoryTitles(_seasonLabels(d), name: 'Temporada'),
            left: valueTitles(maxY, name: 'Apariciones'),
          ),
          barGroups: [
            for (var i = 0; i < values.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: values[i].toDouble(),
                  color: Colors.teal,
                  width: 30,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  label: BarChartRodLabel(
                    show: true,
                    text: '${values[i]}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    offset: const Offset(0, -14),
                  ),
                ),
              ]),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A29',
    title: 'Línea con zonas resaltadas por temporada',
    explanation: 'Personajes por episodio (51 episodios de /episode). rangeAnnotations agrega una '
        'VerticalRangeAnnotation por temporada con colores alternos, para ver dónde empieza y termina cada una. '
        'Condición avanzada: [5] zonas resaltadas, [6] /episode.',
    build: (d) {
      final eps = [...d.episodes]..sort((a, b) => a.id.compareTo(b.id));
      if (eps.isEmpty) return emptyChart('Sin episodios');
      final maxY = niceMax(_maxOf(eps.map((e) => e.characterCount)));
      final seasons = d.seasons;
      return LineChart(
        LineChartData(
          minX: eps.first.id.toDouble(),
          maxX: eps.last.id.toDouble(),
          minY: 0,
          maxY: maxY,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: horizontalGrid,
          borderData: simpleBorder,
          rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: [
            for (var i = 0; i < seasons.length; i++)
              () {
                final inSeason = d.episodesOfSeason(seasons[i]);
                return VerticalRangeAnnotation(
                  x1: inSeason.first.id - 0.5,
                  x2: inSeason.last.id + 0.5,
                  color: paletteAt(i).withValues(alpha: 0.15),
                );
              }(),
          ]),
          titlesData: basicTitles(
            bottom: AxisTitles(
              axisNameWidget: const Text('Episodio (franjas = temporadas)', style: TextStyle(fontSize: 11)),
              axisNameSize: 18,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 5,
                getTitlesWidget: (v, meta) => axisLabel(meta, '${v.toInt()}'),
              ),
            ),
            left: valueTitles(maxY, name: 'Personajes'),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (final e in eps) FlSpot(e.id.toDouble(), e.characterCount.toDouble())],
              color: Colors.black87,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A30',
    title: 'Velas: personajes por episodio en cada temporada',
    explanation: 'CandlestickChart con una vela por temporada calculada en Dart desde /episode: apertura = personajes '
        'del primer episodio, cierre = del último, máximo y mínimo = episodios con más y menos personajes. Verde si '
        'cierra por encima de la apertura. Condición avanzada: [1] velas, [4] rangos mín/máx, [6] /episode.',
    build: (d) {
      final seasons = d.seasons;
      if (seasons.isEmpty) return emptyChart('Sin episodios');
      final spots = <CandlestickSpot>[];
      for (final s in seasons) {
        final eps = d.episodesOfSeason(s);
        if (eps.isEmpty) continue;
        final counts = eps.map((e) => e.characterCount.toDouble()).toList();
        spots.add(CandlestickSpot(
          x: s.toDouble(),
          open: counts.first,
          close: counts.last,
          high: counts.reduce(math.max),
          low: counts.reduce(math.min),
        ));
      }
      final maxY = niceMax(_maxOf(spots.map((s) => s.high)));
      return CandlestickChart(
        CandlestickChartData(
          candlestickSpots: spots,
          minX: seasons.first - 0.6,
          maxX: seasons.last + 0.6,
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: simpleBorder,
          candlestickTouchData: CandlestickTouchData(enabled: false),
          titlesData: basicTitles(
            bottom: AxisTitles(
              axisNameWidget: const Text('Temporada', style: TextStyle(fontSize: 11)),
              axisNameSize: 18,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 1,
                getTitlesWidget: (v, meta) => v == v.roundToDouble() && seasons.contains(v.toInt())
                    ? axisLabel(meta, 'T${v.toInt()}')
                    : const SizedBox.shrink(),
              ),
            ),
            left: valueTitles(maxY, name: 'Personajes'),
          ),
          candlestickPainter: DefaultCandlestickPainter(
            candlestickStyleProvider: (spot, _) {
              final up = spot.close >= spot.open;
              final c = up ? Colors.green.shade700 : Colors.red.shade700;
              return CandlestickStyle(
                lineColor: c,
                lineWidth: 2,
                bodyStrokeColor: c,
                bodyStrokeWidth: 1,
                bodyFillColor: c.withValues(alpha: 0.6),
                bodyWidth: 26,
                bodyRadius: 3,
              );
            },
          ),
        ),
      );
    },
  ),
  FlChartDef(
    code: 'A31',
    title: 'Combinación barras + línea',
    explanation: 'fl_chart no mezcla tipos en un mismo gráfico, así que se superponen un BarChart (episodios totales) '
        'y un LineChart (episodios en la temporada 1, desde /episode) en un Stack con el mismo maxY y los mismos '
        'espacios de ejes; minX = -0.5 y maxX = n − 0.5 alinean cada punto con el centro de su barra. '
        'Condición avanzada: [2] dos series, [6] /episode.',
    build: (d) {
      final cs = d.characters;
      final firstSeason = d.seasons.isEmpty ? 1 : d.seasons.first;
      final maxY = niceMax(d.maxEpisodes);
      final titles = basicTitles(
        bottom: categoryTitles([for (final c in cs) '${c.id}'], name: 'ID', every: 2),
        left: valueTitles(maxY, name: 'Episodios'),
      );
      // Mismos tamaños reservados que [titles] pero sin texto, para la capa de arriba.
      final ghost = FlTitlesData(
        topTitles: hiddenTitles,
        rightTitles: hiddenTitles,
        bottomTitles: AxisTitles(
          axisNameWidget: const SizedBox.shrink(),
          axisNameSize: 18,
          sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (_, _) => const SizedBox.shrink()),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const SizedBox.shrink(),
          axisNameSize: 18,
          sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (_, _) => const SizedBox.shrink()),
        ),
      );
      return withLegend(
        Stack(
          children: [
            BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: const BarTouchData(enabled: false),
                gridData: horizontalGrid,
                borderData: simpleBorder,
                titlesData: titles,
                barGroups: [
                  for (var i = 0; i < cs.length; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: cs[i].episodeCount.toDouble(), color: Colors.blueGrey.shade300, width: 9),
                    ]),
                ],
              ),
            ),
            LineChart(
              LineChartData(
                minX: -0.5,
                maxX: cs.length - 0.5,
                minY: 0,
                maxY: maxY,
                lineTouchData: const LineTouchData(enabled: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: ghost,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < cs.length; i++)
                        FlSpot(i.toDouble(), d.appearancesInSeason(cs[i], firstSeason).toDouble()),
                    ],
                    color: Colors.deepOrange,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ],
        ),
        {'Episodios totales': Colors.blueGrey.shade300, 'Episodios en T$firstSeason': Colors.deepOrange},
      );
    },
  ),
  FlChartDef(
    code: 'A32',
    title: 'Animación al cambiar filtro Alive ↔ Dead',
    explanation: 'Un SegmentedButton cambia el filtro y el BarChart se reconstruye con duration: 700 ms y '
        'curve: easeInOutCubic: fl_chart interpola las alturas viejas a las nuevas. Los 20 IDs siempre están; los '
        'que no cumplen el filtro bajan a 0. Condición avanzada: [3] interacción (animación al cambiar filtro).',
    build: (d) => _AnimatedFilterBars(data: d),
  ),
];

// ---------------------------------------------------------------------------
// Widgets con estado (A05, A32)
// ---------------------------------------------------------------------------

class _TouchPie extends StatefulWidget {
  final FlData data;
  const _TouchPie({required this.data});

  @override
  State<_TouchPie> createState() => _TouchPieState();
}

class _TouchPieState extends State<_TouchPie> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final entries = <(String, int, Color)>[
      for (final s in d.statuses)
        for (final g in d.genders)
          if (d.countStatusGender(s, g) > 0)
            ('$s · $g', d.countStatusGender(s, g), Color.lerp(statusColor(s), genderColor(g), 0.45)!),
    ];
    if (entries.isEmpty) return emptyChart('Sin datos');
    final selected = _touched >= 0 && _touched < entries.length ? entries[_touched] : null;
    return Column(
      children: [
        Text(
          selected == null ? 'Toca un sector' : '${selected.$1}: ${selected.$2} personajes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: PieChart(
            duration: const Duration(milliseconds: 250),
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                    return;
                  }
                  setState(() => _touched = response!.touchedSection!.touchedSectionIndex);
                },
              ),
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].$2.toDouble(),
                    color: entries[i].$3,
                    radius: i == _touched ? 105 : 85,
                    title: i == _touched ? '${entries[i].$2}' : '',
                    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    borderSide: i == _touched ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
                  ),
              ],
            ),
          ),
        ),
        legend({for (final e in entries) e.$1: e.$3}),
      ],
    );
  }
}

class _AnimatedFilterBars extends StatefulWidget {
  final FlData data;
  const _AnimatedFilterBars({required this.data});

  @override
  State<_AnimatedFilterBars> createState() => _AnimatedFilterBarsState();
}

class _AnimatedFilterBarsState extends State<_AnimatedFilterBars> {
  String _status = 'Alive';

  @override
  Widget build(BuildContext context) {
    final cs = widget.data.characters;
    final maxY = niceMax(widget.data.maxEpisodes);
    final shown = cs.where((c) => c.status == _status).length;
    return Column(
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Alive', label: Text('Alive')),
            ButtonSegment(value: 'Dead', label: Text('Dead')),
          ],
          selected: {_status},
          onSelectionChanged: (s) => setState(() => _status = s.first),
        ),
        const SizedBox(height: 4),
        Text('$shown personajes $_status', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Expanded(
          child: BarChart(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            BarChartData(
              maxY: maxY,
              barTouchData: const BarTouchData(enabled: false),
              gridData: horizontalGrid,
              borderData: simpleBorder,
              titlesData: basicTitles(
                bottom: categoryTitles([for (final c in cs) '${c.id}'], name: 'ID', every: 2),
                left: valueTitles(maxY, name: 'Episodios'),
              ),
              barGroups: [
                for (var i = 0; i < cs.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: cs[i].status == _status ? cs[i].episodeCount.toDouble() : 0,
                      color: statusColor(_status),
                      width: 9,
                    ),
                  ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
