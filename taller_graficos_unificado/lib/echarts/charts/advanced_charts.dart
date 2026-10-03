// 32 gráficas avanzadas (A01–A32): aprovechan tipos y componentes propios de ECharts.

import '../data/models.dart';
import '../data/rm_data.dart';
import 'chart_def.dart';
import 'palette.dart';

const Map<String, dynamic> _itemTooltip = {'trigger': 'item'};
const Map<String, dynamic> _axisTooltip = {
  'trigger': 'axis',
  'axisPointer': {'type': 'shadow'},
};
const Map<String, dynamic> _bottomLegend = {'bottom': 0, 'type': 'scroll'};
const Map<String, dynamic> _topLegend = {'top': 26, 'type': 'scroll'};

/// Pastel genérico con etiqueta "{b}: {c} ({d}%)".
Map<String, dynamic> _pie(String code, String title, List<MapEntry<String, int>> entries,
    {String Function(String key, int index)? color}) {
  return {
    'title': chartTitle(code, title),
    'tooltip': {'trigger': 'item', 'formatter': '{b}: {c} ({d}%)'},
    'legend': _bottomLegend,
    'series': [
      {
        'type': 'pie',
        'radius': '50%',
        'center': ['50%', '50%'],
        'label': {'formatter': '{b}\n{c} ({d}%)', 'fontSize': 11},
        'data': [
          for (var i = 0; i < entries.length; i++)
            {
              'name': entries[i].key,
              'value': entries[i].value,
              if (color != null) 'itemStyle': {'color': color(entries[i].key, i)},
            },
        ],
      },
    ],
  };
}

/// Conteo estado × género: matriz[status][gender].
int _count(RMData d, String status, String gender) =>
    d.characters.where((c) => c.status == status && c.gender == gender).length;

List<int> _seasons(RMData d) => (d.episodes.map((e) => e.season).toSet().toList()..sort());

final List<ChartDef> advancedCharts = [
  ChartDef(
    code: 'A01',
    title: 'Pastel por estado',
    explanation: "series.type: 'pie' reparte el círculo en sectores proporcionales al conteo por estado. "
        "label.formatter '{b}: {c} ({d}%)' usa plantillas de ECharts: {b} nombre, {c} valor y {d} porcentaje calculado por ECharts.",
    build: (d) => _pie('A01', 'Personajes por estado',
        countByKeys(d.characters, (c) => c.status, kStatuses).entries.toList(),
        color: (k, _) => statusColor(k)),
  ),
  ChartDef(
    code: 'A02',
    title: 'Pastel por género',
    explanation: "Pastel con los cuatro géneros coloreados con la paleta de género vía itemStyle.color por dato. "
        "tooltip.trigger: 'item' muestra el detalle del sector tocado y la leyenda permite ocultar sectores.",
    build: (d) => _pie('A02', 'Personajes por género',
        countByKeys(d.characters, (c) => c.gender, kGenders).entries.where((e) => e.value > 0).toList(),
        color: (k, _) => genderColor(k)),
  ),
  ChartDef(
    code: 'A03',
    title: 'Pastel por especie (top 5 + Otros)',
    explanation: "Se calculan en Dart las 5 especies más frecuentes y el resto se agrupa en 'Otros' (topNWithOthers). "
        "Agrupar la cola evita sectores diminutos ilegibles; ECharts recalcula {d} sobre el total.",
    build: (d) => _pie('A03', 'Especies (top 5 + Otros)', topNWithOthers(countBy(d.characters, (c) => c.species), 5),
        color: (_, i) => generalAt(i)),
  ),
  ChartDef(
    code: 'A04',
    title: 'Dona por estado',
    explanation: "radius: ['35%', '58%'] define radio interior y exterior, convirtiendo el pastel en dona. "
        "El hueco central se aprovecha con un segundo title posicionado en el centro que muestra el total de personajes.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.status, kStatuses);
      return {
        'title': [
          chartTitle('A04', 'Dona por estado'),
          {
            'text': '${d.characters.length}',
            'subtext': 'personajes',
            'left': 'center',
            'top': '42%',
            'textStyle': {'fontSize': 26, 'fontWeight': 'bold'},
            'subtextStyle': {'fontSize': 12},
          },
        ],
        'tooltip': {'trigger': 'item', 'formatter': '{b}: {c} ({d}%)'},
        'legend': _bottomLegend,
        'series': [
          {
            'type': 'pie',
            'radius': ['35%', '58%'],
            'center': ['50%', '50%'],
            'label': {'formatter': '{b}\n{d}%'},
            'data': [
              for (final e in counts.entries)
                {'name': e.key, 'value': e.value, 'itemStyle': {'color': statusColor(e.key)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A05',
    title: 'Rosa de Nightingale por especie',
    explanation: "roseType: 'area' hace que el radio de cada sector sea proporcional al valor, en lugar del ángulo; "
        "todos los sectores tienen el mismo ángulo. Resalta mucho las diferencias entre especies frecuentes y raras.",
    build: (d) {
      final entries = topN(countBy(d.characters, (c) => c.species), 8);
      return {
        'title': chartTitle('A05', 'Rosa de Nightingale: especies'),
        'tooltip': {'trigger': 'item', 'formatter': '{b}: {c} ({d}%)'},
        'legend': _bottomLegend,
        'series': [
          {
            'type': 'pie',
            'roseType': 'area',
            'radius': ['12%', '68%'],
            'center': ['50%', '50%'],
            'itemStyle': {'borderRadius': 4},
            'label': {'fontSize': 10},
            'data': [
              for (var i = 0; i < entries.length; i++)
                {'name': entries[i].key, 'value': entries[i].value, 'itemStyle': {'color': generalAt(i)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A06',
    title: 'Embudo por especie',
    explanation: "series.type: 'funnel' con sort: 'descending' dibuja trapecios de ancho proporcional al valor, del mayor al menor. "
        "gap separa las etapas y label.position: 'right' coloca el texto al lado de cada nivel.",
    build: (d) {
      final entries = topN(countBy(d.characters, (c) => c.species), 6);
      return {
        'title': chartTitle('A06', 'Embudo: especies'),
        'tooltip': {'trigger': 'item', 'formatter': '{b}: {c}'},
        'legend': _bottomLegend,
        'series': [
          {
            'type': 'funnel',
            'sort': 'descending',
            'top': 50,
            'bottom': 50,
            'left': '5%',
            'width': '58%',
            'minSize': '10%',
            'gap': 2,
            'label': {'position': 'right', 'formatter': '{b}: {c}', 'fontSize': 10},
            'data': [
              for (var i = 0; i < entries.length; i++)
                {'name': entries[i].key, 'value': entries[i].value, 'itemStyle': {'color': generalAt(i)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A07',
    title: 'Gauge: % de personajes vivos',
    explanation: "series.type: 'gauge' dibuja un velocímetro de 0 a 100. El porcentaje se calcula en Dart y "
        "detail.formatter '{value}%' lo muestra en el centro; axisLine.lineStyle.color define tramos rojo/amarillo/verde.",
    build: (d) {
      final alive = d.characters.where((c) => c.status == 'Alive').length;
      final pct = d.characters.isEmpty ? 0.0 : round(alive * 100 / d.characters.length, 1);
      return {
        'title': chartTitle('A07', '% de personajes vivos'),
        'tooltip': {'formatter': '{b}: {c}%'},
        'series': [
          {
            'type': 'gauge',
            'min': 0,
            'max': 100,
            'center': ['50%', '58%'],
            'radius': '80%',
            'axisLine': {
              'lineStyle': {
                'width': 14,
                'color': [
                  [0.3, '#F44336'],
                  [0.6, '#FFC107'],
                  [1, '#4CAF50'],
                ],
              },
            },
            'detail': {'formatter': '{value}%', 'fontSize': 26, 'offsetCenter': [0, '60%']},
            'data': [
              {'name': 'Vivos', 'value': pct},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A08',
    title: 'Radar: estado por género',
    explanation: "radar.indicator define los ejes Alive, Dead y unknown con un max común. "
        "Cada género es una serie 'radar' cuyo polígono une sus conteos; areaStyle con opacidad permite comparar las formas.",
    build: (d) {
      final maxCount = [
        for (final s in kStatuses)
          for (final g in kGenders) _count(d, s, g),
      ].fold<int>(1, (m, v) => v > m ? v : m);
      final niceMax = ((maxCount + 19) ~/ 20) * 20; // múltiplo de 20 + splitNumber 4 = ticks legibles
      return {
        'title': chartTitle('A08', 'Radar: estado por género'),
        'tooltip': _itemTooltip,
        'legend': _bottomLegend,
        'radar': {
          'center': ['50%', '52%'],
          'radius': '62%',
          'splitNumber': 4,
          'indicator': [
            for (final s in kStatuses) {'name': s, 'max': niceMax},
          ],
        },
        'series': [
          for (final g in kGenders)
            {
              'type': 'radar',
              'name': g,
              'itemStyle': {'color': genderColor(g)},
              'areaStyle': {'opacity': 0.2},
              'data': [
                {
                  'name': g,
                  'value': [for (final s in kStatuses) _count(d, s, g)],
                },
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A09',
    title: 'Barras polares por estado',
    explanation: "El componente polar con angleAxis (categorías) y radiusAxis (valores) reemplaza al grid cartesiano. "
        "Con coordinateSystem: 'polar' cada barra se convierte en un sector cuya longitud radial es el conteo.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.status, kStatuses);
      return {
        'title': chartTitle('A09', 'Barras polares: estado'),
        'tooltip': _itemTooltip,
        'polar': {'radius': ['10%', '75%'], 'center': ['50%', '55%']},
        'angleAxis': {'type': 'category', 'data': kStatuses, 'startAngle': 90},
        'radiusAxis': {'type': 'value'},
        'series': [
          {
            'type': 'bar',
            'coordinateSystem': 'polar',
            'name': 'Personajes',
            'label': {'show': true, 'position': 'middle', 'formatter': '{c}'},
            'data': [
              for (final e in counts.entries) {'value': e.value, 'itemStyle': {'color': statusColor(e.key)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A10',
    title: 'Barras apiladas al 100 %: estado × género',
    explanation: "Los porcentajes de cada género dentro de cada estado se calculan en Dart y se apilan con stack: 'total'. "
        "yAxis.max: 100 fija la escala y label.formatter '{c}%' añade el símbolo de porcentaje a cada tramo.",
    build: (d) {
      final totals = {for (final s in kStatuses) s: d.characters.where((c) => c.status == s).length};
      return {
        'title': chartTitle('A10', 'Estado × género (100 %)'),
        'tooltip': _axisTooltip,
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {'type': 'category', 'data': kStatuses},
        'yAxis': {'type': 'value', 'max': 100, 'axisLabel': {'formatter': '{value}%'}},
        'series': [
          for (final g in kGenders)
            {
              'type': 'bar',
              'name': g,
              'stack': 'total',
              'itemStyle': {'color': genderColor(g)},
              'label': {'show': true, 'formatter': '{c}%', 'fontSize': 9},
              'data': [
                for (final s in kStatuses)
                  // 0 se envía como '-' para no dibujar etiquetas "0%"
                  _count(d, s, g) == 0 ? '-' : round(_count(d, s, g) * 100 / totals[s]!, 1),
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A11',
    title: 'Barras agrupadas: estado × género',
    explanation: "Varias series 'bar' sin stack se dibujan lado a lado dentro de cada categoría. "
        "barGap controla la separación entre barras del mismo grupo y la leyenda permite activar o desactivar géneros.",
    build: (d) {
      return {
        'title': chartTitle('A11', 'Estado × género (agrupadas)'),
        'tooltip': _axisTooltip,
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {'type': 'category', 'data': kStatuses},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          for (final g in kGenders)
            {
              'type': 'bar',
              'name': g,
              'barGap': '10%',
              'itemStyle': {'color': genderColor(g)},
              'data': [for (final s in kStatuses) _count(d, s, g)],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A12',
    title: 'Barras horizontales apiladas: estado × género',
    explanation: "yAxis.type: 'category' con los estados y series con stack: 'total' generan barras horizontales apiladas. "
        "label.show dentro de cada tramo muestra el conteo exacto de cada género.",
    build: (d) {
      return {
        'title': chartTitle('A12', 'Estado × género (horizontal)'),
        'tooltip': _axisTooltip,
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {'type': 'value', 'name': 'Personajes', 'nameLocation': 'middle', 'nameGap': 25},
        'yAxis': {'type': 'category', 'data': kStatuses},
        'series': [
          for (final g in kGenders)
            {
              'type': 'bar',
              'name': g,
              'stack': 'total',
              'itemStyle': {'color': genderColor(g)},
              'label': {'show': true, 'fontSize': 10},
              'data': [
                for (final s in kStatuses)
                  // 0 se envía como '-' para que no aparezcan etiquetas "0" vacías
                  _count(d, s, g) == 0 ? '-' : _count(d, s, g),
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A13',
    title: 'Dispersión multiserie por estado',
    explanation: "Una serie 'scatter' por estado con su color de la paleta; la leyenda permite filtrar cada grupo. "
        "tooltip.formatter '{a}<br/>ID {c}' usa {a} (nombre de la serie) y {c} (el par [id, episodios]).",
    build: (d) {
      return {
        'title': chartTitle('A13', 'Episodios vs ID por estado'),
        'tooltip': {'trigger': 'item', 'formatter': '{a}<br/>[ID, episodios]: {c}'},
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {'type': 'value', 'name': 'ID'},
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'series': [
          for (final s in kStatuses)
            {
              'type': 'scatter',
              'name': s,
              'symbolSize': 10,
              'itemStyle': {'color': statusColor(s)},
              'data': [
                for (final c in d.characters.where((c) => c.status == s)) [c.id, c.episodeCount],
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A14',
    title: 'Burbujas: episodios por ID',
    explanation: "Cada dato lleva su propio symbolSize calculado en Dart (proporcional a los episodios, entre 6 y 40 px), "
        "sin funciones JavaScript. El tamaño agrega una tercera codificación visual al scatter.",
    build: (d) {
      final maxEp = d.characters.fold<int>(1, (m, c) => c.episodeCount > m ? c.episodeCount : m);
      return {
        'title': chartTitle('A14', 'Burbujas: episodios por ID'),
        'tooltip': {'trigger': 'item', 'formatter': '{b}<br/>[ID, episodios]: {c}'},
        'grid': chartGrid(),
        'xAxis': {'type': 'value', 'name': 'ID'},
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'series': [
          {
            'type': 'scatter',
            'itemStyle': {'color': '#00BCD4', 'opacity': 0.6, 'borderColor': '#00838F'},
            'data': [
              for (final c in d.characters)
                {
                  'name': c.name,
                  'value': [c.id, c.episodeCount],
                  'symbolSize': round(6 + 34 * c.episodeCount / maxEp, 1),
                },
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A15',
    title: 'Boxplot: episodios por estado',
    explanation: "series.type: 'boxplot' espera por categoría [mín, Q1, mediana, Q3, máx]; se calcula con fiveNumberSummary en Dart. "
        "La caja abarca el rango intercuartílico y los bigotes llegan al mínimo y máximo.",
    build: (d) {
      return {
        'title': chartTitle('A15', 'Boxplot: episodios por estado'),
        'tooltip': _itemTooltip,
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': kStatuses},
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'series': [
          {
            'type': 'boxplot',
            'name': 'Episodios',
            'itemStyle': {'color': '#E3F2FD', 'borderColor': '#1565C0'},
            'data': [
              for (final s in kStatuses)
                fiveNumberSummary([
                  for (final c in d.characters.where((c) => c.status == s)) c.episodeCount,
                ]),
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A16',
    title: 'Heatmap estado × género',
    explanation: "series.type: 'heatmap' sobre dos ejes de categorías; cada dato es [índiceX, índiceY, valor]. "
        "visualMap asigna el color de cada celda según el valor y label.show escribe el conteo dentro.",
    build: (d) {
      final data = [
        for (var x = 0; x < kGenders.length; x++)
          for (var y = 0; y < kStatuses.length; y++) [x, y, _count(d, kStatuses[y], kGenders[x])],
      ];
      final maxV = data.fold<int>(1, (m, v) => v[2] > m ? v[2] : m);
      return {
        'title': chartTitle('A16', 'Heatmap estado × género'),
        'tooltip': {'position': 'top'},
        'grid': chartGrid(bottom: 70),
        'xAxis': {'type': 'category', 'data': kGenders, 'splitArea': {'show': true}, 'axisLabel': {'interval': 0}},
        'yAxis': {'type': 'category', 'data': kStatuses, 'splitArea': {'show': true}},
        'visualMap': {
          'min': 0,
          'max': maxV,
          'calculable': true,
          'orient': 'horizontal',
          'left': 'center',
          'bottom': 5,
          'inRange': {'color': ['#E0F7FA', '#006064']},
        },
        'series': [
          {
            'type': 'heatmap',
            'name': 'Personajes',
            'label': {'show': true},
            'data': data,
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A17',
    title: 'Treemap: especie → tipo',
    explanation: "series.type: 'treemap' divide el área en rectángulos anidados: el primer nivel son especies y "
        "sus hijos (children) los tipos. levels define bordes distintos por nivel y upperLabel muestra el nombre del padre.",
    build: (d) {
      final bySpecies = <String, List<Character>>{};
      for (final c in d.characters) {
        bySpecies.putIfAbsent(c.species, () => []).add(c);
      }
      final species = sortedDesc({for (final e in bySpecies.entries) e.key: e.value.length});
      return {
        'title': chartTitle('A17', 'Treemap: especie → tipo'),
        'tooltip': {'formatter': '{b}: {c}'},
        'series': [
          {
            'type': 'treemap',
            'name': 'Personajes',
            'top': 40,
            'bottom': 40,
            'roam': false,
            'nodeClick': false,
            'leafDepth': 2,
            'breadcrumb': {'show': true, 'bottom': 5},
            'levels': [
              {
                'itemStyle': {'borderColor': '#FFFFFF', 'borderWidth': 3, 'gapWidth': 3},
                'upperLabel': {'show': true, 'height': 18},
              },
              {
                'colorSaturation': [0.35, 0.6],
                'itemStyle': {'borderColorSaturation': 0.6, 'gapWidth': 1, 'borderWidth': 1},
              },
            ],
            'label': {'fontSize': 10},
            'data': [
              for (var i = 0; i < species.length; i++)
                {
                  'name': species[i].key,
                  'value': species[i].value,
                  'itemStyle': {'color': generalAt(i)},
                  'children': [
                    for (final t in sortedDesc(countBy(bySpecies[species[i].key]!, (c) => c.type)))
                      {'name': t.key, 'value': t.value},
                  ],
                },
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A18',
    title: 'Sunburst: estado → género → especie',
    explanation: "series.type: 'sunburst' dibuja la jerarquía en anillos concéntricos: el centro es el estado, luego género y especie. "
        "El ángulo de cada sector es proporcional a la cantidad de personajes y al tocar un sector se hace zoom a esa rama.",
    build: (d) {
      return {
        'title': chartTitle('A18', 'Sunburst: estado → género → especie'),
        'tooltip': {'formatter': '{b}: {c}'},
        'series': [
          {
            'type': 'sunburst',
            'radius': [0, '85%'],
            'center': ['50%', '54%'],
            'sort': null,
            'label': {'rotate': 'radial', 'fontSize': 9, 'minAngle': 8},
            'itemStyle': {'borderColor': '#FFFFFF', 'borderWidth': 1},
            'data': [
              for (final s in kStatuses)
                if (d.characters.any((c) => c.status == s))
                  {
                    'name': s,
                    'itemStyle': {'color': statusColor(s)},
                    'children': [
                      for (final g in kGenders)
                        if (_count(d, s, g) > 0)
                          {
                            'name': g,
                            'itemStyle': {'color': genderColor(g)},
                            'children': [
                              for (final sp in sortedDesc(countBy(
                                  d.characters.where((c) => c.status == s && c.gender == g), (c) => c.species)))
                                {'name': sp.key, 'value': sp.value},
                            ],
                          },
                    ],
                  },
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A19',
    title: 'Barras: episodios por temporada',
    explanation: "Datos de /episode: se extrae la temporada del código 'S01E01' y se cuenta en Dart. "
        "label.position: 'top' muestra el total sobre cada barra y el tooltip con axisPointer 'shadow' resalta la columna.",
    build: (d) {
      final seasons = _seasons(d);
      return {
        'title': chartTitle('A19', 'Episodios por temporada'),
        'tooltip': _axisTooltip,
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': [for (final s in seasons) 'T$s']},
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'series': [
          {
            'type': 'bar',
            'name': 'Episodios',
            'label': {'show': true, 'position': 'top'},
            'data': [
              for (var i = 0; i < seasons.length; i++)
                {
                  'value': d.episodes.where((e) => e.season == seasons[i]).length,
                  'itemStyle': {'color': generalAt(i)},
                },
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A20',
    title: 'Área apilada: personajes por episodio y temporada',
    explanation: "El eje x es el número de episodio dentro de la temporada y hay una serie de área por temporada con stack: 'total'. "
        "Los episodios que no existen en una temporada se envían como '-' (dato vacío en ECharts).",
    build: (d) {
      final seasons = _seasons(d);
      final maxNum = d.episodes.fold<int>(1, (m, e) => e.number > m ? e.number : m);
      return {
        'title': chartTitle('A20', 'Personajes por episodio (apilado)'),
        'tooltip': {'trigger': 'axis'},
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {
          'type': 'category',
          'name': 'Ep.',
          'boundaryGap': false,
          'data': [for (var n = 1; n <= maxNum; n++) '$n'],
        },
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          for (var i = 0; i < seasons.length; i++)
            {
              'type': 'line',
              'name': 'T${seasons[i]}',
              'stack': 'total',
              'smooth': true,
              'showSymbol': false,
              'areaStyle': {'opacity': 0.6},
              'itemStyle': {'color': generalAt(i)},
              'data': [
                for (var n = 1; n <= maxNum; n++)
                  d.episodes
                          .where((e) => e.season == seasons[i] && e.number == n)
                          .map<Object>((e) => e.characterCount)
                          .firstOrNull ??
                      '-',
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A21',
    title: 'Línea con dataZoom: personajes por episodio',
    explanation: "dataZoom con type 'slider' (barra inferior arrastrable) e 'inside' (pellizco/arrastre sobre la gráfica) "
        "permite ver una ventana de los 51 episodios; start/end fijan la ventana inicial en porcentaje.",
    build: (d) {
      return {
        'title': chartTitle('A21', 'Personajes por episodio (zoom)'),
        'tooltip': {'trigger': 'axis'},
        'grid': chartGrid(bottom: 60),
        'xAxis': {'type': 'category', 'data': [for (final e in d.episodes) e.code], 'boundaryGap': false},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'dataZoom': [
          {'type': 'slider', 'start': 0, 'end': 40, 'bottom': 10},
          {'type': 'inside', 'start': 0, 'end': 40},
        ],
        'series': [
          {
            'type': 'line',
            'name': 'Personajes',
            'itemStyle': {'color': '#3F51B5'},
            'areaStyle': {'opacity': 0.15},
            'data': [for (final e in d.episodes) e.characterCount],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A22',
    title: 'Barras con markLine y markPoint',
    explanation: "markLine con type: 'average' traza el promedio calculado por ECharts y markPoint con 'max'/'min' "
        "marca con un globo las barras extremas. Son anotaciones declarativas, sin cálculos en Dart.",
    build: (d) {
      final cs = sortedBy(d.characters, (c) => c.episodeCount, descending: true).take(20).toList();
      return {
        'title': chartTitle('A22', 'Top 20 con promedio, máx y mín'),
        'tooltip': _axisTooltip,
        'grid': chartGrid(top: 80),
        'xAxis': {
          'type': 'category',
          'data': [for (final c in cs) c.name],
          'axisLabel': {'rotate': 50, 'interval': 0, 'fontSize': 9},
        },
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'series': [
          {
            'type': 'bar',
            'name': 'Episodios',
            'itemStyle': {'color': '#5470C6'},
            'data': [for (final c in cs) c.episodeCount],
            'markPoint': {
              'data': [
                {'type': 'max', 'name': 'Máx'},
                {'type': 'min', 'name': 'Mín'},
              ],
            },
            'markLine': {
              'data': [
                {'type': 'average', 'name': 'Promedio'},
              ],
            },
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A23',
    title: 'Barras con visualMap continuo',
    explanation: "visualMap type: 'continuous' mapea el valor de cada barra a un color de un degradado (inRange.color). "
        "dimension: 1 indica que se usa el valor (eje y); la barra de control permite filtrar un rango arrastrando.",
    build: (d) {
      final cs = d.firstById(20);
      final maxEp = d.characters.fold<int>(1, (m, c) => c.episodeCount > m ? c.episodeCount : m);
      return {
        'title': chartTitle('A23', 'Episodios con degradado'),
        'tooltip': _axisTooltip,
        'grid': chartGrid(bottom: 70),
        'xAxis': {'type': 'category', 'name': 'ID', 'data': [for (final c in cs) '${c.id}']},
        'yAxis': {'type': 'value', 'name': 'Episodios'},
        'visualMap': {
          'type': 'continuous',
          'dimension': 1,
          'min': 0,
          'max': maxEp,
          'calculable': true,
          'orient': 'horizontal',
          'left': 'center',
          'bottom': 5,
          'inRange': {'color': ['#FFF59D', '#FF9800', '#D32F2F']},
        },
        'series': [
          {'type': 'bar', 'name': 'Episodios', 'data': [for (final c in cs) c.episodeCount]},
        ],
      };
    },
  ),
  ChartDef(
    code: 'A24',
    title: 'Doble eje Y: temporadas',
    explanation: "yAxis es una lista de dos ejes; la serie de barras usa el eje 0 (episodios por temporada) y la línea "
        "yAxisIndex: 1 (promedio de personajes por episodio). Así se comparan dos magnitudes con escalas distintas.",
    build: (d) {
      final seasons = _seasons(d);
      final counts = [for (final s in seasons) d.episodes.where((e) => e.season == s).length];
      final avgs = [
        for (var i = 0; i < seasons.length; i++)
          counts[i] == 0
              ? 0
              : round(
                  d.episodes.where((e) => e.season == seasons[i]).fold<int>(0, (a, e) => a + e.characterCount) /
                      counts[i],
                  1),
      ];
      return {
        'title': chartTitle('A24', 'Episodios vs promedio de personajes'),
        'tooltip': {'trigger': 'axis'},
        'legend': _topLegend,
        'grid': chartGrid(top: 80),
        'xAxis': {'type': 'category', 'data': [for (final s in seasons) 'T$s']},
        'yAxis': [
          {'type': 'value', 'name': 'Episodios'},
          {'type': 'value', 'name': 'Prom. personajes', 'splitLine': {'show': false}},
        ],
        'series': [
          {'type': 'bar', 'name': 'Episodios', 'itemStyle': {'color': '#5470C6'}, 'data': counts},
          {
            'type': 'line',
            'name': 'Prom. personajes/episodio',
            'yAxisIndex': 1,
            'symbolSize': 8,
            'itemStyle': {'color': '#EE6666'},
            'data': avgs,
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A25',
    title: 'Barras arcoíris con etiquetas',
    explanation: "Cada barra de las 8 especies más comunes toma un color de la paleta arcoíris (itemStyle.color por dato). "
        "label.show con position: 'top' escribe el valor sobre cada barra, sin necesidad de tooltip.",
    build: (d) {
      final entries = topN(countBy(d.characters, (c) => c.species), 8);
      return {
        'title': chartTitle('A25', 'Especies (arcoíris)'),
        'tooltip': _axisTooltip,
        'grid': chartGrid(),
        'xAxis': {
          'type': 'category',
          'data': [for (final e in entries) e.key],
          'axisLabel': {'rotate': 30, 'interval': 0, 'fontSize': 10},
        },
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {
            'type': 'bar',
            'name': 'Personajes',
            'label': {'show': true, 'position': 'top'},
            'data': [
              for (var i = 0; i < entries.length; i++)
                {'value': entries[i].value, 'itemStyle': {'color': rainbowAt(i)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A26',
    title: 'Barras pictóricas por estado',
    explanation: "series.type: 'pictorialBar' dibuja la barra con símbolos: symbol 'roundRect' y symbolRepeat: true los apilan "
        "hasta alcanzar el valor. symbolSize y symbolMargin controlan el tamaño y separación de cada bloque.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.status, kStatuses);
      return {
        'title': chartTitle('A26', 'Barras pictóricas: estado'),
        'tooltip': _axisTooltip,
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': kStatuses},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {
            'type': 'pictorialBar',
            'name': 'Personajes',
            'symbol': 'roundRect',
            'symbolRepeat': true,
            'symbolSize': [36, 8],
            'symbolMargin': 2,
            'label': {'show': true, 'position': 'top'},
            'data': [
              for (final e in counts.entries) {'value': e.value, 'itemStyle': {'color': statusColor(e.key)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A27',
    title: 'Grafo: personajes ↔ ubicación actual',
    explanation: "series.type: 'graph' con layout: 'force' posiciona los nodos por simulación de fuerzas (repulsion, edgeLength). "
        "categories distingue personajes de ubicaciones; los nombres de nodo se vuelven únicos en Dart porque ECharts los usa como id.",
    build: (d) {
      final cs = sortedBy(d.characters, (c) => c.episodeCount, descending: true).take(15).toList();
      final used = <String>{};
      String unique(String name) {
        var n = name;
        var i = 2;
        while (used.contains(n)) {
          n = '$name ($i)';
          i++;
        }
        used.add(n);
        return n;
      }

      final charNodes = <Map<String, dynamic>>[];
      final links = <Map<String, dynamic>>[];
      final locNode = <String, String>{}; // ubicación → nombre de nodo
      final locCount = <String, int>{};
      for (final c in cs) {
        final node = unique(c.name);
        charNodes.add({'name': node, 'category': 0, 'symbolSize': 10 + c.episodeCount / 3, 'value': c.episodeCount});
        locCount[c.locationName] = (locCount[c.locationName] ?? 0) + 1;
      }
      for (final loc in locCount.keys) {
        locNode[loc] = unique(loc);
      }
      for (var i = 0; i < cs.length; i++) {
        links.add({'source': charNodes[i]['name'], 'target': locNode[cs[i].locationName]});
      }
      return {
        'title': chartTitle('A27', 'Top 15 personajes y su ubicación'),
        'tooltip': {'formatter': '{b}'},
        'legend': _bottomLegend,
        'series': [
          {
            'type': 'graph',
            'layout': 'force',
            'roam': true,
            'draggable': true,
            'top': 40,
            'bottom': 40,
            'force': {'repulsion': 140, 'edgeLength': 60, 'gravity': 0.1},
            'categories': [
              {'name': 'Personaje', 'itemStyle': {'color': '#2196F3'}},
              {'name': 'Ubicación', 'itemStyle': {'color': '#FF9800'}},
            ],
            'label': {'show': true, 'position': 'right', 'fontSize': 9},
            'lineStyle': {'color': 'source', 'opacity': 0.6},
            'data': [
              ...charNodes,
              for (final loc in locNode.entries)
                {'name': loc.value, 'category': 1, 'symbolSize': 14 + 4 * locCount[loc.key]!, 'value': locCount[loc.key]},
            ],
            'links': links,
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A28',
    title: 'Sankey: origen → ubicación actual',
    explanation: "series.type: 'sankey' dibuja flujos cuyo grosor es el número de personajes que van de un origen a su ubicación actual. "
        "Los nodos se prefijan 'Origen:' y 'Actual:' porque el sankey de ECharts falla si hay ciclos (origen = ubicación).",
    build: (d) => {
      'title': chartTitle('A28', 'Origen → ubicación (top 10 flujos)'),
      'tooltip': {'trigger': 'item'},
      'series': [
        {
          'type': 'sankey',
          'top': 40,
          'bottom': 10,
          'left': 10,
          'right': 10,
          'nodeGap': 10,
          'emphasis': {'focus': 'adjacency'},
          'lineStyle': {'color': 'gradient', 'curveness': 0.5, 'opacity': 0.4},
          'label': {'fontSize': 9},
          ...sankeyNodesAndLinks(d),
        },
      ],
    },
  ),
  ChartDef(
    code: 'A29',
    title: 'Árbol: especie → estado → nombres',
    explanation: "series.type: 'tree' dibuja una jerarquía nodo-enlace de izquierda a derecha (orient: 'LR'). "
        "Se limita en Dart a 3 especies y 4 nombres por hoja; initialTreeDepth: -1 abre todo y tocar un nodo lo colapsa.",
    build: (d) {
      final species = topN(countBy(d.characters, (c) => c.species), 3);
      return {
        'title': chartTitle('A29', 'Árbol de personajes'),
        'tooltip': {'trigger': 'item', 'triggerOn': 'mousemove'},
        'series': [
          {
            'type': 'tree',
            'orient': 'LR',
            'top': 40,
            'bottom': 10,
            'left': 70,
            'right': 110,
            'symbolSize': 7,
            'initialTreeDepth': -1,
            'expandAndCollapse': true,
            'label': {'position': 'left', 'verticalAlign': 'middle', 'align': 'right', 'fontSize': 9},
            'leaves': {
              'label': {'position': 'right', 'verticalAlign': 'middle', 'align': 'left'},
            },
            'data': [
              {
                'name': 'Personajes',
                'children': [
                  for (final sp in species)
                    {
                      'name': sp.key,
                      'children': [
                        for (final s in kStatuses)
                          if (d.characters.any((c) => c.species == sp.key && c.status == s))
                            {
                              'name': s,
                              'itemStyle': {'color': statusColor(s)},
                              'children': [
                                for (final c in d.characters.where((c) => c.species == sp.key && c.status == s).take(4))
                                  {'name': c.name},
                              ],
                            },
                      ],
                    },
                ],
              },
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A30',
    title: 'Coordenadas paralelas',
    explanation: "El componente parallel con parallelAxis define un eje vertical por dimensión: id y episodios (value) y "
        "estado, género y especie (type: 'category'). Cada personaje es una polilínea; una serie por estado para colorear.",
    build: (d) {
      final topSpecies = [for (final e in topN(countBy(d.characters, (c) => c.species), 5)) e.key];
      final cs = d.characters.where((c) => topSpecies.contains(c.species)).toList();
      return {
        'title': chartTitle('A30', 'Coordenadas paralelas'),
        'tooltip': {'trigger': 'item'},
        'legend': _bottomLegend,
        'parallel': {
          'left': 40,
          'right': 100,
          'top': 60,
          'bottom': 50,
          'parallelAxisDefault': {'nameTextStyle': {'fontSize': 11}, 'axisLabel': {'fontSize': 9}},
        },
        'parallelAxis': [
          {'dim': 0, 'name': 'ID', 'type': 'value'},
          {'dim': 1, 'name': 'Episodios', 'type': 'value'},
          {'dim': 2, 'name': 'Estado', 'type': 'category', 'data': kStatuses},
          {'dim': 3, 'name': 'Género', 'type': 'category', 'data': kGenders},
          {'dim': 4, 'name': 'Especie', 'type': 'category', 'data': topSpecies},
        ],
        'series': [
          for (final s in kStatuses)
            {
              'type': 'parallel',
              'name': s,
              'lineStyle': {'width': 1.5, 'opacity': 0.6, 'color': statusColor(s)},
              'data': [
                for (final c in cs.where((c) => c.status == s)) [c.id, c.episodeCount, c.status, c.gender, c.species],
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A31',
    title: 'Acumulado de episodios por ID',
    explanation: "La suma acumulada se calcula en Dart recorriendo los personajes por id. Una sola serie line combina "
        "areaStyle, línea y showSymbol; al ser monótona creciente muestra en qué ids se concentran los episodios.",
    build: (d) {
      var sum = 0;
      final cumulative = [for (final c in d.characters) sum += c.episodeCount];
      return {
        'title': chartTitle('A31', 'Episodios acumulados por ID'),
        'tooltip': {'trigger': 'axis'},
        'grid': chartGrid(),
        'xAxis': {
          'type': 'category',
          'name': 'ID',
          'boundaryGap': false,
          'data': [for (final c in d.characters) '${c.id}'],
        },
        'yAxis': {'type': 'value', 'name': 'Acumulado'},
        'series': [
          {
            'type': 'line',
            'name': 'Acumulado',
            'showSymbol': true,
            'symbolSize': 5,
            'itemStyle': {'color': '#009688'},
            'areaStyle': {'opacity': 0.25},
            'data': cumulative,
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'A32',
    title: 'Calendario de estrenos',
    explanation: "El componente calendar con range = año dibuja una cuadrícula de días; la serie 'heatmap' con "
        "coordinateSystem: 'calendar' colorea los días con estreno. El año con más estrenos se calcula en Dart.",
    build: (d) {
      final dated = d.episodes.where((e) => e.airDate != null).toList();
      final perYear = countBy(dated, (e) => '${e.airDate!.year}');
      final year = perYear.isEmpty ? '${DateTime.now().year}' : sortedDesc(perYear).first.key;
      String iso(DateTime t) =>
          '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
      final perDay = countBy(dated.where((e) => '${e.airDate!.year}' == year), (e) => iso(e.airDate!));
      final maxV = perDay.values.fold<int>(1, (m, v) => v > m ? v : m);
      return {
        'title': chartTitle('A32', 'Estrenos en $year (${perYear[year] ?? 0} episodios)'),
        'tooltip': {'position': 'top', 'formatter': 'Fecha y estrenos: {c}'},
        'visualMap': {
          'type': 'continuous',
          'min': 0,
          'max': maxV,
          'orient': 'horizontal',
          'left': 'center',
          'bottom': 40,
          'text': ['más estrenos', 'ninguno'],
          'inRange': {'color': ['#E0F2F1', '#00695C']},
        },
        'calendar': {
          'top': 90,
          'left': 30,
          'right': 10,
          'cellSize': ['auto', 22],
          'range': year,
          'itemStyle': {'borderWidth': 0.5},
          'yearLabel': {'show': true},
          'dayLabel': {'fontSize': 8, 'firstDay': 1},
          'monthLabel': {'fontSize': 9},
        },
        'series': [
          {
            'type': 'heatmap',
            'name': 'Estrenos',
            'coordinateSystem': 'calendar',
            'data': [for (final e in perDay.entries) [e.key, e.value]],
          },
        ],
      };
    },
  ),
];

/// Nodos y enlaces del sankey A28: top 10 flujos origen → ubicación actual.
/// Prefijar "Origen:" / "Actual:" garantiza un grafo bipartito (sin ciclos).
Map<String, dynamic> sankeyNodesAndLinks(RMData d) {
  final flows = topN(countBy(d.characters, (c) => '${c.originName}\u0000${c.locationName}'), 10);
  final nodes = <String>[];
  final links = <Map<String, dynamic>>[];
  for (final f in flows) {
    final parts = f.key.split('\u0000');
    final source = 'Origen: ${parts[0]}';
    final target = 'Actual: ${parts[1]}';
    if (!nodes.contains(source)) nodes.add(source);
    if (!nodes.contains(target)) nodes.add(target);
    links.add({'source': source, 'target': target, 'value': f.value});
  }
  return {
    'data': [
      for (var i = 0; i < nodes.length; i++)
        {
          'name': nodes[i],
          'itemStyle': {'color': nodes[i].startsWith('Origen') ? '#5470C6' : '#FC8452'},
          // los destinos están en el borde derecho: su etiqueta va a la izquierda del nodo
          if (nodes[i].startsWith('Actual')) 'label': {'position': 'left'},
        },
    ],
    'links': links,
  };
}
