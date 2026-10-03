# Taller de librerías de gráficos en Flutter

Aplicación Flutter que compara cuatro librerías de gráficos usando los mismos
datos reales de la [API de Rick and Morty](https://rickandmortyapi.com/api).
Cada librería muestra **63 gráficas: 31 básicas y 32 avanzadas**. Ningún dato
es inventado ni aleatorio: todo se descarga de la API al abrir cada sección.

La pantalla de inicio tiene una tarjeta por librería. Cada tarjeta abre una
pantalla con dos pestañas, **Básicas (31)** y **Avanzadas (32)**.

| Librería | Paquete | Datos que descarga |
|---|---|---|
| Syncfusion | `syncfusion_flutter_charts` | Todos los personajes, episodios y locaciones (`/character`, `/episode`, `/location`, siguiendo la paginación) |
| fl_chart | `fl_chart` | `/character?page=1` (20 personajes) y todos los episodios de `/episode` |
| graphic | `graphic` | `/character?page=1` (20 personajes) |
| ECharts | `flutter_echarts` | `/character` páginas 1–3 (60 personajes) y todos los episodios de `/episode` |

graphic y fl_chart usan los mismos 20 personajes, y la numeración B01–B31 es la
misma en las dos. Así se pueden comparar 1 a 1.

## Gráficas básicas y avanzadas

Una gráfica es **básica (B01–B31)** si cumple todo esto:

- Usa un solo tipo de gráfica simple: barras, líneas, áreas o puntos (dispersión).
- Muestra una sola serie de datos: un color, o un color por categoría, sin apilar ni agrupar.
- Es estática: sin tooltip, toque, zoom ni animación especial.
- Muestra un solo concepto. Entre una básica y otra solo cambia el tipo, un
  filtro (solo Alive, solo Female, IDs 1–10…), el orden, la forma (suavizada,
  escalonada) o el color.
- Usa los datos de `/character` tal como vienen, con conteos simples por estado,
  género o especie.

B13 (barras apiladas estado × género) es la única excepción a "sin apilar".
Se mantiene en básicas para conservar la numeración del documento de graphic.

Una gráfica es **avanzada (A01–A32)** si cumple al menos una de estas condiciones:

1. Tipo no cartesiano: pastel, dona, radar, velas, etc.
2. Varias series o variables cruzadas: barras apiladas, agrupadas o al 100 %, varias líneas, estado × género.
3. Interacción: tooltip al tocar, sector que se resalta, línea guía, animación al cambiar un filtro.
4. Datos transformados en Dart antes de graficar: porcentajes, acumulados, promedios, diferencias contra el promedio, rangos mín/máx.
5. Elementos visuales extra: gradientes, líneas de referencia, zonas resaltadas, área entre dos líneas, etiquetas de valor, tamaño del punto según un dato.
6. Datos de otro endpoint (`/episode`) o combinados entre endpoints.

En fl_chart y en flutter_echarts, la pantalla de detalle de cada gráfica
incluye una explicación de 2–3 líneas. En las avanzadas de fl_chart, esa
explicación dice qué condiciones cumple la gráfica.

## Estructura

```
taller_graficos_unificado/
├── lib/
│   ├── main.dart                     Pantalla de inicio con las 4 librerías
│   ├── syncfusion/
│   │   ├── syncfusion_home.dart      Carga de datos y pestañas
│   │   ├── charts/basic_charts.dart      31 básicas
│   │   ├── charts/advanced_charts.dart   32 avanzadas
│   │   └── data/chart_data.dart          Consumo de la API y datasets
│   ├── fl_chart/
│   │   ├── fl_chart_screen.dart      Pestañas, lista y pantalla de detalle
│   │   ├── charts/chart_def.dart         Definición de gráfica, ejes y colores
│   │   ├── charts/basic_charts.dart      B01–B31
│   │   ├── charts/advanced_charts.dart   A01–A32
│   │   └── data/                         api_service, fl_data, models
│   ├── graphic/
│   │   ├── graphic_screen.dart       Las 63 gráficas en una cuadrícula
│   │   └── char_data.dart            Consumo de la API y conteos
│   └── echarts/
│       ├── echarts_home.dart         Pestañas y lista
│       ├── charts/                   basic_charts, advanced_charts, chart_def, palette
│       ├── data/                     api_service, models, rm_data
│       └── pages/chart_page.dart     Pantalla de detalle (WebView de ECharts)
└── test/
    ├── conteo_test.dart              31 + 32 = 63 y códigos sin repetir
    ├── render_test.dart              Las 63 de fl_chart se renderizan sin errores
    └── fixtures/                     Datos de muestra (JSON real recortado de la API)
```

## Cómo correrlo

Requiere Flutter con Dart 3.7 o superior y un emulador o dispositivo Android
con conexión a internet.

```bash
cd taller_graficos_unificado
flutter pub get
flutter run
```

`flutter_echarts` dibuja dentro de un WebView, así que **solo funciona en
Android e iOS**. En Web, Windows, Linux o macOS, la tarjeta de flutter_echarts
muestra un aviso en lugar de abrir la sección. Las otras tres librerías no
tienen esa restricción.

La sección de Syncfusion descarga todas las páginas de la API, así que la
primera vez tarda unos segundos en cargar. Los datos quedan en memoria y la
segunda vez abre de inmediato. Si una descarga falla, la sección muestra el
error y un botón **Reintentar**.

## Pruebas

```bash
cd taller_graficos_unificado
flutter analyze
flutter test
```

- `test/conteo_test.dart` verifica que fl_chart y flutter_echarts tengan 31
  básicas y 32 avanzadas (63 en total). También revisa que los códigos sean
  exactamente B01–B31 y A01–A32, sin repetir.
- `test/render_test.dart` construye las 63 gráficas de fl_chart dentro de un
  `MaterialApp` con los datos de `test/fixtures/` y verifica que ninguna lance
  una excepción. Usa datos fijos, así que no necesita internet.
