import 'dart:math'; // Import necesario para usar pow

class LagrangeInterpolation {
  static List<String> pasos = [];

  // Método para calcular el polinomio de interpolación con pasos
  static List<double> calcularPolinomioConPasos(List<double> x, List<double> y) {
    pasos.clear();
    int numPuntos = x.length;

    pasos.add(r"P(x) = \sum_{i=0}^n L_i(x) \cdot y_i");
    pasos.add(r"L_i(x) = \frac{\prod_{j \neq i} (x - x_j)}{\prod_{j \neq i} (x_i - x_j)}");

    List<double> resultado = List.filled(numPuntos, 0.0); // Inicializa el resultado con ceros

    for (int i = 0; i < numPuntos; i++) {
      pasos.add(r"\text{Cálculo de } L_{" + i.toString() + r"}(x):");

      // Construir numerador y denominador simbólicos
      List<String> numeradorSimbolico = [];
      List<String> denominadorSimbolico = [];
      double denominadorOperado = 1.0;

      for (int j = 0; j < numPuntos; j++) {
        if (j != i) {
          // Numerador simbólico
          numeradorSimbolico.add("(x - ${x[j].toStringAsFixed(2)})");

          // Denominador simbólico sin operar
          denominadorSimbolico.add("(${x[i].toStringAsFixed(2)} - ${x[j].toStringAsFixed(2)})");

          // Operación acumulativa en el denominador
          denominadorOperado *= (x[i] - x[j]);
        }
      }

      // Agregar pasos simbólicos antes de operar
      pasos.add(r"L_{" +
          i.toString() +
          r"}(x) = \frac{" +
          numeradorSimbolico.join(r" \cdot ") +
          r"}{" +
          denominadorSimbolico.join(r" \cdot ") +
          r"}");

      // Mostrar denominador operado
      pasos.add(r"L_{" +
          i.toString() +
          r"}(x) = \frac{" +
          numeradorSimbolico.join(r" \cdot ") +
          r"}{" +
          denominadorOperado.toStringAsFixed(4) +
          r"}");

      // Calcular numerador polinómico
      List<double> numerador = _calcularNumeradorPolinomio(x, i, numPuntos);
      for (int j = 0; j < numerador.length; j++) {
        numerador[j] = (numerador[j] * y[i]) / denominadorOperado;
      }

      // Sumar este término al polinomio resultado
      for (int j = 0; j < resultado.length; j++) {
        resultado[j] += numerador[j];
      }
    }

    return resultado;
  }

  static List<double> _calcularNumeradorPolinomio(List<double> x, int i, int numPuntos) {
    List<double> coeficientes = [1.0];
    for (int j = 0; j < numPuntos; j++) {
      if (j != i) {
        coeficientes = _multiplicarPolinomios(coeficientes, [-x[j], 1.0]);
      }
    }
    return coeficientes;
  }


  static double _calcularDenominador(List<double> x, int i) {
    double denominador = 1.0;
    for (int j = 0; j < x.length; j++) {
      if (j != i) {
        denominador *= (x[i] - x[j]);
      }
    }
    return denominador;
  }

  static List<double> _multiplicarPolinomios(List<double> p1, List<double> p2) {
    List<double> resultado =
    List.filled(p1.length + p2.length - 1, 0.0); // Crear espacio suficiente

    for (int i = 0; i < p1.length; i++) {
      for (int j = 0; j < p2.length; j++) {
        resultado[i + j] += p1[i] * p2[j];
      }
    }
    return resultado;
  }

  static double evaluarPolinomio(List<double> coeficientes, double x) {
    double resultado = 0.0;
    for (int i = 0; i < coeficientes.length; i++) {
      resultado += coeficientes[i] * pow(x, i);
    }
    return resultado;
  }

  static String mostrarPolinomio(List<double> coeficientes) {
    StringBuffer polinomio = StringBuffer();
    for (int i = coeficientes.length - 1; i >= 0; i--) {
      if (coeficientes[i].abs() > 1e-10) {
        if (polinomio.isNotEmpty && coeficientes[i] > 0) {
          polinomio.write(' + ');
        } else if (coeficientes[i] < 0) {
          polinomio.write(' - ');
        }
        double absCoef = coeficientes[i].abs();
        if (absCoef != 1 || i == 0) {
          polinomio.write(absCoef.toStringAsFixed(4));
        }
        if (i > 0) {
          polinomio.write('x');
          if (i > 1) polinomio.write('^$i');
        }
      }
    }
    return polinomio.isNotEmpty ? polinomio.toString() : 'No válido';
  }
}
