import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import '../charts/chart_def.dart';
import '../data/rm_data.dart';

/// Una gráfica por pantalla: el WebView de ECharts va en un SizedBox de altura fija.
class ChartPage extends StatelessWidget {
  final ChartDef def;
  final RMData data;

  const ChartPage({super.key, required this.def, required this.data});

  @override
  Widget build(BuildContext context) {
    String? option;
    Object? error;
    try {
      option = jsonEncode(def.build(data));
    } catch (e) {
      error = e;
    }

    return Scaffold(
      appBar: AppBar(title: Text('${def.code} · ${def.title}')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 420,
            child: option != null
                ? Echarts(option: option, captureAllGestures: true)
                : Center(child: Text('Error al construir la gráfica:\n$error', textAlign: TextAlign.center)),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(def.explanation, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
