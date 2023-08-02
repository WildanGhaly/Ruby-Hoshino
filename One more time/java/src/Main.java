import java.io.*;
import java.util.*;

class Polynomial {
    private List<Float> coeffs;

    public Polynomial(List<Float> coefficients) {
        coeffs = new ArrayList<>(coefficients);
    }

    public int degree() {
        return coeffs.size() - 1;
    }

    public float get(int idx) {
        return coeffs.get(idx);
    }

    public void set(int idx, float value) {
        coeffs.set(idx, value);
    }

    public Polynomial add(Polynomial other) {
        int maxSize = Math.max(coeffs.size(), other.coeffs.size());
        List<Float> resultCoeffs = new ArrayList<>(Collections.nCopies(maxSize, 0f));

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) + coeffs.get(i));
        }

        for (int i = 0; i < other.coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) + other.coeffs.get(i));
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial add(float scalar) {
        List<Float> resultCoeffs = new ArrayList<>(coeffs);

        resultCoeffs.set(0, resultCoeffs.get(0) + scalar);

        return new Polynomial(resultCoeffs);
    }

    public Polynomial subtract(Polynomial other) {
        int maxSize = Math.max(coeffs.size(), other.coeffs.size());
        List<Float> resultCoeffs = new ArrayList<>(Collections.nCopies(maxSize, 0f));

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) + coeffs.get(i));
        }

        for (int i = 0; i < other.coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) - other.coeffs.get(i));
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial subtract(float scalar) {
        List<Float> resultCoeffs = new ArrayList<>(coeffs);

        resultCoeffs.set(0, resultCoeffs.get(0) - scalar);

        return new Polynomial(resultCoeffs);
    }

    public Polynomial multiply(Polynomial other) {
        int resultSize = coeffs.size() + other.coeffs.size() - 1;
        List<Float> resultCoeffs = new ArrayList<>(Collections.nCopies(resultSize, 0f));

        for (int i = 0; i < coeffs.size(); ++i) {
            for (int j = 0; j < other.coeffs.size(); ++j) {
                resultCoeffs.set(i + j, resultCoeffs.get(i + j) + coeffs.get(i) * other.coeffs.get(j));
            }
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial multiply(float scalar) {
        List<Float> resultCoeffs = new ArrayList<>(coeffs);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) * scalar);
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial divide(float scalar) {
        List<Float> resultCoeffs = new ArrayList<>(coeffs);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs.set(i, resultCoeffs.get(i) / scalar);
        }

        return new Polynomial(resultCoeffs);
    }

    public void print() {
        boolean isFirst = true;
        float eps = 1e-5f;
        for (int i = coeffs.size() - 1; i >= 0; --i) {
            if (!isFirst && coeffs.get(i) > eps) {
                System.out.print(" + ");
            } else if (coeffs.get(i) < -eps) {
                System.out.print(" - ");
            } else if (coeffs.get(i) > -eps && coeffs.get(i) < eps) {
                continue;
            }

            if (i == 0 && coeffs.get(i) != 0){
                System.out.print(Math.abs(coeffs.get(i)));
            } else if (i == 1 && coeffs.get(i) != 0) {
                System.out.print(Math.abs(coeffs.get(i)) + "x");
                isFirst = false;
            } else if (coeffs.get(i) != 0) {
                System.out.print(Math.abs(coeffs.get(i)) + "x^" + i);
                isFirst = false;
            }
        }
        System.out.println();
    }

    public void print(PrintWriter outFile) {
        boolean isFirst = true;
        float eps = 1e-5f;
        for (int i = coeffs.size() - 1; i >= 0; --i) {
            if (!isFirst && coeffs.get(i) > eps) {
                outFile.print(" + ");
            } else if (coeffs.get(i) < -eps) {
                outFile.print(" - ");
            } else if (coeffs.get(i) > -eps && coeffs.get(i) < eps) {
                continue;
            }

            if (i == 0 && coeffs.get(i) != 0){
                outFile.print(Math.abs(coeffs.get(i)));
            } else if (i == 1 && coeffs.get(i) != 0) {
                outFile.print(Math.abs(coeffs.get(i)) + "x");
                isFirst = false;
            } else if (coeffs.get(i) != 0) {
                outFile.print(Math.abs(coeffs.get(i)) + "x^" + i);
                isFirst = false;
            }
        }
        outFile.println();
    }
}

public class Main {
    public static Polynomial getLkt(int k, List<Float> xi) {
        List<Float> symbolPoint = Arrays.asList(0f, 1f);
        List<Float> symbolPoint2 = Arrays.asList(1f);
        Polynomial xSymbol = new Polynomial(symbolPoint);
        Polynomial result = new Polynomial(symbolPoint2);

        for (int i = 0; i < xi.size(); ++i) {
            if (i != k) {
                Polynomial temp = xSymbol.subtract(xi.get(i)).divide(xi.get(k) - xi.get(i));
                result = result.multiply(temp);
            }
        }

        return result;
    }

    public static Polynomial getPnt(List<Float> xi, List<Float> yi) {
        List<Float> symbolPoint = Arrays.asList(0f);
        Polynomial result = new Polynomial(symbolPoint);

        for (int i = 0; i < xi.size(); ++i) {
            Polynomial temp = getLkt(i, xi).multiply(yi.get(i));
            result = result.add(temp);
        }
        return result;
    }

    public static void main(String[] args) throws IOException {
        int N, x, y;
        String inputFileName, outputFileName;
        List<Float> xVector = new ArrayList<>();
        List<Float> yVector = new ArrayList<>();

        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter the name/path of the input file: ");
        inputFileName = scanner.next();
        System.out.print("Enter the name/path of the output file: ");
        outputFileName = scanner.next();

        File inputFile = new File(inputFileName);
        Scanner fileScanner = new Scanner(inputFile);

        N = fileScanner.nextInt();

        for (int i = 0; i < N + 1; ++i) {
            x = fileScanner.nextInt();
            y = fileScanner.nextInt();
            xVector.add((float) x);
            yVector.add((float) y);
        }

        fileScanner.close();

        Polynomial result = getPnt(xVector, yVector);

        PrintWriter outFile = new PrintWriter(new File(outputFileName));
        result.print(outFile);
        result.print();

        outFile.close();

        scanner.close();
    }
}
