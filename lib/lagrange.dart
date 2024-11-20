import 'dart:math'; // Import necesario para usar pow

class LagrangeInterpolation {
  // Método para calcular el polinomio de interpolación
  static List<double> calcularPolinomio(List<double> x, List<double> y) {
    int numPuntos = x.length;
    List<double> resultado = List.filled(numPuntos, 0.0);

    for (int i = 0; i < numPuntos; i++) {
      List<double> numerador = _calcularNumerador(x, i, numPuntos);
      double denominador = _calcularDenominador(x, i);
      for (int j = 0; j < numerador.length; j++) {
        numerador[j] = (numerador[j] * y[i]) / denominador;
      }
      for (int j = 0; j < resultado.length; j++) {
        resultado[j] += numerador[j];
      }
    }
    return resultado;
  }

  // Método para calcular el numerador de Li(x)
  static List<double> _calcularNumerador(List<double> x, int i, int numPuntos) {
    List<List<double>> polinomios = [];
    for (int j = 0; j < numPuntos; j++) {
      if (j != i) {
        polinomios.add([-x[j], 1]); // Representa (x - xj)
      }
    }
    return _multiplicarPolinomios(polinomios);
  }

  // Multiplicación de varios polinomios
  static List<double> _multiplicarPolinomios(List<List<double>> polinomios) {
    if (polinomios.isEmpty) return [1.0];
    if (polinomios.length == 1) return polinomios[0];

    List<double> resultado = polinomios[0];
    for (int i = 1; i < polinomios.length; i++) {
      resultado = _multiplicarDosPolinomios(resultado, polinomios[i]);
    }
    return resultado;
  }

  // Multiplicación de dos polinomios
  static List<double> _multiplicarDosPolinomios(List<double> p1, List<double> p2) {
    List<double> resultado = List.filled(p1.length + p2.length - 1, 0.0);
    for (int i = 0; i < p1.length; i++) {
      for (int j = 0; j < p2.length; j++) {
        resultado[i + j] += p1[i] * p2[j];
      }
    }
    return resultado;
  }

  // Método para calcular el denominador de Li(x)
  static double _calcularDenominador(List<double> x, int i) {
    double denominador = 1.0;
    for (int j = 0; j < x.length; j++) {
      if (j != i) {
        denominador *= (x[i] - x[j]);
      }
    }
    return denominador;
  }

  // Evaluar el polinomio en un valor específico
  static double evaluarPolinomio(List<double> coeficientes, double x) {
    double resultado = 0.0;
    for (int i = 0; i < coeficientes.length; i++) {
      resultado += coeficientes[i] * pow(x, i); // Usar pow del paquete dart:math
    }
    return resultado;
  }


  // Mostrar el polinomio como una cadena
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
    return polinomio.isNotEmpty ? polinomio.toString() : '0';
  }
}
