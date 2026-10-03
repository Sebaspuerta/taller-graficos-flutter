# Taller Librerías de Gráficos en Flutter — proyecto unificado

Una sola app con las 4 librerías del taller. La pantalla de inicio muestra
4 tarjetas (una por librería); cada una entra a la implementación de esa
librería, que descarga sus propios datos de la API de Rick and Morty y
muestra sus 63 (o 64) gráficas.

## ⚠️ Antes de correrlo: falta un archivo de `graphic`

Al unir el archivo de **graphic** (`1790787291830_main.dart`) encontré que
usa dos cosas que **no están definidas en ningún lado del archivo**:

```dart
body: FutureBuilder<CharData>(
  future: fetchCharData(),
```

`CharData` (la clase) y `fetchCharData()` (la función que llama a la API)
no aparecen declaradas en ese archivo ni en los otros 3 que me pasaste
(`main.dart` de fl_chart, `personaje.dart`, `widget_test.dart`). Lo más
probable es que tu compañero las tenga en otro archivo que no subió
(algo como `models.dart`, `api.dart` o `char_data.dart` en su proyecto
original).

**Dejé un archivo `lib/graphic/char_data_placeholder.dart`** con una
implementación mínima de `CharData` y `fetchCharData()` (trae personajes
de la API y arma una lista de nombre + cantidad de episodios) SOLO para
que el proyecto compile mientras consigues el archivo real de tu
compañero. Bórralo y reemplázalo en cuanto tengas el original — si su
`CharData` tiene más campos, las gráficas de `graphic_screen.dart` que
los usen van a necesitar ese archivo real, no el placeholder.

## Estructura

```
lib/
├── main.dart                    <- pantalla selectora de las 4 librerías
├── syncfusion/
│   ├── syncfusion_home.dart     <- SyncfusionLoadingScreen / SyncfusionHomeScreen
│   ├── charts/basic_charts.dart     (31 gráficas)
│   ├── charts/advanced_charts.dart  (32 gráficas)
│   └── data/chart_data.dart         (consume la API)
├── fl_chart/
│   └── fl_chart_screen.dart     <- FlChartHomeScreen (grid de 31+33 tarjetas)
├── graphic/
│   ├── graphic_screen.dart      <- GraphicHomeScreen (31+32 en scroll)
│   └── char_data_placeholder.dart  <- TEMPORAL, ver advertencia arriba
└── echarts/
    ├── echarts_home.dart        <- EchartsHomePage
    ├── charts/{basic_charts.dart, advanced_charts.dart, chart_def.dart, palette.dart}
    ├── data/{api_service.dart, models.dart, rm_data.dart}
    └── pages/chart_page.dart
```

## Qué le cambié al código de cada quien

Nada de la lógica de las gráficas — solo lo necesario para que las 4
convivan en un solo proyecto sin que los nombres choquen:

- **syncfusion**: se movió a `lib/syncfusion/` y se renombraron
  `HomeScreen` → `SyncfusionHomeScreen` y `LoadingScreen` →
  `SyncfusionLoadingScreen`.
- **fl_chart**: se quitó su propio `void main()` y `RickAndMortyApp`
  (ya no hacen falta, solo hay un `main()` en todo el proyecto). Se
  renombró `HomeScreen` → `FlChartHomeScreen`.
- **graphic**: igual, se quitó `void main()` y `MyApp`, y se renombró
  `RickAndMortyCharts` → `GraphicHomeScreen`.
- **flutter_echarts**: se quitó `void main()` y `RickMortyEchartsApp`, y
  se renombró `HomePage` → `EchartsHomePage`. El resto de sus archivos
  (`charts/`, `data/`, `pages/`) se copiaron tal cual, porque ya estaban
  bien organizados en su propio proyecto.

Cada librería sigue bajando sus propios datos de la API por su cuenta
(no comparten una sola descarga) — es un poco de tráfico repetido, pero
así no tuve que tocar la lógica interna de nadie.

## Cómo correrlo

```bash
flutter pub get
flutter run
```

Revisa las versiones de `fl_chart` y `graphic` en `pubspec.yaml` — las
puse con valores razonables porque no tenía el `pubspec.yaml` original de
tus compañeros. Si `flutter pub get` se queja de la versión, ajústala a
la que ellos tenían.

## Archivos que no incluí

- `personaje.dart` (clase `Personaje` con id/nombre/estado/especie/imagen)
  — ningún archivo lo importa ni lo usa, parece un modelo que tu
  compañero dejó a medias. Si luego lo necesitas, se agrega en
  `lib/graphic/` o donde corresponda.
- `widget_test.dart` — es el test de ejemplo que trae Flutter por
  defecto (prueba un contador que no existe en esta app), no aplica
  aquí. Si quieren tests de verdad después, se arman aparte.
