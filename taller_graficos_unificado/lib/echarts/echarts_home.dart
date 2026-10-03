import 'package:flutter/material.dart';

import 'charts/advanced_charts.dart';
import 'charts/basic_charts.dart';
import 'charts/chart_def.dart';
import 'data/api_service.dart';
import 'data/rm_data.dart';
import 'pages/chart_page.dart';

/// Punto de entrada de la sección flutter_echarts. Descarga los datos de
/// Rick and Morty (ApiService().loadAll()) y luego muestra las 63 gráficas.
class EchartsHomePage extends StatefulWidget {
  const EchartsHomePage({super.key});

  @override
  State<EchartsHomePage> createState() => _EchartsHomePageState();
}

class _EchartsHomePageState extends State<EchartsHomePage> {
  final ApiService _api = ApiService();
  late Future<RMData> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.loadAll(); // carga única compartida por todas las gráficas
  }

  void _retry() => setState(() => _future = _api.loadAll());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty · flutter_echarts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Básicas (${basicCharts.length})'),
              Tab(text: 'Avanzadas (${advancedCharts.length})'),
            ],
          ),
        ),
        body: FutureBuilder<RMData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando personajes y episodios…'),
                  ],
                ),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return _ErrorView(message: '${snapshot.error}', onRetry: _retry);
            }
            final data = snapshot.data!;
            return TabBarView(
              children: [
                _ChartList(charts: basicCharts, data: data),
                _ChartList(charts: advancedCharts, data: data),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            const Text('No se pudieron cargar los datos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartList extends StatelessWidget {
  final List<ChartDef> charts;
  final RMData data;

  const _ChartList({required this.charts, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: charts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final def = charts[i];
        return ListTile(
          leading: CircleAvatar(child: Text(def.code, style: const TextStyle(fontSize: 12))),
          title: Text(def.title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ChartPage(def: def, data: data)),
          ),
        );
      },
    );
  }
}
