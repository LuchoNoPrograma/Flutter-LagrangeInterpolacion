import 'dart:math';

class LagrangeModelo {
  static List<String> pasos = [];
  static Map<int, List<String>> pasosPorLi = {};
  static String formulaFinal = "";

  static List<double> calcularPolinomioConPasos(List<double> x, List<double> y) {
    pasosPorLi.clear();
    formulaFinal = "";

    int numPuntos = x.length;
    List<double> resultado = List.filled(numPuntos * 2 - 1, 0.0);

    // Ciclo padre para operar CADA PUNTO
    for (int i = 0; i < numPuntos; i++) {
      List<String> pasos = [];

      pasos.add(r"\text{Reemplazar terminos de } L_{" + i.toString() + r"}(x) \text{ y operar:}");

      // Paso 1: Reemplazar (x - x_j) en el numerador y (x_i - x_j) en el denominador
      StringBuffer reemplazoNumerador = StringBuffer();
      StringBuffer reemplazoDenominador = StringBuffer();
      double denominadorOperado = 1.0;
      List<List<double>> factoresNumerador = [];

      StringBuffer terminos = StringBuffer();

      // 1er. Ciclo anidado para reemplazar los valores de L(i)
      for (int j = 0; j < numPuntos; j++) {
        if (j != i) {
          // Numerador: (x - x_j) -> osea el punto actual de la iteracion pero en negativo -x[j], ejemplo: j = 3 => -3
          factoresNumerador.add([-x[j], 1.0]); // El segundo param es el coeficiente de x en (x - x_j) osea ignoren esto

          // Denominador: (x_i - x_j) -> aca opera el denominador
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

      // Paso 2.- Realizar la división de cada término del numerador entre el denominador
      // Expansión del numerador => multiplicación de polinomios
      List<double> numeradorExpandido = _expandirNumerador(factoresNumerador);

      // Mostrar el paso con numerador expandido
      pasos.add(r"\text{Dividir coeficientes númerador/denominador:}");
      pasos.add(r"L_{" + i.toString() + r"}(x) = \frac{" +
          mostrarPolinomio(numeradorExpandido) + r"}" + r"{" + formatearNumero(denominadorOperado) + r"}");

      // 2do. Ciclo anidado para operar numerador sobre denominador
      List<double> numeradorDividido = [];
      for (int j = 0; j < numeradorExpandido.length; j++) {
        numeradorDividido.add(numeradorExpandido[j] / denominadorOperado);
      }

      // Mostrar el paso de la división
      pasos.add(r"\text{Resultado obtenido:}");
      pasos.add(r"L_{" + i.toString() + r"}(x) = " + mostrarPolinomio(numeradorDividido));

      // Aquí agregamos la parte de multiplicar el polinomio con y_i
      // Modificamos la fórmula final para que cada término tenga (L_i(x)) * y_i

      String polinomioConYi = "(${mostrarPolinomio(numeradorDividido)})";  // Polinomio rodeado de paréntesis
      String polinomioConYiFinal = "$polinomioConYi(${formatearNumero(y[i])})";  // Multiplicamos por y_i

      // Agregamos este término a la fórmula final
      if (i == numPuntos - 1) {
        formulaFinal += polinomioConYiFinal; // Sin "+" al final
      } else {
        formulaFinal += "$polinomioConYiFinal + "; // Añadir "+" solo si no es el último término
      }


      pasosPorLi[i] = pasos; // Almacenar los pasos de cada L_i(x)

      // Paso por completar, por ahora multiplica cada L_i por y_i pero no muestra el proceso
      // 3er. Ciclo anidado para multiplicar el y_i por L_i y agregar al resultado
      for (int j = 0; j < numeradorDividido.length; j++) {
        resultado[j] += numeradorDividido[j] * y[i];
      }
    }

    return resultado;
  }

  static List<double> _expandirNumerador(List<List<double>> factores) {
    List<double> resultado = [1.0]; // Polinomio inicial (1.0)

    for (List<double> factor in factores) {
      resultado = _multiplicarPolinomios(resultado, factor);
    }
    return resultado;
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

  static String formatearNumero(double numero) {
    if (numero % 1 == 0) {
      return numero.toInt().toString(); // Si es entero, eliminar decimales
    }
    return numero.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
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