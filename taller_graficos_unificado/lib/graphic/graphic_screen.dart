
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'char_data.dart';

class GraphicHomeScreen extends StatelessWidget {
  const GraphicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Rick & Morty - Graphic Charts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<CharData>(
        future: fetchCharData(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error: ${snap.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final d = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
              // -----------------------------------------------
              // SECCION A: 31 GRAFICAS BASICAS
              // -----------------------------------------------
              _sec('GRAFICAS BASICAS (31)'),
              _card(
                'B01',
                'Barras verticales - Episodios por personaje (top 10)',
                _b01(d.chars),
              ),
              _card(
                'B02',
                'Barras horizontales - Episodios por personaje',
                _b02(d.chars),
              ),
              _card(
                'B03',
                'Lineas - Tendencia de episodios (todos los IDs)',
                _b03(d.chars),
              ),
              _card(
                'B04',
                'Lineas suavizadas - Episodios por ID',
                _b04(d.chars),
              ),
              _card(
                'B05',
                'Puntos / Dispersion - Episodios vs ID',
                _b05(d.chars),
              ),
              _card('B06', 'Area - Episodios por ID', _b06(d.chars)),
              _card('B07', 'Area suavizada - Episodios por ID', _b07(d.chars)),
              _card(
                'B08',
                'Barras - Conteo por estado (Alive / Dead / unknown)',
                _b08(d.byStatus),
              ),
              _card('B09', 'Barras - Conteo por genero', _b09(d.byGender)),
              _card('B10', 'Barras - Conteo por especie', _b10(d.bySpecies)),
              _card(
                'B11',
                'Barras coloreadas por genero (top 10)',
                _b11(d.chars),
              ),
              _card(
                'B12',
                'Barras coloreadas por estado (top 10)',
                _b12(d.chars),
              ),
              _card('B13', 'Barras apiladas - Estado x Genero', _b13(d.bySG)),
              _card('B14', 'Lineas + Puntos combinados', _b14(d.chars)),
              _card('B15', 'Area + Linea combinados', _b15(d.chars)),
              _card(
                'B16',
                'Histograma - Distribucion de episodios por rango',
                _b16(d.chars),
              ),
              _card(
                'B17',
                'Barras ordenadas descendente - Top episodios',
                _b17(d.chars),
              ),
              _card('B18', 'Barras - Solo personajes vivos', _b18(d.chars)),
              _card('B19', 'Barras - Solo personajes muertos', _b19(d.chars)),
              _card('B20', 'Lineas - Solo personajes femeninos', _b20(d.chars)),
              _card(
                'B21',
                'Puntos - Solo personajes masculinos',
                _b21(d.chars),
              ),
              _card(
                'B22',
                'Barras - Comparacion Humanos vs Aliens',
                _b22(d.bySpecies),
              ),
              _card(
                'B23',
                'Linea recta (sin suavizar) - Episodios',
                _b23(d.chars),
              ),
              _card('B24', 'Area naranja suavizada + Linea', _b24(d.chars)),
              _card(
                'B25',
                'Barras - Primeros 10 personajes (IDs 1-10)',
                _b25(d.chars),
              ),
              _card('B26', 'Puntos con tamano destacado', _b26(d.chars)),
              _card('B27', 'Barras color azul (top 10)', _b27(d.chars)),
              _card('B28', 'Barras color verde (top 10)', _b28(d.chars)),
              _card('B29', 'Barras color rojo (top 10)', _b29(d.chars)),
              _card('B30', 'Lineas + Puntos - IDs del 11 al 20', _b30(d.chars)),
              _card(
                'B31',
                'Area + Linea + Puntos combinado (cyan)',
                _b31(d.chars),
              ),
              const SizedBox(height: 24),
              // -----------------------------------------------
              // SECCION B: 32 GRAFICAS AVANZADAS
              // -----------------------------------------------
              _sec('GRAFICAS AVANZADAS (32)'),
              _card(
                'A01',
                'Pastel - Distribucion por estado',
                _a01(d.byStatus),
              ),
              _card(
                'A02',
                'Pastel - Distribucion por genero',
                _a02(d.byGender),
              ),
              _card(
                'A03',
                'Pastel - Distribucion por especie',
                _a03(d.bySpecies),
              ),
              _card('A04', 'Dona - Genero (hueco 40%)', _a04(d.byGender)),
              _card(
                'A05',
                'Dona - Estado de vida (hueco 50%)',
                _a05(d.byStatus),
              ),
              _card(
                'A06',
                'Rosa polar - Episodios por personaje (top 10)',
                _a06(d.chars),
              ),
              _card(
                'A07',
                'Rosa polar - Conteo por especie',
                _a07(d.bySpecies),
              ),
              _card('A08', 'Pastel apilado - Estado x Genero', _a08(d.bySG)),
              _card(
                'A09',
                'Barras polares radiales - Por estado',
                _a09(d.byStatus),
              ),
              _card(
                'A10',
                'Barras polares radiales - Por genero',
                _a10(d.byGender),
              ),
              _card('A11', 'Area polar - Episodios (top 10)', _a11(d.chars)),
              _card('A12', 'Linea polar - Episodios (top 10)', _a12(d.chars)),
              _card(
                'A13',
                'Barras apiladas 100% - Estado x Genero',
                _a13(d.bySG),
              ),
              _card(
                'A14',
                'Barras agrupadas (dodge) - Estado x Genero',
                _a14(d.bySG),
              ),
              _card(
                'A15',
                'Barras horizontales apiladas - Estado x Genero',
                _a15(d.bySG),
              ),
              _card(
                'A16',
                'Barras horizontales agrupadas - Estado x Genero',
                _a16(d.bySG),
              ),
              _card(
                'A17',
                'Puntos coloreados por genero (todos)',
                _a17(d.chars),
              ),
              _card(
                'A18',
                'Puntos coloreados por estado (todos)',
                _a18(d.chars),
              ),
              _card(
                'A19',
                'Puntos coloreados por especie (todos)',
                _a19(d.chars),
              ),
              _card(
                'A20',
                'Lineas + Puntos coloreados por genero (top 10)',
                _a20(d.chars),
              ),
              _card(
                'A21',
                'Area apilada - Conteo por genero en cada estado',
                _a21(d.bySG),
              ),
              _card('A22', 'Barras multi-color por especie', _a22(d.bySpecies)),
              _card(
                'A23',
                'Barras arcoiris - Episodios (cada ID distinto color)',
                _a23(d.chars),
              ),
              _card(
                'A24',
                'Puntos grandes coloreados por estado',
                _a24(d.chars),
              ),
              _card(
                'A25',
                'Doble relleno de area + linea suavizada',
                _a25(d.chars),
              ),
              _card(
                'A26',
                'Dona con hueco 30% - Distribucion especie',
                _a26(d.bySpecies),
              ),
              _card(
                'A27',
                'Rosa polar invertida (transposed) - Especie',
                _a27(d.bySpecies),
              ),
              _card(
                'A28',
                'Barras polares Nightingale 360 - Top 10 personajes',
                _a28(d.chars),
              ),
              _card(
                'A29',
                'Area apilada suavizada - Episodios por genero',
                _a29(d.chars),
              ),
              _card(
                'A30',
                'Barras horizontales coloreadas por estado (top 10)',
                _a30(d.chars),
              ),
              _card(
                'A31',
                'Linea + Puntos - Episodios ACUMULADOS',
                _a31(d.chars),
              ),
              _card(
                'A32',
                'Dona grande (hueco 55%) - Distribucion especie',
                _a32(d.bySpecies),
              ),
            ],
          ));
        },
      ),
    );
  }
}

// =========================================================
// HELPERS DE UI
// =========================================================

// Titulo de seccion
Widget _sec(String t) => Builder(
  builder: (context) => SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        t,
        style: TextStyle(
          color: Colors.teal.shade800,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    ),
  ),
);

// Tarjeta de grafica con etiqueta de codigo visible (ej: B01, A14)
Widget _card(String code, String title, Widget chart) => Builder(
  builder: (context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 36) / 2,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black87, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      chart,
    ],
  ),
  );
  },
);

// Contenedor de grafica
Widget _box(double h, Widget c) => SizedBox(
  height: h,
  child: Padding(padding: const EdgeInsets.all(10), child: c),
);

// =========================================================
// PALETAS DE COLORES
// =========================================================
// Estado: verde=Alive, rojo=Dead, gris=unknown
const _sc = [Colors.green, Colors.red, Colors.grey];
// Genero: azul=Male, rosa=Female, naranja=unknown, morado=Genderless
const _gc = [Colors.blue, Colors.pink, Colors.orange, Colors.purple];
// Especie: indigo=Human, cyan=Alien, amber, lime, deepOrange
const _pc = [
  Colors.indigo,
  Colors.cyan,
  Colors.amber,
  Colors.lime,
  Colors.deepOrange,
];
// Arcoiris para codificar por ID
const _rb = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.amber,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.deepPurple,
  Colors.brown,
  Colors.blueGrey,
  Colors.red,
  Colors.orange,
];

// =========================================================
// 31 GRAFICAS BASICAS
// =========================================================

// B01 - Barras verticales: episodios de los primeros 10 personajes
Widget _b01(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    280,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.teal),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B02 - Barras horizontales: episodios de los primeros 10 personajes
Widget _b02(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    320,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.orange),
        ),
      ],
      coord: RectCoord(transposed: true),
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B03 - Lineas: todos los 20 personajes (eje X = ID)
Widget _b03(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      LineMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.blue),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B04 - Lineas suavizadas (smooth: true)
Widget _b04(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      LineMark(
        shape: ShapeEncode(value: BasicLineShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.purple),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B05 - Puntos / Dispersion
Widget _b05(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.red),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B06 - Area simple
Widget _b06(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.teal.withValues(alpha: 0.5)),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B07 - Area suavizada
Widget _b07(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.indigo.withValues(alpha: 0.6)),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B08 - Barras: conteo agrupado por estado
Widget _b08(List<Map<String, dynamic>> d) => _box(
  240,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _sc),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B09 - Barras: conteo agrupado por genero
Widget _b09(List<Map<String, dynamic>> d) => _box(
  240,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _gc),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B10 - Barras: conteo agrupado por especie
Widget _b10(List<Map<String, dynamic>> d) => _box(
  240,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _pc),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B11 - Barras coloreadas segun el genero del personaje (top 10)
Widget _b11(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    280,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
        'gender': Variable(accessor: (Map m) => m['gender'] as String),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'gender', values: _gc),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B12 - Barras coloreadas segun el estado del personaje (top 10)
Widget _b12(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    280,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
        'status': Variable(accessor: (Map m) => m['status'] as String),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'status', values: _sc),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B13 - Barras apiladas: cantidad de genero dentro de cada estado
Widget _b13(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      IntervalMark(
        position: Varset('status') * Varset('count'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B14 - Lineas + Puntos superpuestos
Widget _b14(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      LineMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.cyan),
      ),
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.yellow),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B15 - Area semitransparente + Linea encima
Widget _b15(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.teal.withValues(alpha: 0.3)),
      ),
      LineMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.teal),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B16 - Histograma: cantidad de personajes segun rangos de episodios
Widget _b16(List<Map<String, dynamic>> d) {
  final b = {'1-5': 0, '6-10': 0, '11-20': 0, '21-30': 0, '31+': 0};
  for (final c in d) {
    final e = c['episodes'] as int;
    if (e <= 5) {
      b['1-5'] = b['1-5']! + 1;
    } else if (e <= 10) {
      b['6-10'] = b['6-10']! + 1;
    } else if (e <= 20) {
      b['11-20'] = b['11-20']! + 1;
    } else if (e <= 30) {
      b['21-30'] = b['21-30']! + 1;
    } else {
      b['31+'] = b['31+']! + 1;
    }
  }
  final rows = b.entries
      .map((e) => {'range': e.key, 'count': e.value.toDouble()})
      .toList();
  return _box(
    240,
    Chart(
      data: rows,
      variables: {
        'range': Variable(accessor: (Map m) => m['range'] as String),
        'count': Variable(accessor: (Map m) => m['count'] as double),
      },
      marks: [
        IntervalMark(
          position: Varset('range') * Varset('count'),
          color: ColorEncode(value: Colors.amber),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B17 - Barras ordenadas de mayor a menor episodios (top 10)
Widget _b17(List<Map<String, dynamic>> d) {
  final t =
      ([...d]..sort(
            (a, b) => (b['episodes'] as int).compareTo(a['episodes'] as int),
          ))
          .take(10)
          .toList();
  return _box(
    280,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.deepOrange),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B18 - Solo personajes con status = Alive
Widget _b18(List<Map<String, dynamic>> d) {
  final alive = d.where((c) => c['status'] == 'Alive').toList();
  if (alive.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Sin datos de vivos',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
  return _box(
    260,
    Chart(
      data: alive,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.green),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B19 - Solo personajes con status = Dead
Widget _b19(List<Map<String, dynamic>> d) {
  final dead = d.where((c) => c['status'] == 'Dead').toList();
  if (dead.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Sin datos de muertos',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
  return _box(
    250,
    Chart(
      data: dead,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.red),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B20 - Lineas con solo mujeres (gender = Female)
Widget _b20(List<Map<String, dynamic>> d) {
  final fem = d.where((c) => c['gender'] == 'Female').toList();
  if (fem.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Sin personajes femeninos',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
  return _box(
    250,
    Chart(
      data: fem,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        LineMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.pink),
        ),
        PointMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.pinkAccent),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B21 - Puntos con solo hombres (gender = Male)
Widget _b21(List<Map<String, dynamic>> d) {
  final mal = d.where((c) => c['gender'] == 'Male').toList();
  return _box(
    250,
    Chart(
      data: mal,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        PointMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.lightBlue),
          size: SizeEncode(value: 7),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B22 - Barras comparando conteo de cada especie
Widget _b22(List<Map<String, dynamic>> d) => _box(
  240,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _pc),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B23 - Linea recta (sin smooth, sin step) - color lima
Widget _b23(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      LineMark(
        shape: ShapeEncode(value: BasicLineShape(smooth: false)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.lime),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B24 - Area naranja suavizada + Linea naranja encima
Widget _b24(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.orange.withValues(alpha: 0.55)),
      ),
      LineMark(
        shape: ShapeEncode(value: BasicLineShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.orange),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B25 - Solo los 10 primeros personajes por ID (1-10)
Widget _b25(List<Map<String, dynamic>> d) {
  final t = d.where((c) => (c['id'] as int) <= 10).toList();
  return _box(
    260,
    Chart(
      data: t,
      variables: {
        'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('idStr') * Varset('ep'),
          color: ColorEncode(value: Colors.lightBlue),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B26 - Puntos con tamano mayor al default (size: 9)
Widget _b26(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.greenAccent),
        size: SizeEncode(value: 9),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// B27 - Barras azules (top 10)
Widget _b27(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    260,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.blue),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B28 - Barras verdes (top 10)
Widget _b28(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    260,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.green),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B29 - Barras rojas (top 10)
Widget _b29(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    260,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.red),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B30 - Lineas + Puntos solo con IDs 11 al 20
Widget _b30(List<Map<String, dynamic>> d) {
  final t = d.where((c) => (c['id'] as int) > 10).toList();
  return _box(
    250,
    Chart(
      data: t,
      variables: {
        'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        LineMark(
          position: Varset('idStr') * Varset('ep'),
          color: ColorEncode(value: Colors.deepPurple),
        ),
        PointMark(
          position: Varset('idStr') * Varset('ep'),
          color: ColorEncode(value: Colors.deepPurpleAccent),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// B31 - Combinacion triple: Area + Linea + Puntos (cyan)
Widget _b31(List<Map<String, dynamic>> d) => _box(
  270,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.cyan.withValues(alpha: 0.35)),
      ),
      LineMark(
        shape: ShapeEncode(value: BasicLineShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.cyan),
      ),
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.white),
        size: SizeEncode(value: 4),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// =========================================================
// 32 GRAFICAS AVANZADAS
// =========================================================

// Helper: pastel / dona. inner=0 -> pastel, inner>0 -> dona con hueco
Widget _pie(
  List<Map<String, dynamic>> d,
  List<Color> colors, {
  double inner = 0.0,
}) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    transforms: [Proportion(variable: 'value', as: 'pct')],
    marks: [
      IntervalMark(
        position: Varset('pct') / Varset('label'),
        color: ColorEncode(variable: 'label', values: colors),
        modifiers: [StackModifier()],
      ),
    ],
    coord: PolarCoord(transposed: true, dimCount: 1, startRadius: inner),
  ),
);

// A01 - Pastel: estado (Alive / Dead / unknown)
Widget _a01(List<Map<String, dynamic>> d) => _pie(d, _sc);
// A02 - Pastel: genero (Male / Female / ...)
Widget _a02(List<Map<String, dynamic>> d) => _pie(d, _gc);
// A03 - Pastel: especie (Human / Alien / ...)
Widget _a03(List<Map<String, dynamic>> d) => _pie(d, _pc);
// A04 - Dona: genero, hueco 40%
Widget _a04(List<Map<String, dynamic>> d) => _pie(d, _gc, inner: 0.4);
// A05 - Dona: estado, hueco 50%
Widget _a05(List<Map<String, dynamic>> d) => _pie(d, _sc, inner: 0.5);

// A06 - Rosa polar (Nightingale): episodios por nombre, radio = episodios
Widget _a06(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    320,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'name', values: _rb),
        ),
      ],
      coord: PolarCoord(),
    ),
  );
}

// A07 - Rosa polar: conteo de cada especie
Widget _a07(List<Map<String, dynamic>> d) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _pc),
      ),
    ],
    coord: PolarCoord(),
  ),
);

// A08 - Pastel apilado: proporciones de genero dentro de cada estado
Widget _a08(List<Map<String, dynamic>> d) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    transforms: [Proportion(variable: 'count', as: 'pct')],
    marks: [
      IntervalMark(
        position: Varset('pct') / Varset('status'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    coord: PolarCoord(transposed: true, dimCount: 1),
  ),
);

// A09 - Barras polares radiales por estado (no transposed)
Widget _a09(List<Map<String, dynamic>> d) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _sc),
      ),
    ],
    coord: PolarCoord(transposed: false),
    axes: [Defaults.circularAxis],
  ),
);

// A10 - Barras polares radiales por genero
Widget _a10(List<Map<String, dynamic>> d) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _gc),
      ),
    ],
    coord: PolarCoord(transposed: false),
    axes: [Defaults.circularAxis],
  ),
);

// A11 - Area polar: episodios de los primeros 10 personajes
Widget _a11(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    320,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        AreaMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.teal.withValues(alpha: 0.5)),
        ),
      ],
      coord: PolarCoord(),
      axes: [Defaults.circularAxis],
    ),
  );
}

// A12 - Linea polar: episodios de los primeros 10 personajes
Widget _a12(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    320,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        LineMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(value: Colors.purpleAccent),
        ),
      ],
      coord: PolarCoord(),
      axes: [Defaults.circularAxis],
    ),
  );
}

// A13 - Barras apiladas 100% (Proportion): proporcion de genero en cada estado
Widget _a13(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    transforms: [Proportion(variable: 'count', as: 'pct')],
    marks: [
      IntervalMark(
        position: Varset('status') * Varset('pct'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A14 - Barras agrupadas (DodgeModifier): genero lado a lado por estado
Widget _a14(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      IntervalMark(
        position: Varset('status') * Varset('count'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [DodgeModifier()],
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A15 - Barras horizontales apiladas: genero en cada estado
Widget _a15(List<Map<String, dynamic>> d) => _box(
  240,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      IntervalMark(
        position: Varset('status') * Varset('count'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    coord: RectCoord(transposed: true),
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A16 - Barras horizontales agrupadas: genero lado a lado por estado
Widget _a16(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      IntervalMark(
        position: Varset('status') * Varset('count'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [DodgeModifier()],
      ),
    ],
    coord: RectCoord(transposed: true),
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A17 - Puntos coloreados por genero (todos los 20 personajes)
Widget _a17(List<Map<String, dynamic>> d) => _box(
  270,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'gender', values: _gc),
        size: SizeEncode(value: 8),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A18 - Puntos coloreados por estado (verde=vivo, rojo=muerto, gris=unknown)
Widget _a18(List<Map<String, dynamic>> d) => _box(
  270,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      'status': Variable(accessor: (Map m) => m['status'] as String),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'status', values: _sc),
        size: SizeEncode(value: 8),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A19 - Puntos coloreados por especie (Human, Alien, ...)
Widget _a19(List<Map<String, dynamic>> d) => _box(
  270,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      'species': Variable(accessor: (Map m) => m['species'] as String),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'species', values: _pc),
        size: SizeEncode(value: 10),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A20 - Lineas + Puntos coloreados por genero (top 10)
Widget _a20(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    280,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
        'gender': Variable(accessor: (Map m) => m['gender'] as String),
      },
      marks: [
        LineMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'gender', values: _gc),
        ),
        PointMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'gender', values: _gc),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// A21 - Area apilada: cantidad de cada genero en cada estado (eje X = estado)
Widget _a21(List<Map<String, dynamic>> d) => _box(
  260,
  Chart(
    data: d,
    variables: {
      'status': Variable(accessor: (Map m) => m['status'] as String),
      'count': Variable(accessor: (Map m) => (m['count'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      AreaMark(
        position: Varset('status') * Varset('count'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A22 - Barras de conteo, una barra por especie con color distinto
Widget _a22(List<Map<String, dynamic>> d) => _box(
  250,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _pc),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A23 - Barras de episodios, cada ID con un color diferente (arcoiris)
Widget _a23(List<Map<String, dynamic>> d) => _box(
  280,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'idStr', values: _rb),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A24 - Puntos grandes (size 12) coloreados por estado
Widget _a24(List<Map<String, dynamic>> d) => _box(
  270,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      'status': Variable(accessor: (Map m) => m['status'] as String),
    },
    marks: [
      PointMark(
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'status', values: _sc),
        size: SizeEncode(value: 12),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A25 - Dos capas de Area (colores distintos) + Linea encima
Widget _a25(List<Map<String, dynamic>> d) => _box(
  280,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
    },
    marks: [
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.deepPurple.withValues(alpha: 0.3)),
      ),
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.pink.withValues(alpha: 0.2)),
      ),
      LineMark(
        shape: ShapeEncode(value: BasicLineShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(value: Colors.deepPurple),
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A26 - Dona especie con hueco del 30%
Widget _a26(List<Map<String, dynamic>> d) => _pie(d, _pc, inner: 0.3);

// A27 - Rosa polar invertida (transposed: true): especie
Widget _a27(List<Map<String, dynamic>> d) => _box(
  300,
  Chart(
    data: d,
    variables: {
      'label': Variable(accessor: (Map m) => m['label'] as String),
      'value': Variable(accessor: (Map m) => (m['value'] as int).toDouble()),
    },
    marks: [
      IntervalMark(
        position: Varset('label') * Varset('value'),
        color: ColorEncode(variable: 'label', values: _pc),
      ),
    ],
    coord: PolarCoord(transposed: true),
  ),
);

// A28 - Nightingale 360: barras polares con radio inicial (top 10 personajes)
Widget _a28(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    320,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'name', values: _rb),
        ),
      ],
      coord: PolarCoord(startRadius: 0.1),
    ),
  );
}

// A29 - Area suavizada apilada: episodios con capas de color por genero
Widget _a29(List<Map<String, dynamic>> d) => _box(
  280,
  Chart(
    data: d,
    variables: {
      'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
      'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
      'gender': Variable(accessor: (Map m) => m['gender'] as String),
    },
    marks: [
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        position: Varset('idStr') * Varset('ep'),
        color: ColorEncode(variable: 'gender', values: _gc),
        modifiers: [StackModifier()],
      ),
    ],
    axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
  ),
);

// A30 - Barras horizontales coloreadas por estado (top 10)
Widget _a30(List<Map<String, dynamic>> d) {
  final t = d.take(10).toList();
  return _box(
    300,
    Chart(
      data: t,
      variables: {
        'name': Variable(accessor: (Map m) => m['name'] as String),
        'ep': Variable(accessor: (Map m) => (m['episodes'] as int).toDouble()),
        'status': Variable(accessor: (Map m) => m['status'] as String),
      },
      marks: [
        IntervalMark(
          position: Varset('name') * Varset('ep'),
          color: ColorEncode(variable: 'status', values: _sc),
        ),
      ],
      coord: RectCoord(transposed: true),
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// A31 - Linea + Puntos + Area: episodios ACUMULADOS de personaje en personaje
Widget _a31(List<Map<String, dynamic>> d) {
  int acum = 0;
  final rows = d.map((c) {
    acum += c['episodes'] as int;
    return {'idStr': c['idStr'] as String, 'acum': acum.toDouble()};
  }).toList();
  return _box(
    280,
    Chart(
      data: rows,
      variables: {
        'idStr': Variable(accessor: (Map m) => m['idStr'] as String),
        'acum': Variable(accessor: (Map m) => m['acum'] as double),
      },
      marks: [
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          position: Varset('idStr') * Varset('acum'),
          color: ColorEncode(value: Colors.amber.withValues(alpha: 0.4)),
        ),
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          position: Varset('idStr') * Varset('acum'),
          color: ColorEncode(value: Colors.amber),
        ),
        PointMark(
          position: Varset('idStr') * Varset('acum'),
          color: ColorEncode(value: Colors.white),
          size: SizeEncode(value: 5),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    ),
  );
}

// A32 - Dona grande especie con hueco del 55% (dona ancha)
Widget _a32(List<Map<String, dynamic>> d) => _pie(d, _pc, inner: 0.55);

