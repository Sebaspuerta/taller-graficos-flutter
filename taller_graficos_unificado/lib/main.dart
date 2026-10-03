import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'syncfusion/syncfusion_home.dart';
import 'fl_chart/fl_chart_screen.dart';
import 'graphic/graphic_screen.dart';
import 'echarts/echarts_home.dart';

void main() => runApp(const TallerGraficosApp());

class TallerGraficosApp extends StatelessWidget {
  const TallerGraficosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Librerías de Gráficos en Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LibraryPickerScreen(),
    );
  }
}

class _LibraryOption {
  const _LibraryOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.builder,
    this.soloMovil = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  /// true para librerías que solo corren en Android/iOS (flutter_echarts
  /// depende de un WebView).
  final bool soloMovil;
}

bool get _esEscritorioOWeb =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.macOS;

class LibraryPickerScreen extends StatelessWidget {
  const LibraryPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = <_LibraryOption>[
      _LibraryOption(
        title: 'syncfusion_flutter_charts',
        subtitle: '31 básicas + 32 avanzadas',
        icon: Icons.bar_chart,
        color: Colors.indigo,
        builder: (_) => const SyncfusionLoadingScreen(),
      ),
      _LibraryOption(
        title: 'fl_chart',
        subtitle: '31 básicas + 32 avanzadas',
        icon: Icons.stacked_line_chart,
        color: const Color(0xFF97CE4C),
        builder: (_) => const FlChartHomeScreen(),
      ),
      _LibraryOption(
        title: 'graphic',
        subtitle: '31 básicas + 32 avanzadas',
        icon: Icons.donut_large,
        color: Colors.teal,
        builder: (_) => const GraphicHomeScreen(),
      ),
      _LibraryOption(
        title: 'flutter_echarts',
        subtitle: '31 básicas + 32 avanzadas',
        icon: Icons.show_chart,
        color: const Color(0xFF00B5CC),
        builder: (_) => const EchartsHomePage(),
        soloMovil: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Taller Librerías de Gráficos en Flutter')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: opciones.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final o = opciones[index];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(backgroundColor: o.color, child: Icon(o.icon, color: Colors.white)),
              title: Text(o.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(o.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (o.soloMovil && _esEscritorioOWeb) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('flutter_echarts solo funciona en Android/iOS')),
                  );
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: o.builder));
              },
            ),
          );
        },
      ),
    );
  }
}
