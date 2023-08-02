import 'dart:io';

class Polynomial {
  List<double> coeffs = [];

  Polynomial(List<double> coefficients) {
    this.coeffs = coefficients;
  }

  int degree() {
    return coeffs.length - 1;
  }

  List<double> getCoefficients() {
    return coeffs;
  }

  double getCoefficient(int idx) {
    return coeffs[idx];
  }

  void setCoefficient(int idx, double value) {
    coeffs[idx] = value;
  }

  Polynomial add(Polynomial other) {
    int maxSize = coeffs.length > other.coeffs.length ? coeffs.length : other.coeffs.length;
    List<double> resultCoeffs = List.filled(maxSize, 0);

    for (int i = 0; i < coeffs.length; ++i) {
      resultCoeffs[i] += coeffs[i];
    }

    for (int i = 0; i < other.coeffs.length; ++i) {
      resultCoeffs[i] += other.coeffs[i];
    }

    return Polynomial(resultCoeffs);
  }

  Polynomial addScalar(double scalar) {
    List<double> resultCoeffs = List.from(coeffs);
    resultCoeffs[0] += scalar;

    return Polynomial(resultCoeffs);
  }

  Polynomial subtract(Polynomial other) {
    int maxSize = coeffs.length > other.coeffs.length ? coeffs.length : other.coeffs.length;
    List<double> resultCoeffs = List.filled(maxSize, 0);

    for (int i = 0; i < coeffs.length; ++i) {
      resultCoeffs[i] += coeffs[i];
    }

    for (int i = 0; i < other.coeffs.length; ++i) {
      resultCoeffs[i] -= other.coeffs[i];
    }

    return Polynomial(resultCoeffs);
  }

  Polynomial subtractScalar(double scalar) {
    List<double> resultCoeffs = List.from(coeffs);
    resultCoeffs[0] -= scalar;

    return Polynomial(resultCoeffs);
  }

  Polynomial multiply(Polynomial other) {
    int resultSize = coeffs.length + other.coeffs.length - 1;
    List<double> resultCoeffs = List.filled(resultSize, 0);

    for (int i = 0; i < coeffs.length; ++i) {
      for (int j = 0; j < other.coeffs.length; ++j) {
        resultCoeffs[i + j] += coeffs[i] * other.coeffs[j];
      }
    }

    return Polynomial(resultCoeffs);
  }

  Polynomial multiplyScalar(double scalar) {
    List<double> resultCoeffs = [];

    for (double coeff in coeffs) {
      resultCoeffs.add(coeff * scalar);
    }

    return Polynomial(resultCoeffs);
  }

  Polynomial divideScalar(double scalar) {
    List<double> resultCoeffs = [];

    for (double coeff in coeffs) {
      resultCoeffs.add(coeff / scalar);
    }

    return Polynomial(resultCoeffs);
  }

  void printPolynomial() {
    double nearlyZero = 1e-6;
    bool isFirst = true;

    for (int i = coeffs.length - 1; i >= 0; --i) {
      if (!isFirst && coeffs[i] > nearlyZero) {
        stdout.write(' + ');
      } else if (coeffs[i] < -nearlyZero) {
        stdout.write(' - ');
      } else if (coeffs[i] < nearlyZero && coeffs[i] > -nearlyZero) {
        continue;
      }

      if (i == 0 && (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero)) {
        stdout.write(coeffs[i] > 0 ? coeffs[i] : -coeffs[i]);
      } else if (i == 1 && (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero)) {
        stdout.write(coeffs[i] > 0 ? '${coeffs[i]}x' : '${-coeffs[i]}x');
        isFirst = false;
      } else if (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero) {
        stdout.write(coeffs[i] > 0 ? '${coeffs[i]}x^$i' : '${-coeffs[i]}x^$i');
        isFirst = false;
      }
    }

    stdout.write('\n');
  }

  void writeToTextFile(String filename) {
    double nearlyZero = 1e-6;
    bool isFirst = true;

    var file = File(filename);
    var sink = file.openWrite();

    for (int i = coeffs.length - 1; i >= 0; --i) {
      if (!isFirst && coeffs[i] > nearlyZero) {
        sink.write(' + ');
      } else if (coeffs[i] < -nearlyZero) {
        sink.write(' - ');
      } else if (coeffs[i] < nearlyZero && coeffs[i] > -nearlyZero) {
        continue;
      }

      if (i == 0 && (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero)) {
        sink.write(coeffs[i] > 0 ? coeffs[i].toString() : (-coeffs[i]).toString());
      } else if (i == 1 && (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero)) {
        sink.write(coeffs[i] > 0 ? '${coeffs[i]}x' : '${-coeffs[i]}x');
        isFirst = false;
      } else if (coeffs[i] < -nearlyZero || coeffs[i] > nearlyZero) {
        sink.write(coeffs[i] > 0 ? '${coeffs[i]}x^$i' : '${-coeffs[i]}x^$i');
        isFirst = false;
      }
    }

    sink.write('\n');
    sink.close();
  }
}

Polynomial getLkt(int k, List<double> xi) {
  List<double> symbolPoint = [0, 1];
  List<double> symbolPoint2 = [1];
  Polynomial xSymbol = Polynomial(symbolPoint);
  Polynomial result = Polynomial(symbolPoint2);

  for (int i = 0; i < xi.length; ++i) {
    if (i != k) {
      Polynomial temp = xSymbol.subtractScalar(xi[i]).divideScalar(xi[k] - xi[i]);
      result = result.multiply(temp);
    }
  }

  return result;
}

Polynomial getPnt(List<double> xi, List<double> yi) {
  List<double> symbolPoint = [0];
  Polynomial result = Polynomial(symbolPoint);

  for (int i = 0; i < xi.length; ++i) {
    Polynomial temp = getLkt(i, xi).multiplyScalar(yi[i]);
    result = result.add(temp);
  }
  return result;
}

Map<String, List<double>> readPointsFromFile(String filename) {
  List<double> xVector = [];
  List<double> yVector = [];

  var file = File(filename);
  List<String> lines = file.readAsLinesSync();

  int N = int.parse(lines[0]);

  for (int i = 1; i < N + 2; i++) {
    List<String> values = lines[i].split(' ');
    double x = double.parse(values[0]);
    double y = double.parse(values[1]);

    xVector.add(x);
    yVector.add(y);
  }

  return {'xVector': xVector, 'yVector': yVector};
}

void main() {
  String fileInput, fileOutput;

  stdout.write("Enter the file input name/path: ");
  fileInput = stdin.readLineSync()!;

  stdout.write("Enter the file output name/path: ");
  fileOutput = stdin.readLineSync()!;

  Map<String, List<double>> result = readPointsFromFile(fileInput);

  List<double> xVector = result['xVector']!;
  List<double> yVector = result['yVector']!;

  Polynomial resultPolynomial = getPnt(xVector, yVector);
  resultPolynomial.printPolynomial();
  resultPolynomial.writeToTextFile(fileOutput);
}
