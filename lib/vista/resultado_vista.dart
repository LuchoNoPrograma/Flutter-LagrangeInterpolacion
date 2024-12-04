import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled2/controlador/interpolacion_controlador.dart';
import 'package:untitled2/modelo/lagrange_modelo.dart';

class ResultadoVista extends StatefulWidget {
  final InterpolacionControlador controller;
  final List<double> xValues;
  final List<double> yValues;

  const ResultadoVista({
    super.key,
    required this.controller,
    required this.xValues,
    required this.yValues,
  });

  @override
  _ResultadoVistaState createState() => _ResultadoVistaState();
}

class _ResultadoVistaState extends State<ResultadoVista> {
  final TextEditingController _xController = TextEditingController();
  _ChartData? _specificPoint;
  String _fXResult = ''; // Variable para almacenar el resultado de f(x)

  List<_ChartData> generateGraphPoints() {
    const double step = 0.1;
    final List<_ChartData> chartData = [];
    final coefficients = widget.controller.getCoefs();

    for (double x = -10; x <= 10; x += step) {
      final y = widget.controller.evaluar(x);
      chartData.add(_ChartData(x, y));
    }
    return chartData;
  }

  void _generateSpecificPoint() {
    final x = double.tryParse(_xController.text);
    if (x != null) {
      final y = widget.controller.evaluar(x);
      setState(() {
        _specificPoint = _ChartData(x, y);
        _fXResult = 'f($x) = $y';  // Mostrar el resultado de f(x)
      });
    }
  }

  void _openHelpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fórmulas de Interpolación de Lagrange",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Fórmula general de Lagrange:",
                  style: TextStyle(fontSize: 16),
                ),
                Math.tex(
                  r"P(x) = \sum_{i=0}^{n-1} y_i L_i(x)",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Fórmula para calcular L_i(x):",
                  style: TextStyle(fontSize: 16),
                ),
                Math.tex(
                  r"L_i(x) = \prod_{j=0, j\neq i}^{n-1} \frac{x - x_j}{x_i - x_j}",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("Cerrar"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coefficients = widget.controller.getCoefs();
    final polinomioLatex = LagrangeModelo.mostrarPolinomio(coefficients);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pasos de Interpolación"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _openHelpModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Accordion con los pasos de cada L₀(x)
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                shrinkWrap: true,
                itemCount: widget.xValues.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: ExpansionTile(
                        title: Math.tex(
                          r'\text{Cálculo de } L_' + '${index}' + r'(x)',
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                for (var step in widget.controller.obtenerPasosPorLi(index))
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

              // Card con la fórmula final
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Math.tex(r"\text{Reemplazo de } L_{i}*y_{i}:"),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 8,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Math.tex(
                                widget.controller.mostrarFormulaFinal(),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Polinomio Interpolado
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Math.tex(r"\text{Polinomio Interpolado:}"),
                      const SizedBox(height: 10),
                      Math.tex(
                        r"P(x) = " + polinomioLatex,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // Gráfica de la interpolación
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gráfica del Polinomio',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Puedes hacer zoom acercando o alejando con los dedos.',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      SfCartesianChart(
                        primaryXAxis: NumericAxis(title: AxisTitle(text: 'X')),
                        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Y')),
                        zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enablePanning: true),
                        series: <ChartSeries>[
                          LineSeries<_ChartData, double>(
                            dataSource: generateGraphPoints(),
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            color: Colors.indigo,
                            width: 2,
                          ),
                          if (_specificPoint != null)
                            ScatterSeries<_ChartData, double>(
                              dataSource: [_specificPoint!],
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                shape: DataMarkerType.circle,
                                color: Colors.white,
                                borderColor: Colors.indigo,
                                borderWidth: 3,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _xController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Interpolar para x',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _generateSpecificPoint,
                        icon: const Icon(Icons.add_location), // Ícono para representar la acción
                        label: const Text('Generar punto'),  // El texto del botón
                      ),
                      const SizedBox(height: 16),
                      if (_specificPoint != null)
                        Math.tex(
                          r'\text{Resultado }'+ _fXResult,
                          textStyle: const TextStyle(fontSize: 16),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
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
