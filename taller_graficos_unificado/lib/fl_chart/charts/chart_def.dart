// Definición de una gráfica de fl_chart + helpers comunes (ejes, colores).

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/fl_data.dart';

class FlChartDef {
  final String code;
  final String title;
  final String explanation;
  final Widget Function(FlData) build;

  const FlChartDef({
    required this.code,
    required this.title,
    required this.explanation,
    required this.build,
  });
}

// ---------------------------------------------------------------------------
// Colores
// ---------------------------------------------------------------------------

const Map<String, Color> statusColors = {
  'Alive': Colors.green,
  'Dead': Colors.red,
  'unknown': Colors.grey,
};

const Map<String, Color> genderColors = {
  'Male': Colors.blue,
  'Female': Colors.pink,
  'unknown': Colors.orange,
  'Genderless': Colors.purple,
};

const List<Color> categoryPalette = [
  Colors.indigo,
  Colors.cyan,
  Colors.amber,
  Colors.lime,
  Colors.deepOrange,
  Colors.teal,
  Colors.brown,
];

Color statusColor(String s) => statusColors[s] ?? Colors.blueGrey;
Color genderColor(String g) => genderColors[g] ?? Colors.blueGrey;
Color paletteAt(int i) => categoryPalette[i % categoryPalette.length];

const Color flGreen = Color(0xFF97CE4C);

// ---------------------------------------------------------------------------
// Ejes y escalas
// ---------------------------------------------------------------------------

/// Máximo del eje Y con un 15 % de aire, nunca 0 (evita rangos vacíos).
double niceMax(num value) => math.max(1, (value * 1.15).ceilToDouble());

/// Intervalo de las etiquetas del eje Y para unas 5 marcas (nunca 0).
double niceInterval(double max) => math.max(1, (max / 5).ceilToDouble());

const AxisTitles hiddenTitles = AxisTitles(sideTitles: SideTitles(showTitles: false));

Widget axisLabel(TitleMeta meta, String text, {double angle = 0, double fontSize = 10}) =>
    SideTitleWidget(
      meta: meta,
      angle: angle,
      space: 4,
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );

/// Eje de valores (enteros) a la izquierda.
AxisTitles valueTitles(double max, {String? name, double reserved = 32}) => AxisTitles(
      axisNameWidget: name == null ? null : Text(name, style: const TextStyle(fontSize: 11)),
      axisNameSize: name == null ? 0 : 18,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: reserved,
        interval: niceInterval(max),
        getTitlesWidget: (v, meta) =>
            v == meta.max && v % niceInterval(max) != 0 ? const SizedBox.shrink() : axisLabel(meta, v.toInt().toString()),
      ),
    );

/// Eje de categorías abajo: [labels][x] para x entero. [angle] en radianes.
AxisTitles categoryTitles(
  List<String> labels, {
  String? name,
  double angle = 0,
  double reserved = 28,
  int every = 1,
}) =>
    AxisTitles(
      axisNameWidget: name == null ? null : Text(name, style: const TextStyle(fontSize: 11)),
      axisNameSize: name == null ? 0 : 18,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: reserved,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.round();
          if (v != i || i < 0 || i >= labels.length || i % every != 0) return const SizedBox.shrink();
          return axisLabel(meta, labels[i], angle: angle);
        },
      ),
    );

/// Eje X numérico con los IDs de personaje.
AxisTitles idTitles(int count, {String name = 'ID'}) => AxisTitles(
      axisNameWidget: Text(name, style: const TextStyle(fontSize: 11)),
      axisNameSize: 18,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 24,
        interval: count > 12 ? 2 : 1,
        getTitlesWidget: (v, meta) =>
            v == v.roundToDouble() ? axisLabel(meta, v.toInt().toString()) : const SizedBox.shrink(),
      ),
    );

/// Títulos estándar: eje de categorías abajo + valores a la izquierda.
FlTitlesData basicTitles({
  required AxisTitles bottom,
  required AxisTitles left,
}) =>
    FlTitlesData(
      bottomTitles: bottom,
      leftTitles: left,
      topTitles: hiddenTitles,
      rightTitles: hiddenTitles,
    );

FlBorderData get simpleBorder => FlBorderData(
      show: true,
      border: const Border(
        left: BorderSide(color: Colors.black26),
        bottom: BorderSide(color: Colors.black26),
      ),
    );

const FlGridData horizontalGrid = FlGridData(show: true, drawVerticalLine: false);

/// Mensaje que reemplaza a la gráfica cuando un filtro deja 0 datos.
Widget emptyChart(String message) => Center(
      child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
    );

/// Leyenda simple (cuadro de color + texto) para las gráficas con varias series.
Widget legend(Map<String, Color> items) => Wrap(
      spacing: 12,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        for (final e in items.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 12, color: e.value),
              const SizedBox(width: 4),
              Text(e.key, style: const TextStyle(fontSize: 11)),
            ],
          ),
      ],
    );

/// Gráfica arriba + leyenda abajo.
Widget withLegend(Widget chart, Map<String, Color> items) => Column(
      children: [
        Expanded(child: chart),
        const SizedBox(height: 8),
        legend(items),
      ],
    );
