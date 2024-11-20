import 'package:flutter/material.dart';
import 'lagrange.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Importar Syncfusion Charts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interpolación Lagrange',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InterpolationInputScreen(),
    );
  }
}

class InterpolationInputScreen extends StatefulWidget {
  const InterpolationInputScreen({Key? key}) : super(key: key);

  @override
  _InterpolationInputScreenState createState() =>
      _InterpolationInputScreenState();
}

class _InterpolationInputScreenState extends State<InterpolationInputScreen> {
  final List<Map<String, TextEditingController>> points = [];
  List<double> coefficients = [];
  String result = "";

  @override
  void initState() {
    super.initState();
    addPoint(); // Inicia con un punto por defecto
  }

  void addPoint() {
    setState(() {
      points.add({
        "x": TextEditingController(),
        "y": TextEditingController(),
      });
    });
  }

  void resolveInterpolation() {
    final List<double> xValues = [];
    final List<double> yValues = [];

    for (var point in points) {
      final x = double.tryParse(point["x"]!.text);
      final y = double.tryParse(point["y"]!.text);
      if (x != null && y != null) {
        xValues.add(x);
        yValues.add(y);
      } else {
        setState(() {
          result = "Por favor, ingresa valores válidos.";
        });
        return;
      }
    }

    if (xValues.isNotEmpty && yValues.isNotEmpty) {
      // Llamar a la lógica de interpolación
      coefficients = LagrangeInterpolation.calcularPolinomio(xValues, yValues);
      final polinomio =
      LagrangeInterpolation.mostrarPolinomio(coefficients);

      // Actualizar el estado para mostrar el resultado
      setState(() {
        result = "Polinomio interpolado:\n$polinomio";
      });
    } else {
      setState(() {
        result = "Por favor, ingresa al menos un punto.";
      });
    }
  }

  List<_ChartData> generateGraphPoints() {
    if (coefficients.isEmpty) return [];

    const double step = 0.1; // Incremento en el eje X
    const int numPoints = 200; // Número de puntos a graficar
    final List<_ChartData> chartData = [];

    for (double x = -10; x <= 10; x += step) {
      final y = LagrangeInterpolation.evaluarPolinomio(coefficients, x);
      chartData.add(_ChartData(x, y));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interpolación - Lagrange")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: points.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: points[index]["x"],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "x${index + 1}",
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: points[index]["y"],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "y${index + 1}",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            points.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addPoint,
              child: const Text("Agregar Punto"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: resolveInterpolation,
              child: const Text("Resolver"),
            ),
            const SizedBox(height: 16),
            if (result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            if (coefficients.isNotEmpty)
              Expanded(
                flex: 2,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    title: AxisTitle(text: 'X'),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Y'),
                  ),
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