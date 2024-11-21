import 'package:flutter/material.dart';
import 'entrada_datos_vista.dart';

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
