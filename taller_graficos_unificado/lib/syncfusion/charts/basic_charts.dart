// 31 GRÁFICAS BÁSICAS — syncfusion_flutter_charts
// Cada widget es un Scaffold independiente con UNA sola serie, sin
// interactividad extra (eso va en advanced_charts.dart).
//
// Patrón: cada gráfica se arma con _ChartScaffold(title, chart) para no
// repetir el AppBar en las 31 clases.

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../data/chart_data.dart';

Widget _scaffold(String title, Widget chart) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Padding(padding: const EdgeInsets.all(12), child: chart),
  );
}

// 1. Línea
class LineChartBasic extends StatelessWidget {
  const LineChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '1. Línea',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 2. Spline
class SplineChartBasic extends StatelessWidget {
  const SplineChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '2. Spline',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            SplineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 3. Columna
class ColumnChartBasic extends StatelessWidget {
  const ColumnChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '3. Columna',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 4. Barra
class BarChartBasic extends StatelessWidget {
  const BarChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '4. Barra',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            BarSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 5. Área
class AreaChartBasic extends StatelessWidget {
  const AreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '5. Área',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            AreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 6. Burbuja
class BubbleChartBasic extends StatelessWidget {
  const BubbleChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '6. Burbuja',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            BubbleSeries<BubbleChartData, String>(
              dataSource: SampleData.bubbleMarket,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              sizeValueMapper: (d, _) => d.size,
            ),
          ],
        ),
      );
}

// 7. Caja y bigotes
class BoxAndWhiskerChartBasic extends StatelessWidget {
  const BoxAndWhiskerChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '7. Caja y bigotes',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            BoxAndWhiskerSeries<BoxData, String>(
              dataSource: SampleData.boxWhiskerData,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.values,
            ),
          ],
        ),
      );
}

// 8. Dispersión
class ScatterChartBasic extends StatelessWidget {
  const ScatterChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '8. Dispersión',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            ScatterSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 9. Línea escalonada
class StepLineChartBasic extends StatelessWidget {
  const StepLineChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '9. Línea escalonada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StepLineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 10. Línea rápida
class FastLineChartBasic extends StatelessWidget {
  const FastLineChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '10. Línea rápida',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            FastLineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 11. Columna de rango
class RangeColumnChartBasic extends StatelessWidget {
  const RangeColumnChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '11. Columna de rango',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            RangeColumnSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
            ),
          ],
        ),
      );
}

// 12. Área de rango
class RangeAreaChartBasic extends StatelessWidget {
  const RangeAreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '12. Área de rango',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            RangeAreaSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
            ),
          ],
        ),
      );
}

// 13. Vela (candle)
class CandleChartBasic extends StatelessWidget {
  const CandleChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '13. Vela (Candle)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            CandleSeries<FinancialData, String>(
              dataSource: SampleData.stockPrices,
              xValueMapper: (d, _) => d.x,
              openValueMapper: (d, _) => d.open,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              closeValueMapper: (d, _) => d.close,
            ),
          ],
        ),
      );
}

// 14. Hilo
class HiloChartBasic extends StatelessWidget {
  const HiloChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '14. Hilo',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            HiloSeries<FinancialData, String>(
              dataSource: SampleData.stockPrices,
              xValueMapper: (d, _) => d.x,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
            ),
          ],
        ),
      );
}

// 15. OHLC
class OhlcChartBasic extends StatelessWidget {
  const OhlcChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '15. OHLC',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            HiloOpenCloseSeries<FinancialData, String>(
              dataSource: SampleData.stockPrices,
              xValueMapper: (d, _) => d.x,
              openValueMapper: (d, _) => d.open,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              closeValueMapper: (d, _) => d.close,
            ),
          ],
        ),
      );
}

// 16. Histograma
class HistogramChartBasic extends StatelessWidget {
  const HistogramChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '16. Histograma',
        SfCartesianChart(
          primaryXAxis: const NumericAxis(),
          series: <CartesianSeries>[
            HistogramSeries<double, double>(
              dataSource: SampleData.histogramValues,
              yValueMapper: (double d, _) => d,
            ),
          ],
        ),
      );
}

// 17. Área escalonada
class StepAreaChartBasic extends StatelessWidget {
  const StepAreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '17. Área escalonada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StepAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 18. Área spline
class SplineAreaChartBasic extends StatelessWidget {
  const SplineAreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '18. Área spline',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            SplineAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
          ],
        ),
      );
}

// 19. Área de rango spline
class SplineRangeAreaChartBasic extends StatelessWidget {
  const SplineRangeAreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '19. Área de rango spline',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            SplineRangeAreaSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
            ),
          ],
        ),
      );
}

// 20. Área apilada
class StackedAreaChartBasic extends StatelessWidget {
  const StackedAreaChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '20. Área apilada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 21. Barra apilada
class StackedBarChartBasic extends StatelessWidget {
  const StackedBarChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '21. Barra apilada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedBarSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedBarSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 22. Columna apilada
class StackedColumnChartBasic extends StatelessWidget {
  const StackedColumnChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '22. Columna apilada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedColumnSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedColumnSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 23. Línea apilada
class StackedLineChartBasic extends StatelessWidget {
  const StackedLineChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '23. Línea apilada',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedLineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedLineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 24. Área apilada 100%
class StackedArea100ChartBasic extends StatelessWidget {
  const StackedArea100ChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '24. Área apilada 100%',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedArea100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedArea100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 25. Barra apilada 100%
class StackedBar100ChartBasic extends StatelessWidget {
  const StackedBar100ChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '25. Barra apilada 100%',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedBar100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedBar100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 26. Columna apilada 100%
class StackedColumn100ChartBasic extends StatelessWidget {
  const StackedColumn100ChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '26. Columna apilada 100%',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedColumn100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedColumn100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 27. Línea apilada 100%
class StackedLine100ChartBasic extends StatelessWidget {
  const StackedLine100ChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '27. Línea apilada 100%',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            StackedLine100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedLine100Series<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 28. Cascada (Waterfall)
class WaterfallChartBasic extends StatelessWidget {
  const WaterfallChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '28. Cascada (Waterfall)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries>[
            WaterfallSeries<WaterfallChartData, String>(
              dataSource: SampleData.waterfallBudget,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              intermediateSumPredicate: (d, _) => d.isIntermediateSum,
              totalSumPredicate: (d, _) => d.isTotal,
            ),
          ],
        ),
      );
}

// 29. Pastel (Pie)
class PieChartBasic extends StatelessWidget {
  const PieChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '29. Pastel (Pie)',
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
            ),
          ],
        ),
      );
}

// 30. Donut
class DoughnutChartBasic extends StatelessWidget {
  const DoughnutChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '30. Donut',
        SfCircularChart(
          series: <CircularSeries>[
            DoughnutSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
            ),
          ],
        ),
      );
}

// 31. Barra radial
class RadialBarChartBasic extends StatelessWidget {
  const RadialBarChartBasic({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '31. Barra radial',
        SfCircularChart(
          series: <CircularSeries>[
            RadialBarSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
            ),
          ],
        ),
      );
}

/// Lista usada por main.dart para construir el menú de navegación.
final List<Map<String, dynamic>> basicChartsList = [
  {'title': '1. Línea', 'widget': const LineChartBasic()},
  {'title': '2. Spline', 'widget': const SplineChartBasic()},
  {'title': '3. Columna', 'widget': const ColumnChartBasic()},
  {'title': '4. Barra', 'widget': const BarChartBasic()},
  {'title': '5. Área', 'widget': const AreaChartBasic()},
  {'title': '6. Burbuja', 'widget': const BubbleChartBasic()},
  {'title': '7. Caja y bigotes', 'widget': const BoxAndWhiskerChartBasic()},
  {'title': '8. Dispersión', 'widget': const ScatterChartBasic()},
  {'title': '9. Línea escalonada', 'widget': const StepLineChartBasic()},
  {'title': '10. Línea rápida', 'widget': const FastLineChartBasic()},
  {'title': '11. Columna de rango', 'widget': const RangeColumnChartBasic()},
  {'title': '12. Área de rango', 'widget': const RangeAreaChartBasic()},
  {'title': '13. Vela (Candle)', 'widget': const CandleChartBasic()},
  {'title': '14. Hilo', 'widget': const HiloChartBasic()},
  {'title': '15. OHLC', 'widget': const OhlcChartBasic()},
  {'title': '16. Histograma', 'widget': const HistogramChartBasic()},
  {'title': '17. Área escalonada', 'widget': const StepAreaChartBasic()},
  {'title': '18. Área spline', 'widget': const SplineAreaChartBasic()},
  {'title': '19. Área de rango spline', 'widget': const SplineRangeAreaChartBasic()},
  {'title': '20. Área apilada', 'widget': const StackedAreaChartBasic()},
  {'title': '21. Barra apilada', 'widget': const StackedBarChartBasic()},
  {'title': '22. Columna apilada', 'widget': const StackedColumnChartBasic()},
  {'title': '23. Línea apilada', 'widget': const StackedLineChartBasic()},
  {'title': '24. Área apilada 100%', 'widget': const StackedArea100ChartBasic()},
  {'title': '25. Barra apilada 100%', 'widget': const StackedBar100ChartBasic()},
  {'title': '26. Columna apilada 100%', 'widget': const StackedColumn100ChartBasic()},
  {'title': '27. Línea apilada 100%', 'widget': const StackedLine100ChartBasic()},
  {'title': '28. Cascada (Waterfall)', 'widget': const WaterfallChartBasic()},
  {'title': '29. Pastel (Pie)', 'widget': const PieChartBasic()},
  {'title': '30. Donut', 'widget': const DoughnutChartBasic()},
  {'title': '31. Barra radial', 'widget': const RadialBarChartBasic()},
];
