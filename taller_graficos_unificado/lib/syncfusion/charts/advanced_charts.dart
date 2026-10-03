// 32 GRÁFICAS AVANZADAS — syncfusion_flutter_charts
// Mismos 31 tipos que basic_charts.dart, pero con: leyenda, tooltip,
// trackball/zoom, data labels, selección y (donde aplica) una segunda
// serie para comparar. La #32 es una gráfica de combinación (bonus).

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../data/chart_data.dart';

Widget _scaffold(String title, Widget chart) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Padding(padding: const EdgeInsets.all(12), child: chart),
  );
}

TooltipBehavior _tooltip() => TooltipBehavior(enable: true);
TrackballBehavior _trackball() =>
    TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);
ZoomPanBehavior _zoom() => ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
    );

// 1. Línea + zoom/trackball + 2 series
class LineChartAdvanced extends StatelessWidget {
  const LineChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '1. Línea (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          zoomPanBehavior: _zoom(),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            LineSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
}

// 2. Spline
class SplineChartAdvanced extends StatelessWidget {
  const SplineChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '2. Spline (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            SplineSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            SplineSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 3. Columna
class ColumnChartAdvanced extends StatelessWidget {
  const ColumnChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '3. Columna (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          selectionType: SelectionType.point,
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              selectionBehavior: SelectionBehavior(enable: true),
            ),
            ColumnSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 4. Barra
class BarChartAdvanced extends StatelessWidget {
  const BarChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '4. Barra (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            BarSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            BarSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 5. Área
class AreaChartAdvanced extends StatelessWidget {
  const AreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '5. Área (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            AreaSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              opacity: 0.7,
            ),
          ],
        ),
      );
}

// 6. Burbuja
class BubbleChartAdvanced extends StatelessWidget {
  const BubbleChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '6. Burbuja (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            BubbleSeries<BubbleChartData, String>(
              dataSource: SampleData.bubbleMarket,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              sizeValueMapper: (d, _) => d.size,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              selectionBehavior: SelectionBehavior(enable: true),
            ),
          ],
        ),
      );
}

// 7. Caja y bigotes
class BoxAndWhiskerChartAdvanced extends StatelessWidget {
  const BoxAndWhiskerChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '7. Caja y bigotes (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            BoxAndWhiskerSeries<BoxData, String>(
              dataSource: SampleData.boxWhiskerData,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.values,
              showMean: true,
            ),
          ],
        ),
      );
}

// 8. Dispersión
class ScatterChartAdvanced extends StatelessWidget {
  const ScatterChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '8. Dispersión (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            ScatterSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              selectionBehavior: SelectionBehavior(enable: true),
            ),
          ],
        ),
      );
}

// 9. Línea escalonada
class StepLineChartAdvanced extends StatelessWidget {
  const StepLineChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '9. Línea escalonada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            StepLineSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
}

// 10. Línea rápida
class FastLineChartAdvanced extends StatelessWidget {
  const FastLineChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '10. Línea rápida (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          zoomPanBehavior: _zoom(),
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
class RangeColumnChartAdvanced extends StatelessWidget {
  const RangeColumnChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '11. Columna de rango (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            RangeColumnSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              selectionBehavior: SelectionBehavior(enable: true),
            ),
          ],
        ),
      );
}

// 12. Área de rango
class RangeAreaChartAdvanced extends StatelessWidget {
  const RangeAreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '12. Área de rango (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            RangeAreaSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
              opacity: 0.6,
            ),
          ],
        ),
      );
}

// 13. Vela (candle) con zoom
class CandleChartAdvanced extends StatelessWidget {
  const CandleChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '13. Vela (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          zoomPanBehavior: _zoom(),
          series: <CartesianSeries>[
            CandleSeries<FinancialData, String>(
              dataSource: SampleData.stockPrices,
              xValueMapper: (d, _) => d.x,
              openValueMapper: (d, _) => d.open,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              closeValueMapper: (d, _) => d.close,
              enableSolidCandles: true,
            ),
          ],
        ),
      );
}

// 14. Hilo
class HiloChartAdvanced extends StatelessWidget {
  const HiloChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '14. Hilo (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          zoomPanBehavior: _zoom(),
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
class OhlcChartAdvanced extends StatelessWidget {
  const OhlcChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '15. OHLC (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          zoomPanBehavior: _zoom(),
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

// 16. Histograma con curva normal
class HistogramChartAdvanced extends StatelessWidget {
  const HistogramChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '16. Histograma (avanzada)',
        SfCartesianChart(
          primaryXAxis: const NumericAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            HistogramSeries<double, double>(
              dataSource: SampleData.histogramValues,
              yValueMapper: (double d, _) => d,
              showNormalDistributionCurve: true,
              binInterval: 3,
            ),
          ],
        ),
      );
}

// 17. Área escalonada
class StepAreaChartAdvanced extends StatelessWidget {
  const StepAreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '17. Área escalonada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            StepAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              opacity: 0.7,
            ),
          ],
        ),
      );
}

// 18. Área spline
class SplineAreaChartAdvanced extends StatelessWidget {
  const SplineAreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '18. Área spline (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            SplineAreaSeries<ChartData, String>(
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              opacity: 0.7,
            ),
          ],
        ),
      );
}

// 19. Área de rango spline
class SplineRangeAreaChartAdvanced extends StatelessWidget {
  const SplineRangeAreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '19. Área de rango spline (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            SplineRangeAreaSeries<RangeData, String>(
              dataSource: SampleData.weeklyTemperatureRange,
              xValueMapper: (d, _) => d.x,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
              opacity: 0.6,
            ),
          ],
        ),
      );
}

// 20. Área apilada
class StackedAreaChartAdvanced extends StatelessWidget {
  const StackedAreaChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '20. Área apilada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedAreaSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedAreaSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 21. Barra apilada
class StackedBarChartAdvanced extends StatelessWidget {
  const StackedBarChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '21. Barra apilada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedBarSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            StackedBarSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 22. Columna apilada
class StackedColumnChartAdvanced extends StatelessWidget {
  const StackedColumnChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '22. Columna apilada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedColumnSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            StackedColumnSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 23. Línea apilada
class StackedLineChartAdvanced extends StatelessWidget {
  const StackedLineChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '23. Línea apilada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            StackedLineSeries<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedLineSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 24. Área apilada 100%
class StackedArea100ChartAdvanced extends StatelessWidget {
  const StackedArea100ChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '24. Área apilada 100% (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedArea100Series<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedArea100Series<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 25. Barra apilada 100%
class StackedBar100ChartAdvanced extends StatelessWidget {
  const StackedBar100ChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '25. Barra apilada 100% (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedBar100Series<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            StackedBar100Series<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 26. Columna apilada 100%
class StackedColumn100ChartAdvanced extends StatelessWidget {
  const StackedColumn100ChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '26. Columna apilada 100% (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            StackedColumn100Series<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            StackedColumn100Series<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 27. Línea apilada 100%
class StackedLine100ChartAdvanced extends StatelessWidget {
  const StackedLine100ChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '27. Línea apilada 100% (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            StackedLine100Series<ChartData, String>(
              name: 'Ventas',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            StackedLine100Series<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
            ),
          ],
        ),
      );
}

// 28. Cascada (Waterfall) con conectores y etiquetas
class WaterfallChartAdvanced extends StatelessWidget {
  const WaterfallChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '28. Cascada (avanzada)',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          tooltipBehavior: _tooltip(),
          series: <CartesianSeries>[
            WaterfallSeries<WaterfallChartData, String>(
              dataSource: SampleData.waterfallBudget,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              intermediateSumPredicate: (d, _) => d.isIntermediateSum,
              totalSumPredicate: (d, _) => d.isTotal,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              connectorLineSettings: const WaterfallConnectorLineSettings(
                dashArray: <double>[4, 3],
              ),
            ),
          ],
        ),
      );
}

// 29. Pastel (Pie) con leyenda, etiquetas y selección
class PieChartAdvanced extends StatelessWidget {
  const PieChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '29. Pastel (avanzada)',
        SfCircularChart(
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CircularSeries>[
            PieSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              explode: true,
              explodeIndex: 0,
              selectionBehavior: SelectionBehavior(enable: true),
            ),
          ],
        ),
      );
}

// 30. Donut con radio interior animado y leyenda
class DoughnutChartAdvanced extends StatelessWidget {
  const DoughnutChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '30. Donut (avanzada)',
        SfCircularChart(
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CircularSeries>[
            DoughnutSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              innerRadius: '60%',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              selectionBehavior: SelectionBehavior(enable: true),
            ),
          ],
        ),
      );
}

// 31. Barra radial con etiquetas y leyenda
class RadialBarChartAdvanced extends StatelessWidget {
  const RadialBarChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '31. Barra radial (avanzada)',
        SfCircularChart(
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          series: <CircularSeries>[
            RadialBarSeries<CircularData, String>(
              dataSource: SampleData.marketShare,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
        ),
      );
}

// 32. BONUS — Gráfica de combinación (columna + línea + área en un mismo chart)
class CombinationChartAdvanced extends StatelessWidget {
  const CombinationChartAdvanced({super.key});
  @override
  Widget build(BuildContext context) => _scaffold(
        '32. Combinación (Columna + Línea) — bonus',
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: true),
          tooltipBehavior: _tooltip(),
          trackballBehavior: _trackball(),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              name: 'Ventas reales',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
            ),
            LineSeries<ChartData, String>(
              name: 'Meta',
              dataSource: SampleData.monthlySales,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y2,
              markerSettings: const MarkerSettings(isVisible: true),
              width: 3,
            ),
          ],
        ),
      );
}

/// Lista usada por main.dart para construir el menú de navegación.
final List<Map<String, dynamic>> advancedChartsList = [
  {'title': '1. Línea', 'widget': const LineChartAdvanced()},
  {'title': '2. Spline', 'widget': const SplineChartAdvanced()},
  {'title': '3. Columna', 'widget': const ColumnChartAdvanced()},
  {'title': '4. Barra', 'widget': const BarChartAdvanced()},
  {'title': '5. Área', 'widget': const AreaChartAdvanced()},
  {'title': '6. Burbuja', 'widget': const BubbleChartAdvanced()},
  {'title': '7. Caja y bigotes', 'widget': const BoxAndWhiskerChartAdvanced()},
  {'title': '8. Dispersión', 'widget': const ScatterChartAdvanced()},
  {'title': '9. Línea escalonada', 'widget': const StepLineChartAdvanced()},
  {'title': '10. Línea rápida', 'widget': const FastLineChartAdvanced()},
  {'title': '11. Columna de rango', 'widget': const RangeColumnChartAdvanced()},
  {'title': '12. Área de rango', 'widget': const RangeAreaChartAdvanced()},
  {'title': '13. Vela (Candle)', 'widget': const CandleChartAdvanced()},
  {'title': '14. Hilo', 'widget': const HiloChartAdvanced()},
  {'title': '15. OHLC', 'widget': const OhlcChartAdvanced()},
  {'title': '16. Histograma', 'widget': const HistogramChartAdvanced()},
  {'title': '17. Área escalonada', 'widget': const StepAreaChartAdvanced()},
  {'title': '18. Área spline', 'widget': const SplineAreaChartAdvanced()},
  {'title': '19. Área de rango spline', 'widget': const SplineRangeAreaChartAdvanced()},
  {'title': '20. Área apilada', 'widget': const StackedAreaChartAdvanced()},
  {'title': '21. Barra apilada', 'widget': const StackedBarChartAdvanced()},
  {'title': '22. Columna apilada', 'widget': const StackedColumnChartAdvanced()},
  {'title': '23. Línea apilada', 'widget': const StackedLineChartAdvanced()},
  {'title': '24. Área apilada 100%', 'widget': const StackedArea100ChartAdvanced()},
  {'title': '25. Barra apilada 100%', 'widget': const StackedBar100ChartAdvanced()},
  {'title': '26. Columna apilada 100%', 'widget': const StackedColumn100ChartAdvanced()},
  {'title': '27. Línea apilada 100%', 'widget': const StackedLine100ChartAdvanced()},
  {'title': '28. Cascada (Waterfall)', 'widget': const WaterfallChartAdvanced()},
  {'title': '29. Pastel (Pie)', 'widget': const PieChartAdvanced()},
  {'title': '30. Donut', 'widget': const DoughnutChartAdvanced()},
  {'title': '31. Barra radial', 'widget': const RadialBarChartAdvanced()},
  {'title': '32. Combinación (bonus)', 'widget': const CombinationChartAdvanced()},
];
