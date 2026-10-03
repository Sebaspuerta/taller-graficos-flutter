// Definición de una gráfica (Dart puro).

import '../data/rm_data.dart';

class ChartDef {
  final String code;
  final String title;
  final String explanation;
  final Map<String, dynamic> Function(RMData) build;

  const ChartDef({
    required this.code,
    required this.title,
    required this.explanation,
    required this.build,
  });
}

/// Título común: "código título" con fontSize 14.
Map<String, dynamic> chartTitle(String code, String title) => {
      'text': '$code $title',
      'left': 'center',
      'textStyle': {'fontSize': 14},
    };

/// Grid común con containLabel para que no se corten las etiquetas.
Map<String, dynamic> chartGrid({int top = 50, int bottom = 20, int left = 20, int right = 30}) => {
      'top': top,
      'bottom': bottom,
      'left': left,
      'right': right,
      'containLabel': true,
    };
