import java.util.Scanner;

public class calcu_Lagrange {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Ingrese el grado del polinomio:");
        int grado = scanner.nextInt();
        int numPuntos = grado + 1;
        double[] x = new double[numPuntos];
        double[] y = new double[numPuntos];
        System.out.println("Ingrese los " + numPuntos + " puntos (x,y):");
        for (int i = 0; i < numPuntos; i++) {
            System.out.println("Punto " + (i + 1) + ":");
            System.out.print("x" + i + " = ");
            x[i] = scanner.nextDouble();
            System.out.print("y" + i + " = ");
            y[i] = scanner.nextDouble();
        }
        //calculando  el polinomio
        double[] resultado = new double[numPuntos];
        //para cada punto Li(x)
        for (int i = 0; i < numPuntos; i++) {
            double[] numerador = calcularNumerador(x, i, numPuntos);
            double denominador = calcularDenominador(x, i);
            for (int j = 0; j < numerador.length; j++) {
                numerador[j] = (numerador[j] * y[i]) / denominador;
            }
            for (int j = 0; j < resultado.length; j++) {
                resultado[j] += numerador[j];
            }
        }
        //polinomio resultante
        System.out.println("\nPolinomio resultante P(x):");
        mostrarPolinomio(resultado);
        System.out.println("\n¿Desea interpolar un valor específico? (s/n)");
        scanner.nextLine();
        String respuesta = scanner.nextLine();
        if (respuesta.toLowerCase().startsWith("s")) {
            System.out.println("Ingrese el valor de x a interpolar:");
            double valorX = scanner.nextDouble();
            double valorInterpolado = evaluarPolinomio(resultado, valorX);
            System.out.printf("P(%.2f) = %.4f\n", valorX, valorInterpolado);
        }
        scanner.close();
    }
    //calcular numerador de Li(x)
    private static double[] calcularNumerador(double[] x, int i, int numPuntos) {
        double[][] polinomios = new double[numPuntos - 1][2];
        int index = 0;
        //crear cada término (x-xj)
        for (int j = 0; j < numPuntos; j++) {
            if (j != i) {
                polinomios[index] = new double[]{-x[j], 1}; // representa: x -xj
                index++;
            }
        }
        return multiplicarNPolinomios(polinomios);
    }
    //multiplicacion DE n polinomios
    private static double[] multiplicarNPolinomios(double[][] polinomios) {
        // si no hay polinomios retornar 1
        if (polinomios.length == 0) return new double[]{1};
        // Si hay solo un polinomio retornarlo
        if (polinomios.length == 1) return polinomios[0];
        // comenzar con el primer polinomio
        double[] resultado = polinomios[0];
        // multiplicar sucesivamente por los demas polinomios
        for (int i = 1; i < polinomios.length; i++) {
            resultado = multiplicarDosPolinomios(resultado, polinomios[i]);
        }
        return resultado;
    }
    // multiplicar 2 polinomios
    private static double[] multiplicarDosPolinomios(double[] p1, double[] p2) {
        double[] resultado = new double[p1.length + p2.length - 1];

        for (int i = 0; i < p1.length; i++) {
            for (int j = 0; j < p2.length; j++) {
                resultado[i + j] += p1[i] * p2[j];
            }
        }
        return resultado;
    }

    //denominador Li(x)
    private static double calcularDenominador(double[] x, int i) {
        double denominador = 1.0;
        for (int j = 0; j < x.length; j++) {
            if (j != i) {
                denominador *= (x[i] - x[j]);
            }
        }
        return denominador;
    }
    //mostrar polinomio resultante
    private static void mostrarPolinomio(double[] coeficientes) {
        StringBuilder polinomio = new StringBuilder();
        boolean primero = true;
        for (int i = coeficientes.length - 1; i >= 0; i--) {
            if (Math.abs(coeficientes[i]) > 1e-10) {
                if (!primero && coeficientes[i] > 0) {
                    polinomio.append(" + ");
                } else if (!primero && coeficientes[i] < 0) {
                    polinomio.append(" - ");
                } else if (coeficientes[i] < 0) {
                    polinomio.append("-");
                }
                double absCoef = Math.abs(coeficientes[i]);
                if (Math.abs(absCoef - 1) > 1e-10 || i == 0) {
                    String coefStr = String.format("%.4f", absCoef);
                    if (coefStr.endsWith("0000")) {
                        coefStr = coefStr.substring(0, coefStr.length() - 5);
                    }
                    polinomio.append(coefStr);
                }
                if (i > 0) {
                    polinomio.append("x");
                    if (i > 1) {
                        polinomio.append("^").append(i);
                    }
                } primero = false;
            }
        }

        if (polinomio.length() == 0) {polinomio.append("0");}
        System.out.println(polinomio.toString());
    }
    //interpolacion :D
    private static double evaluarPolinomio(double[] coeficientes, double x) {
        double resultado = 0;
        for (int i = 0; i < coeficientes.length; i++) {
            resultado += coeficientes[i] * Math.pow(x, i);
        }
        return resultado;
    }
}