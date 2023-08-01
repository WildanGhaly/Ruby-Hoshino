using System;
using System.Collections.Generic;
using System.IO;

class Polynomial
{
    private List<float> coeffs;

    public Polynomial(List<float> coefficients)
    {
        coeffs = coefficients;
    }

    public int Degree => coeffs.Count - 1;

    public float this[int idx]
    {
        get => coeffs[idx];
        set => coeffs[idx] = value;
    }

    public Polynomial Add(Polynomial other)
    {
        int maxSize = Math.Max(coeffs.Count, other.coeffs.Count);
        List<float> resultCoeffs = new List<float>(maxSize);

        for (int i = 0; i < maxSize; i++)
        {
            float coeff1 = (i < coeffs.Count) ? coeffs[i] : 0;
            float coeff2 = (i < other.coeffs.Count) ? other.coeffs[i] : 0;
            resultCoeffs.Add(coeff1 + coeff2);
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Add(float scalar)
    {
        List<float> resultCoeffs = new List<float>(coeffs);
        resultCoeffs[0] += scalar;

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Subtract(Polynomial other)
    {
        int maxSize = Math.Max(coeffs.Count, other.coeffs.Count);
        List<float> resultCoeffs = new List<float>(maxSize);

        for (int i = 0; i < maxSize; i++)
        {
            float coeff1 = (i < coeffs.Count) ? coeffs[i] : 0;
            float coeff2 = (i < other.coeffs.Count) ? other.coeffs[i] : 0;
            resultCoeffs.Add(coeff1 - coeff2);
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Subtract(float scalar)
    {
        List<float> resultCoeffs = new List<float>(coeffs);
        resultCoeffs[0] -= scalar;

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Multiply(Polynomial other)
    {
        int resultSize = coeffs.Count + other.coeffs.Count - 1;
        List<float> resultCoeffs = new List<float>(new float[resultSize]);

        for (int i = 0; i < coeffs.Count; i++)
        {
            for (int j = 0; j < other.coeffs.Count; j++)
            {
                resultCoeffs[i + j] += coeffs[i] * other.coeffs[j];
            }
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Multiply(float scalar)
    {
        List<float> resultCoeffs = new List<float>(coeffs.Count);

        for (int i = 0; i < coeffs.Count; i++)
        {
            resultCoeffs.Add(coeffs[i] * scalar);
        }

        return new Polynomial(resultCoeffs);
    }

    public Polynomial Divide(float scalar)
    {
        List<float> resultCoeffs = new List<float>(coeffs.Count);

        for (int i = 0; i < coeffs.Count; i++)
        {
            resultCoeffs.Add(coeffs[i] / scalar);
        }

        return new Polynomial(resultCoeffs);
    }

    public void Print()
    {
        bool isFirst = true;
        for (int i = coeffs.Count - 1; i >= 0; i--)
        {
            if (!isFirst && coeffs[i] > 1e-5)
            {
                Console.Write(" + ");
            }
            else if (coeffs[i] < -1e-5)
            {
                Console.Write(" - ");
            }
            else if (coeffs[i] >= -1e-5 && coeffs[i] <= 1e-5)
            {
                continue;
            }

            if (i == 0 && coeffs[i] != 0)
            {
                Console.Write(coeffs[i] > 0 ? coeffs[i] : -coeffs[i]);
            }
            else if (i == 1 && coeffs[i] != 0)
            {
                Console.Write(coeffs[i] > 0 ? coeffs[i] + "x" : -coeffs[i] + "x");
                isFirst = false;
            }
            else if (coeffs[i] != 0)
            {
                Console.Write(coeffs[i] > 0 ? coeffs[i] + "x^" + i : -coeffs[i] + "x^" + i);
                isFirst = false;
            }
        }
        Console.WriteLine();
    }

    public void Print(StreamWriter outFile)
    {
        bool isFirst = true;
        for (int i = coeffs.Count - 1; i >= 0; i--)
        {
            if (!isFirst && coeffs[i] > 1e-5)
            {
                outFile.Write(" + ");
            }
            else if (coeffs[i] < -1e-5)
            {
                outFile.Write(" - ");
            }
            else if (coeffs[i] >= -1e-5 && coeffs[i] <= 1e-5)
            {
                continue;
            }

            if (i == 0 && coeffs[i] != 0)
            {
                outFile.Write(coeffs[i] > 0 ? coeffs[i] : -coeffs[i]);
            }
            else if (i == 1 && coeffs[i] != 0)
            {
                outFile.Write(coeffs[i] > 0 ? coeffs[i] + "x" : -coeffs[i] + "x");
                isFirst = false;
            }
            else if (coeffs[i] != 0)
            {
                outFile.Write(coeffs[i] > 0 ? coeffs[i] + "x^" + i : -coeffs[i] + "x^" + i);
                isFirst = false;
            }
        }
        outFile.WriteLine();
    }
}

class Program
{
    static Polynomial GetLkt(int k, List<float> xi)
    {
        List<float> symbolPoint = new List<float> { 0, 1 };
        List<float> symbolPoint2 = new List<float> { 1 };
        Polynomial xSymbol = new Polynomial(symbolPoint);
        Polynomial result = new Polynomial(symbolPoint2);

        for (int i = 0; i < xi.Count; i++)
        {
            if (i != k)
            {
                Polynomial temp = (xSymbol.Subtract(xi[i])).Divide(xi[k] - xi[i]);
                result = result.Multiply(temp);
            }
        }

        return result;
    }

    static Polynomial GetPnt(List<float> xi, List<float> yi)
    {
        List<float> symbolPoint = new List<float> { 0 };
        Polynomial result = new Polynomial(symbolPoint);

        for (int i = 0; i < xi.Count; i++)
        {
            Polynomial temp = GetLkt(i, xi).Multiply(yi[i]);
            result = result.Add(temp);
        }

        return result;
    }

    static void Main()
    {
        int N, x, y;
        string inputFileName, outputFileName;
        List<float> xVector = new List<float>();
        List<float> yVector = new List<float>();

        Console.Write("Enter the name/path of the input file: ");
        inputFileName = Console.ReadLine();
        Console.Write("Enter the name/path of the output file: ");
        outputFileName = Console.ReadLine();

        try
        {
            using (StreamReader inputFile = new StreamReader(inputFileName))
            {
                N = int.Parse(inputFile.ReadLine());

                for (int i = 0; i < N + 1; i++)
                {
                    string[] line = inputFile.ReadLine().Split(' ');
                    x = int.Parse(line[0]);
                    y = int.Parse(line[1]);
                    xVector.Add(x);
                    yVector.Add(y);
                }
            }

            Polynomial result = GetPnt(xVector, yVector);

            using (StreamWriter outFile = new StreamWriter(outputFileName))
            {
                result.Print(outFile);
            }
            result.Print();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }
}
