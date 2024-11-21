import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'lagrange.dart';

class ResultadoVista extends StatelessWidget {
  final List<String> pasos;
  final List<double> xValues;
  final List<double> yValues;

  const ResultadoVista({
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
    final polinomioLatex = LagrangeInterpolation.mostrarPolinomio(coefficients);

    return Scaffold(
      appBar: AppBar(title: const Text("Pasos de Interpolación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar la fórmula estática de Lagrange antes del polinomio interpolado
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  const Text(
                    "Fórmula general de Lagrange:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Math.tex(
                    r"P(x) = \sum_{i=0}^{n-1} y_i L_i(x)",
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            // Mostrar polinomio interpolado en formato LaTeX
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  const Text(
                    "Polinomio interpolado:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Math.tex(
                      r"P(x) = " + polinomioLatex,
                      textStyle: const TextStyle(fontSize: 18)
                  ),
                ],
              ),
            ),

            // Accordion con los pasos de cada L₀(x)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: xValues.length,  // Número de L₀(x)
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: ExpansionTile(
                        title: Math.tex(
                          r'\text{Cálculo de } L_' + '${index}' + r'(x)',  // Formato matemático para el título
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                // Mostrar solo los pasos de L_i(x)
                                for (var step in LagrangeInterpolation.pasosPorLi[index]!)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Math.tex(
                                      step,
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
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
