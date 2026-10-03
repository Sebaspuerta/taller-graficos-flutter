import 'package:flutter/material.dart';
import 'charts/basic_charts.dart';
import 'charts/advanced_charts.dart';
import 'data/chart_data.dart';

/// Punto de entrada de la sección Syncfusion. Descarga los datos de Rick
/// and Morty (SampleData.load()) y luego muestra las 63 gráficas.
class SyncfusionLoadingScreen extends StatefulWidget {
  const SyncfusionLoadingScreen({super.key});

  @override
  State<SyncfusionLoadingScreen> createState() => _SyncfusionLoadingScreenState();
}

class _SyncfusionLoadingScreenState extends State<SyncfusionLoadingScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = SampleData.load();
  }

  void _retry() {
    setState(() {
      _loadFuture = SampleData.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Descargando personajes, episodios y\nlocaciones de Rick and Morty...',
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48),
                    const SizedBox(height: 12),
                    Text('No se pudo cargar la API:\n${snapshot.error}',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _retry, child: const Text('Reintentar')),
                  ],
                ),
              ),
            ),
          );
        }

        return const SyncfusionHomeScreen();
      },
    );
  }
}

class SyncfusionHomeScreen extends StatelessWidget {
  const SyncfusionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion · syncfusion_flutter_charts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Básicas (${basicChartsList.length})'),
              Tab(text: 'Avanzadas (${advancedChartsList.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ChartMenu(items: basicChartsList),
            _ChartMenu(items: advancedChartsList),
          ],
        ),
      ),
    );
  }
}

class _ChartMenu extends StatelessWidget {
  const _ChartMenu({required this.items});
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item['title'] as String),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item['widget'] as Widget),
          ),
        );
      },
    );
  }
}
