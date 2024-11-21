import 'package:flutter/material.dart';
import 'lagrange.dart';
import 'steps_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interpolación de Lagrange',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InterpolationInputScreen(),
    );
  }
}

class InterpolationInputScreen extends StatefulWidget {
  const InterpolationInputScreen({Key? key}) : super(key: key);

  @override
  State<InterpolationInputScreen> createState() =>
      _InterpolationInputScreenState();
}

class _InterpolationInputScreenState extends State<InterpolationInputScreen> {
  final List<Map<String, TextEditingController>> points = [];

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, ingresa valores válidos.")),
        );
        return;
      }
    }

    if (xValues.isNotEmpty && yValues.isNotEmpty) {
      LagrangeInterpolation.calcularPolinomioConPasos(xValues, yValues);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InterpolationStepsScreen(
                pasos: LagrangeInterpolation.pasos,
                xValues: xValues,
                yValues: yValues,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa al menos un punto.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interpolación de Lagrange")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
