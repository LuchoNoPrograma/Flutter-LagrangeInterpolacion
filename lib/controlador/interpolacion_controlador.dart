import '../modelo/lagrange_modelo.dart';

class InterpolacionControlador {
  List<double> xValues = [];
  List<double> yValues = [];
  late List<double> coefficients;
  String formulaFinal = "";

  void agregarPunto(double x, double y) {
    xValues.add(x);
    yValues.add(y);
  }

  bool validarPuntos() {
    return xValues.isNotEmpty && yValues.isNotEmpty;
  }

  void calcularInterpolacion() {
    coefficients = LagrangeModelo.calcularPolinomioConPasos(xValues, yValues);
    formulaFinal = LagrangeModelo.formulaFinal;
  }


  String mostrarFormulaFinal() {
    return formulaFinal;  // Devolver la fórmula final para mostrar
  }

  List<String> obtenerPasosPorLi(int index) {
    return LagrangeModelo.pasosPorLi[index] ?? [];
  }

  double evaluar(double x) {
    return LagrangeModelo.evaluarPolinomio(coefficients, x);
  }

  List<double> getCoefs() => coefficients;
}