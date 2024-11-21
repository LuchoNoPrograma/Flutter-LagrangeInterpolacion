import 'dart:math'; // Import necesario para usar pow

class LagrangeInterpolation {
  static List<String> pasos = [];
  static Map<int, List<String>> pasosPorLi = {};

  // Método para calcular el polinomio de interpolación con pasos
  static List<double> calcularPolinomioConPasos(List<double> x, List<double> y) {
    pasosPorLi.clear();  // Limpiar los pasos almacenados previamente

    int numPuntos = x.length;
    List<double> resultado = List.filled(numPuntos * 2 - 1, 0.0); // Asegúrate de que el tamaño sea correcto

    for (int i = 0; i < numPuntos; i++) {
      List<String> pasos = [];

      pasos.add(r"\text{Reemplazar terminos de } L_{" + i.toString() + r"}(x) \text{ y operar:}");

      // Paso inicial: Reemplazar (x - x_j) en el numerador y (x_i - x_j) en el denominador
      StringBuffer reemplazoNumerador = StringBuffer();
      StringBuffer reemplazoDenominador = StringBuffer();
      double denominadorOperado = 1.0;
      List<List<double>> factoresNumerador = [];

      for (int j = 0; j < numPuntos; j++) {
        if (j != i) {
          // Numerador: (x - x_j)
          factoresNumerador.add([-x[j], 1.0]);

          // Denominador: (x_i - x_j)
          denominadorOperado *= (x[i] - x[j]);

          String valorNumerador = (x[j] < 0 ? "(${formatearNumero(x[j])})" : formatearNumero(x[j]));
          String valorDenominador = (x[i] < 0 ? "(${formatearNumero(x[i])})" : formatearNumero(x[i]));

          if (j != 0) {
            reemplazoNumerador.write(r" \cdot ");
            reemplazoDenominador.write(r" \cdot ");
          }

          // Escribir el término en el numerador y denominador
          reemplazoNumerador.write(r"(x - " + valorNumerador + ")");
          reemplazoDenominador.write(r"(" + valorDenominador + " - " + valorNumerador + ")");
        }
      }

      // Mostrar el paso de reemplazo del numerador y denominador
      pasos.add(r"L_{" + i.toString() + r"}(x) = \frac{" +
          reemplazoNumerador.toString() +
          r"}{" +
          reemplazoDenominador.toString() +
          r"}");

      // Expansión del numerador
      List<double> numeradorExpandido = _expandirNumerador(factoresNumerador);

      // Mostrar el paso con numerador expandido
      pasos.add(r"\text{Dividir los coeficientes del númerador entre el denominador:}");
      pasos.add(r"L_{" + i.toString() + r"}(x) = \frac{" +
          mostrarPolinomio(numeradorExpandido) + r"}" +
          r"{" + formatearNumero(denominadorOperado) + r"}");

      // Realizar la división de cada término del numerador entre el denominador
      List<double> numeradorDividido = [];
      for (int j = 0; j < numeradorExpandido.length; j++) {
        numeradorDividido.add(numeradorExpandido[j] / denominadorOperado);
      }

      // Mostrar el paso de la división
      pasos.add(r"\text{Resultado obtenido:}");
      pasos.add(r"L_{" +
          i.toString() +
          r"}(x) = " +
          mostrarPolinomio(numeradorDividido));

      pasosPorLi[i] = pasos;  // Almacenar los pasos de L_i(x)

      // Acumular los términos de cada L_i(x) multiplicado por y_i
      for (int j = 0; j < numeradorDividido.length; j++) {
        resultado[j] += numeradorDividido[j] * y[i];
      }
    }

    return resultado;
  }

  static String formatearNumero(double numero) {
    if (numero % 1 == 0) {
      return numero.toInt().toString(); // Si es entero, eliminar decimales
    }
    return numero.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  static List<double> _expandirNumerador(List<List<double>> factores) {
    List<double> resultado = [1.0]; // Polinomio inicial (1.0)

    for (List<double> factor in factores) {
      resultado = _multiplicarPolinomios(resultado, factor);
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
    List<double> resultado = List.filled(p1.length + p2.length - 1, 0.0);

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
          polinomio.write(formatearNumero(absCoef));
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
