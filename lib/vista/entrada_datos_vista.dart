import 'package:flutter/material.dart';
import 'package:untitled2/controlador/interpolacion_controlador.dart';
import 'package:untitled2/vista/resultado_vista.dart';

class EntradaInterpolacionVista extends StatefulWidget {
  const EntradaInterpolacionVista({super.key});

  @override
  State<EntradaInterpolacionVista> createState() => _EntradaInterpolacionVistaState();
}

class _EntradaInterpolacionVistaState extends State<EntradaInterpolacionVista> {
  final controller = InterpolacionControlador();
  // Inicializando con dos puntos vacíos
  final List<Map<String, TextEditingController>> points = [
    {"x": TextEditingController(), "y": TextEditingController()},
    {"x": TextEditingController(), "y": TextEditingController()},
  ];

  void addPoint() {
    setState(() {
      points.add({"x": TextEditingController(), "y": TextEditingController()});
    });
  }

  void resolveInterpolation() {
    controller.xValues.clear();
    controller.yValues.clear();

    for (var point in points) {
      final x = double.tryParse(point["x"]!.text);
      final y = double.tryParse(point["y"]!.text);

      if (x != null && y != null) {
        controller.agregarPunto(x, y);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, ingresa valores válidos.")),
        );
        return;
      }
    }

    if (controller.validarPuntos()) {
      controller.calcularInterpolacion();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoVista(
            controller: controller,
            xValues: controller.xValues,
            yValues: controller.yValues,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa puntos válidos.")),
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
                          decoration: InputDecoration(labelText: "x${index + 1}"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: points[index]["y"],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "y${index + 1}"),
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
            // Botón para agregar punto con outline y ícono de plus
            OutlinedButton.icon(
              onPressed: addPoint,
              icon: const Icon(Icons.add), // Ícono de "+" para agregar punto
              label: const Text("Agregar Punto"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: const BorderSide(color: Colors.indigo), // Color de borde índigo
              ),
            ),
            const SizedBox(height: 16),
            // Botón para resolver con ícono de cálculo
            ElevatedButton.icon(
              onPressed: resolveInterpolation,
              icon: const Icon(Icons.calculate), // Ícono de cálculo
              label: const Text("Resolver"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
