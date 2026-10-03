// Verifica que fl_chart y flutter_echarts tengan exactamente 31 básicas
// (B01–B31) + 32 avanzadas (A01–A32) = 63 gráficas, sin códigos repetidos.

import 'package:flutter_test/flutter_test.dart';

import 'package:taller_graficos_unificado/echarts/charts/advanced_charts.dart' as echarts_adv;
import 'package:taller_graficos_unificado/echarts/charts/basic_charts.dart' as echarts_basic;
import 'package:taller_graficos_unificado/fl_chart/charts/advanced_charts.dart' as fl_adv;
import 'package:taller_graficos_unificado/fl_chart/charts/basic_charts.dart' as fl_basic;

List<String> _expected(String prefix, int n) =>
    [for (var i = 1; i <= n; i++) '$prefix${i.toString().padLeft(2, '0')}'];

void _checkLibrary(String name, List<String> basicCodes, List<String> advancedCodes) {
  group(name, () {
    test('31 básicas + 32 avanzadas = 63', () {
      expect(basicCodes.length, 31);
      expect(advancedCodes.length, 32);
      expect(basicCodes.length + advancedCodes.length, 63);
    });

    test('las básicas son exactamente B01–B31, sin repetir', () {
      expect(basicCodes.toSet().length, basicCodes.length, reason: 'hay códigos B repetidos');
      expect(basicCodes, _expected('B', 31));
    });

    test('las avanzadas son exactamente A01–A32, sin repetir', () {
      expect(advancedCodes.toSet().length, advancedCodes.length, reason: 'hay códigos A repetidos');
      expect(advancedCodes, _expected('A', 32));
    });

    test('ningún código se repite entre pestañas', () {
      final all = [...basicCodes, ...advancedCodes];
      expect(all.toSet().length, 63);
    });
  });
}

void main() {
  _checkLibrary(
    'fl_chart',
    fl_basic.basicCharts.map((c) => c.code).toList(),
    fl_adv.advancedCharts.map((c) => c.code).toList(),
  );
  _checkLibrary(
    'flutter_echarts',
    echarts_basic.basicCharts.map((c) => c.code).toList(),
    echarts_adv.advancedCharts.map((c) => c.code).toList(),
  );

  test('fl_chart: ningún título se repite', () {
    final titles = [...fl_basic.basicCharts, ...fl_adv.advancedCharts].map((c) => c.title).toList();
    expect(titles.toSet().length, titles.length);
  });
}
