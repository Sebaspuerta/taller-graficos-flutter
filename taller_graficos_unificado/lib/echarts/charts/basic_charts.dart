// 31 gráficas básicas (B01–B31): sin leyenda ni interacción, un concepto por gráfica.
// Misma numeración y tema que el documento de la librería graphic.

import '../data/models.dart';
import '../data/rm_data.dart';
import 'chart_def.dart';
import 'palette.dart';

List<String> _names(List<Character> cs) => cs.map((c) => c.name).toList();
List<String> _ids(List<Character> cs) => cs.map((c) => '${c.id}').toList();
List<int> _eps(List<Character> cs) => cs.map((c) => c.episodeCount).toList();

/// Eje de categorías con nombres largos rotados y todas las etiquetas visibles.
Map<String, dynamic> _nameAxis(List<String> names) => {
      'type': 'category',
      'data': names,
      'axisLabel': {'rotate': 40, 'interval': 0, 'fontSize': 10},
    };

Map<String, dynamic> _idAxis(List<String> ids) => {
      'type': 'category',
      'name': 'ID',
      'data': ids,
      'boundaryGap': false,
    };

const Map<String, dynamic> _epsAxis = {'type': 'value', 'name': 'Episodios'};

final List<ChartDef> basicCharts = [
  ChartDef(
    code: 'B01',
    title: 'Barras verticales: episodios por personaje',
    explanation: "series.type: 'bar' con xAxis.type: 'category' dibuja una barra vertical por personaje (los 10 primeros por id). "
        "La altura es el número de episodios; axisLabel.rotate e interval: 0 muestran todos los nombres sin solaparse.",
    build: (d) {
      final cs = d.firstById(10);
      return {
        'title': chartTitle('B01', 'Episodios por personaje (top 10 por id)'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'bar', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B02',
    title: 'Barras horizontales: episodios por personaje',
    explanation: "Los mismos datos de B01, pero intercambiando los ejes: yAxis.type: 'category' con los nombres y xAxis.type: 'value'. "
        "ECharts orienta las barras según qué eje es de categorías; yAxis.inverse: true deja el id 1 arriba.",
    build: (d) {
      final cs = d.firstById(10);
      return {
        'title': chartTitle('B02', 'Episodios por personaje (horizontal)'),
        'grid': chartGrid(),
        'xAxis': {'type': 'value', 'name': 'Episodios', 'nameLocation': 'middle', 'nameGap': 25},
        'yAxis': {'type': 'category', 'data': _names(cs), 'inverse': true, 'axisLabel': {'fontSize': 10}},
        'series': [
          {'type': 'bar', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B03',
    title: 'Línea: episodios por ID',
    explanation: "series.type: 'line' une con segmentos rectos el número de episodios de los personajes con id 1–20. "
        "boundaryGap: false en el eje x hace que la línea empiece y termine en los bordes del grid.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B03', 'Episodios por ID (1–20)'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B04',
    title: 'Línea suavizada: episodios por ID',
    explanation: "smooth: true reemplaza los segmentos rectos por curvas spline que pasan por cada punto. "
        "Es la misma serie de B03; solo cambia la interpolación visual, no los datos.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B04', 'Episodios por ID (suavizada)'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'smooth': true, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B05',
    title: 'Dispersión: episodios vs ID',
    explanation: "series.type: 'scatter' sobre dos ejes value; cada dato es un par [id, episodios] de los 60 personajes. "
        "Al ser ambos ejes numéricos, la posición horizontal respeta la distancia real entre ids.",
    build: (d) {
      return {
        'title': chartTitle('B05', 'Episodios vs ID'),
        'grid': chartGrid(),
        'xAxis': {'type': 'value', 'name': 'ID'},
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'scatter',
            'data': [for (final c in d.characters) [c.id, c.episodeCount]],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B06',
    title: 'Área: episodios por ID',
    explanation: "Una serie 'line' con areaStyle: {} rellena el espacio entre la línea y el eje x. "
        "El área enfatiza el volumen acumulado visualmente frente a la línea sola de B03.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B06', 'Área: episodios por ID'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'areaStyle': <String, dynamic>{}, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B07',
    title: 'Área suavizada',
    explanation: "Combina areaStyle con smooth: true: el relleno sigue la curva spline en lugar de la poligonal. "
        "Útil para mostrar tendencia general sin resaltar los picos individuales.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B07', 'Área suavizada: episodios por ID'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'smooth': true, 'areaStyle': <String, dynamic>{}, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B08',
    title: 'Barras: conteo por estado',
    explanation: "countBy(status) en Dart y una barra por estado. Cada dato es un objeto {value, itemStyle: {color}} "
        "para aplicar la paleta de estado (verde Alive, rojo Dead, gris unknown) barra por barra.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.status, kStatuses);
      return {
        'title': chartTitle('B08', 'Personajes por estado'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': counts.keys.toList()},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {
            'type': 'bar',
            'data': [
              for (final e in counts.entries)
                {'value': e.value, 'itemStyle': {'color': statusColor(e.key)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B09',
    title: 'Barras: conteo por género',
    explanation: "Agrupa por gender y dibuja una barra por categoría (Male, Female, Genderless, unknown). "
        "itemStyle.color por dato usa la paleta de género para identificar cada barra.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.gender, kGenders);
      return {
        'title': chartTitle('B09', 'Personajes por género'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': counts.keys.toList()},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {
            'type': 'bar',
            'data': [
              for (final e in counts.entries)
                {'value': e.value, 'itemStyle': {'color': genderColor(e.key)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B10',
    title: 'Barras: conteo por especie',
    explanation: "Agrupa por species y ordena de mayor a menor. Como hay varias especies con nombres largos, "
        "axisLabel.rotate: 40 e interval: 0 fuerzan a mostrar todas las etiquetas inclinadas.",
    build: (d) {
      final entries = sortedDesc(countBy(d.characters, (c) => c.species));
      return {
        'title': chartTitle('B10', 'Personajes por especie'),
        'grid': chartGrid(),
        'xAxis': _nameAxis([for (final e in entries) e.key]),
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {'type': 'bar', 'data': [for (final e in entries) e.value]},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B11',
    title: 'Barras top 10 coloreadas por género',
    explanation: "Episodios de los 10 primeros personajes; el color de cada barra se define en itemStyle.color del dato "
        "según el género del personaje. Así una sola serie codifica una segunda variable categórica.",
    build: (d) {
      final cs = d.firstById(10);
      return {
        'title': chartTitle('B11', 'Top 10 coloreado por género'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'bar',
            'data': [
              for (final c in cs) {'value': c.episodeCount, 'itemStyle': {'color': genderColor(c.gender)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B12',
    title: 'Barras top 10 coloreadas por estado',
    explanation: "Igual que B11 pero el itemStyle.color de cada dato sale de la paleta de estado. "
        "Permite ver de un vistazo qué personajes con muchos episodios siguen vivos.",
    build: (d) {
      final cs = d.firstById(10);
      return {
        'title': chartTitle('B12', 'Top 10 coloreado por estado'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'bar',
            'data': [
              for (final c in cs) {'value': c.episodeCount, 'itemStyle': {'color': statusColor(c.status)}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B13',
    title: 'Barras apiladas: estado × género',
    explanation: "Una serie por género, todas con stack: 'total'. ECharts suma las series que comparten el mismo "
        "valor de stack y las dibuja una encima de otra, de modo que la altura total es el conteo por estado.",
    build: (d) {
      return {
        'title': chartTitle('B13', 'Estado × género (apiladas)'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': kStatuses},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          for (final g in kGenders)
            {
              'type': 'bar',
              'name': g,
              'stack': 'total',
              'itemStyle': {'color': genderColor(g)},
              'data': [
                for (final s in kStatuses) d.characters.where((c) => c.status == s && c.gender == g).length,
              ],
            },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B14',
    title: 'Línea + puntos visibles',
    explanation: "showSymbol: true y symbolSize: 8 dibujan un marcador circular en cada dato de la línea. "
        "Los puntos ayudan a distinguir los valores reales de la interpolación entre ellos.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B14', 'Línea con puntos: episodios por ID'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'showSymbol': true, 'symbol': 'circle', 'symbolSize': 8, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B15',
    title: 'Área + línea en capas',
    explanation: "Dos series sobre los mismos datos: la primera solo tiene areaStyle con opacity: 0.3 y lineStyle.width: 0; "
        "la segunda es una línea sólida. ECharts dibuja las series en orden, así la línea queda encima del relleno.",
    build: (d) {
      final cs = d.idRange(1, 20);
      final eps = _eps(cs);
      return {
        'title': chartTitle('B15', 'Área + línea en capas'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'line',
            'showSymbol': false,
            'lineStyle': {'width': 0},
            'areaStyle': {'opacity': 0.3, 'color': '#3F51B5'},
            'data': eps,
          },
          {
            'type': 'line',
            'showSymbol': false,
            'lineStyle': {'width': 2, 'color': '#3F51B5'},
            'data': eps,
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B16',
    title: 'Histograma: personajes por rango de episodios',
    explanation: "Los rangos (1-5, 6-10, 11-20, 21-30, 31+) se calculan en Dart y se dibujan como barras. "
        "barWidth: '95%' casi elimina el espacio entre barras para que se lea como histograma.",
    build: (d) {
      const bins = ['1-5', '6-10', '11-20', '21-30', '31+'];
      String bin(int e) => e <= 5
          ? '1-5'
          : e <= 10
              ? '6-10'
              : e <= 20
                  ? '11-20'
                  : e <= 30
                      ? '21-30'
                      : '31+';
      final counts = countByKeys(d.characters, (c) => bin(c.episodeCount), bins);
      return {
        'title': chartTitle('B16', 'Histograma de episodios'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'name': 'Episodios', 'nameLocation': 'middle', 'nameGap': 28, 'data': bins},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {'type': 'bar', 'barWidth': '95%', 'data': counts.values.toList()},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B17',
    title: 'Barras ordenadas descendente',
    explanation: "Se ordenan los 60 personajes por episodios (descendente) en Dart y se toman los 10 primeros. "
        "ECharts respeta el orden del arreglo xAxis.data, por lo que el ordenamiento se hace antes de construir el option.",
    build: (d) {
      final cs = sortedBy(d.characters, (c) => c.episodeCount, descending: true).take(10).toList();
      return {
        'title': chartTitle('B17', 'Top 10 por episodios (descendente)'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'bar', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B18',
    title: 'Barras filtradas: solo Alive',
    explanation: "Se filtra en Dart status == 'Alive' (primeros 15) antes de armar el option. "
        "ECharts solo recibe los datos ya filtrados; itemStyle.color de la serie usa el verde de la paleta de estado.",
    build: (d) {
      final cs = d.where((c) => c.status == 'Alive').take(15).toList();
      return {
        'title': chartTitle('B18', 'Episodios: solo Alive'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'bar', 'itemStyle': {'color': statusColor('Alive')}, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B19',
    title: 'Barras filtradas: solo Dead',
    explanation: "Mismo patrón que B18 con status == 'Dead' (primeros 15). "
        "El color rojo se aplica a toda la serie mediante series.itemStyle.color.",
    build: (d) {
      final cs = d.where((c) => c.status == 'Dead').take(15).toList();
      return {
        'title': chartTitle('B19', 'Episodios: solo Dead'),
        'grid': chartGrid(),
        'xAxis': _nameAxis(_names(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'bar', 'itemStyle': {'color': statusColor('Dead')}, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B20',
    title: 'Línea filtrada: solo Female',
    explanation: "Línea de episodios de los personajes con gender == 'Female'. "
        "lineStyle.color e itemStyle.color toman el rosa de la paleta de género; el eje x muestra el id de cada personaje.",
    build: (d) {
      final cs = d.where((c) => c.gender == 'Female');
      return {
        'title': chartTitle('B20', 'Episodios: solo Female'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'line',
            'lineStyle': {'color': genderColor('Female')},
            'itemStyle': {'color': genderColor('Female')},
            'data': _eps(cs),
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B21',
    title: 'Dispersión filtrada: solo Male',
    explanation: "Scatter [id, episodios] solo con gender == 'Male'. "
        "Ambos ejes son value, así que los huecos en el eje x corresponden a ids de otros géneros que se filtraron.",
    build: (d) {
      final cs = d.where((c) => c.gender == 'Male');
      return {
        'title': chartTitle('B21', 'Episodios vs ID: solo Male'),
        'grid': chartGrid(),
        'xAxis': {'type': 'value', 'name': 'ID'},
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'scatter',
            'itemStyle': {'color': genderColor('Male')},
            'data': [for (final c in cs) [c.id, c.episodeCount]],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B22',
    title: 'Barras: Human vs Alien',
    explanation: "Compara solo dos categorías de species contadas en Dart. "
        "barWidth: '40%' deja barras anchas y separadas, ideal para una comparación directa de dos valores.",
    build: (d) {
      final counts = countByKeys(d.characters, (c) => c.species, const ['Human', 'Alien']);
      return {
        'title': chartTitle('B22', 'Human vs Alien'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'data': counts.keys.toList()},
        'yAxis': {'type': 'value', 'name': 'Personajes'},
        'series': [
          {
            'type': 'bar',
            'barWidth': '40%',
            'data': [
              {'value': counts['Human'], 'itemStyle': {'color': '#2196F3'}},
              {'value': counts['Alien'], 'itemStyle': {'color': '#8BC34A'}},
            ],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B23',
    title: 'Línea escalonada',
    explanation: "step: 'middle' dibuja la línea como escalones: el cambio de nivel ocurre a mitad de camino entre dos datos. "
        "Otras opciones son 'start' y 'end'; se usa para valores discretos como un conteo de episodios.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B23', 'Línea escalonada: episodios por ID'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'step': 'middle', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B24',
    title: 'Área + línea suavizadas (naranja)',
    explanation: "smooth: true más areaStyle con color naranja semitransparente y lineStyle naranja sólido en la misma serie. "
        "Muestra cómo personalizar por separado el color del trazo y del relleno.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B24', 'Área + línea suavizadas'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'line',
            'smooth': true,
            'showSymbol': false,
            'lineStyle': {'color': '#FF9800', 'width': 3},
            'areaStyle': {'color': '#FF9800', 'opacity': 0.35},
            'data': _eps(cs),
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B25',
    title: 'Barras: IDs 1–10',
    explanation: "Barras con los ids 1–10 como categorías del eje x en lugar de los nombres. "
        "Con etiquetas cortas no hace falta rotarlas; boundaryGap por defecto (true) centra cada barra en su categoría.",
    build: (d) {
      final cs = d.idRange(1, 10);
      return {
        'title': chartTitle('B25', 'Episodios de los IDs 1–10'),
        'grid': chartGrid(),
        'xAxis': {'type': 'category', 'name': 'ID', 'data': _ids(cs)},
        'yAxis': _epsAxis,
        'series': [
          {'type': 'bar', 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B26',
    title: 'Dispersión con puntos grandes',
    explanation: "symbolSize: 16 agranda cada punto del scatter (el valor por defecto es 10). "
        "itemStyle.opacity: 0.7 deja ver los puntos que se superponen.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B26', 'Dispersión con puntos grandes'),
        'grid': chartGrid(),
        'xAxis': {'type': 'value', 'name': 'ID'},
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'scatter',
            'symbolSize': 16,
            'itemStyle': {'opacity': 0.7, 'color': '#673AB7'},
            'data': [for (final c in cs) [c.id, c.episodeCount]],
          },
        ],
      };
    },
  ),
  ChartDef(
    code: 'B27',
    title: 'Barras color azul (top 10)',
    explanation: "series.itemStyle.color: '#2196F3' aplica un único color a todas las barras de la serie, "
        "sobrescribiendo la paleta por defecto de ECharts.",
    build: (d) => _solidBars(d, 'B27', 'Top 10 en azul', '#2196F3'),
  ),
  ChartDef(
    code: 'B28',
    title: 'Barras color verde (top 10)',
    explanation: "Mismo gráfico que B27 con itemStyle.color: '#4CAF50'. "
        "Cambiar el color de la serie no requiere tocar los datos, solo el estilo.",
    build: (d) => _solidBars(d, 'B28', 'Top 10 en verde', '#4CAF50'),
  ),
  ChartDef(
    code: 'B29',
    title: 'Barras color rojo (top 10)',
    explanation: "Mismo gráfico con itemStyle.color: '#F44336'. "
        "Junto con B27 y B28 muestra cómo el color de la serie se controla desde una sola propiedad.",
    build: (d) => _solidBars(d, 'B29', 'Top 10 en rojo', '#F44336'),
  ),
  ChartDef(
    code: 'B30',
    title: 'Línea + puntos: IDs mayores a 10',
    explanation: "Se filtran en Dart los ids 11–30 y se dibuja una línea con showSymbol: true. "
        "symbol: 'emptyCircle' deja los marcadores huecos, con borde del color de la serie.",
    build: (d) {
      final cs = d.idRange(11, 30);
      return {
        'title': chartTitle('B30', 'Episodios por ID (IDs > 10)'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {'type': 'line', 'showSymbol': true, 'symbol': 'emptyCircle', 'symbolSize': 8, 'data': _eps(cs)},
        ],
      };
    },
  ),
  ChartDef(
    code: 'B31',
    title: 'Área + línea + puntos combinados',
    explanation: "Una sola serie line cian con smooth: true, areaStyle, showSymbol: true y symbolSize: 7. "
        "Reúne en una única serie las tres marcas: relleno, trazo suavizado y puntos de datos.",
    build: (d) {
      final cs = d.idRange(1, 20);
      return {
        'title': chartTitle('B31', 'Área + línea + puntos'),
        'grid': chartGrid(),
        'xAxis': _idAxis(_ids(cs)),
        'yAxis': _epsAxis,
        'series': [
          {
            'type': 'line',
            'smooth': true,
            'showSymbol': true,
            'symbolSize': 7,
            'lineStyle': {'color': '#00BCD4', 'width': 2},
            'itemStyle': {'color': '#00BCD4'},
            'areaStyle': {'color': '#00BCD4', 'opacity': 0.3},
            'data': _eps(cs),
          },
        ],
      };
    },
  ),
];

/// B27–B29: barras de un color sólido para los 10 primeros personajes.
Map<String, dynamic> _solidBars(RMData d, String code, String title, String color) {
  final cs = d.firstById(10);
  return {
    'title': chartTitle(code, title),
    'grid': chartGrid(),
    'xAxis': _nameAxis(_names(cs)),
    'yAxis': _epsAxis,
    'series': [
      {'type': 'bar', 'itemStyle': {'color': color}, 'data': _eps(cs)},
    ],
  };
}
