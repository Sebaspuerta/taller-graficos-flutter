// Renderiza las 63 gráficas de fl_chart con datos de muestra fijos y verifica
// que ninguna lance una excepción al construirse ni al pintarse.
//
// test/fixtures/ tiene una copia recortada de respuestas reales de la API:
// los 20 personajes de /character?page=1 y 3 episodios de cada temporada.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taller_graficos_unificado/fl_chart/charts/advanced_charts.dart';
import 'package:taller_graficos_unificado/fl_chart/charts/basic_charts.dart';
import 'package:taller_graficos_unificado/fl_chart/data/fl_data.dart';
import 'package:taller_graficos_unificado/fl_chart/data/models.dart';

List<Map<String, dynamic>> _fixture(String name) =>
    (jsonDecode(File('test/fixtures/$name').readAsStringSync()) as List<dynamic>).cast<Map<String, dynamic>>();

void main() {
  final data = FlData(
    characters: _fixture('characters.json').map(FlCharacter.fromJson).toList(),
    episodes: _fixture('episodes.json').map(FlEpisode.fromJson).toList(),
  );

  test('los fixtures traen 20 personajes y las 5 temporadas', () {
    expect(data.characters.length, 20);
    expect(data.seasons, [1, 2, 3, 4, 5]);
  });

  for (final def in [...basicCharts, ...advancedCharts]) {
    testWidgets('${def.code} se renderiza sin excepciones', (tester) async {
      // Tamaño de un teléfono (Pixel 8) para que los ejes tengan el espacio real.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 420,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 20, 8),
                child: def.build(data),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
