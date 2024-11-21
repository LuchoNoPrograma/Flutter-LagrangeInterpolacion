import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'lagrange.dart';

class InterpolationStepsScreen extends StatelessWidget {
  final List<String> pasos;
  final List<double> xValues;
  final List<double> yValues;

  const InterpolationStepsScreen({
    super.key,
    required this.pasos,
    required this.xValues,
    required this.yValues,
  });

  List<_ChartData> generateGraphPoints() {
    const double step = 0.1;
    final List<_ChartData> chartData = [];
    final coefficients = LagrangeInterpolation.calcularPolinomioConPasos(xValues, yValues);

    for (double x = -10; x <= 10; x += step) {
      final y = LagrangeInterpolation.evaluarPolinomio(coefficients, x);
      chartData.add(_ChartData(x, y));
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final coefficients = LagrangeInterpolation.calcularPolinomioConPasos(xValues, yValues);
    final polinomio = LagrangeInterpolation.mostrarPolinomio(coefficients);

    return Scaffold(
      appBar: AppBar(title: const Text("Pasos de Interpolación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar polinomio interpolado
            Text(
              "Polinomio interpolado:\n$polinomio",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mostrar los pasos en la lista
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: pasos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Math.tex(
                          pasos[index],
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gráfica de la interpolación
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(title: AxisTitle(text: 'X')),
                primaryYAxis: NumericAxis(title: AxisTitle(text: 'Y')),
                series: <ChartSeries>[
                  LineSeries<_ChartData, double>(
                    dataSource: generateGraphPoints(),
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    color: Colors.blue,
                    width: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final double x;
  final double y;
  _ChartData(this.x, this.y);
}
