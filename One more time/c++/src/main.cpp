#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

class Polynomial {
private:
    vector<float> coeffs; 

public:
    Polynomial(const vector<float>& coefficients) : coeffs(coefficients) {}

    int degree() const {
        return coeffs.size() - 1;
    }

    float& operator[](int idx) {
        return coeffs[idx];
    }

    float operator[](int idx) const {
        return coeffs[idx];
    }

    Polynomial operator+(const Polynomial& other) const {
        int maxSize = max(coeffs.size(), other.coeffs.size());
        vector<float> resultCoeffs(maxSize, 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] += coeffs[i];
        }

        for (int i = 0; i < other.coeffs.size(); ++i) {
            resultCoeffs[i] += other.coeffs[i];
        }

        return Polynomial(resultCoeffs);
    }

    Polynomial operator+(const float scalar) const {
        vector<float> resultCoeffs(coeffs.size(), 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] = coeffs[i];
        }
        resultCoeffs[0] += scalar;

        return Polynomial(resultCoeffs);
    }

    Polynomial operator-(const Polynomial& other) const {
        int maxSize = max(coeffs.size(), other.coeffs.size());
        vector<float> resultCoeffs(maxSize, 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] += coeffs[i];
        }

        for (int i = 0; i < other.coeffs.size(); ++i) {
            resultCoeffs[i] -= other.coeffs[i];
        }

        return Polynomial(resultCoeffs);
    }

    Polynomial operator-(const float scalar) const {
        vector<float> resultCoeffs(coeffs.size(), 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] = coeffs[i];
        }

        resultCoeffs[0] -= scalar;

        return Polynomial(resultCoeffs);
    }

    Polynomial operator*(const Polynomial& other) const {
        int resultSize = coeffs.size() + other.coeffs.size() - 1;
        vector<float> resultCoeffs(resultSize, 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            for (int j = 0; j < other.coeffs.size(); ++j) {
                resultCoeffs[i + j] += coeffs[i] * other.coeffs[j];
            }
        }

        return Polynomial(resultCoeffs);
    }

    Polynomial operator*(float scalar) const {
        vector<float> resultCoeffs(coeffs.size(), 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] = coeffs[i] * scalar;
        }

        return Polynomial(resultCoeffs);
    }

    Polynomial operator/(float scalar) const {
        vector<float> resultCoeffs(coeffs.size(), 0);

        for (int i = 0; i < coeffs.size(); ++i) {
            resultCoeffs[i] = coeffs[i] / scalar;
        }

        return Polynomial(resultCoeffs);
    }

    void print() const {
        bool isFirst = true;
        for (int i = coeffs.size() - 1; i >= 0; --i) {
            if (!isFirst && coeffs[i] > 1e-5) {
                cout << " + ";
            } else if (coeffs[i] < -1e-5) {
                cout << " - ";
            } else if (coeffs[i] <= 1e-5 && coeffs[i] >= -1e-5) {
                continue;
            }

            if (i == 0 && coeffs[i] != 0){
                coeffs[i] > 0 ? cout << coeffs[i] : cout << -coeffs[i];
            } else if (i == 1 && coeffs[i] != 0) {
                coeffs[i] > 0 ? cout << coeffs[i] << "x" : cout << -coeffs[i] << "x";
                isFirst = false;
            } else if (coeffs[i] != 0) {
                coeffs[i] > 0 ? cout << coeffs[i] << "x^" << i : cout << -coeffs[i] << "x^" << i;
                isFirst = false;
            }
        }
        cout << endl;
    }

    void print(std::ofstream& outFile) const {
        bool isFirst = true;
        for (int i = coeffs.size() - 1; i >= 0; --i) {
            if (!isFirst && coeffs[i] > 1e-5) {
                outFile << " + ";
            } else if (coeffs[i] < -1e-5) {
                outFile << " - ";
            } else if (coeffs[i] <= 1e-5 && coeffs[i] >= -1e-5) {
                continue;
            }

            if (i == 0 && coeffs[i] != 0){
                coeffs[i] > 0 ? outFile << coeffs[i] : outFile << -coeffs[i];
            } else if (i == 1 && coeffs[i] != 0) {
                coeffs[i] > 0 ? outFile << coeffs[i] << "x" : outFile << -coeffs[i] << "x";
                isFirst = false;
            } else if (coeffs[i] != 0) {
                coeffs[i] > 0 ? outFile << coeffs[i] << "x^" << i : outFile << -coeffs[i] << "x^" << i;
                isFirst = false;
            }
        }
        outFile << std::endl;
    }
};

Polynomial getLkt(int k, vector<float> xi) {
    vector<float> symbolPoint = {0, 1};
    vector<float> symbolPoint2 = {1};
    Polynomial xSymbol(symbolPoint);
    Polynomial result(symbolPoint2);

    for (int i = 0; i < xi.size(); ++i) {
        if (i != k) {
            Polynomial temp((xSymbol - xi[i]) / (xi[k] - xi[i]));
            result = result * temp;
        }
    }

    return result;
}

Polynomial getPnt(vector<float> xi, vector<float> yi) {
    vector<float> symbolPoint = {0};
    Polynomial result(symbolPoint);

    for (int i = 0; i < xi.size(); ++i) {
        Polynomial temp(getLkt(i, xi) * yi[i]);
        result = result + temp;
    }
    return result;
}

int main() {
    int N, x, y;
    string inputFileName, outputFileName;
    std::vector<float> xVector, yVector;

    cout << "Enter the name/path of the input file: ";
    cin >> inputFileName;
    cout << "Enter the name/path of the output file: ";
    cin >> outputFileName;
    
    std::ifstream inputFile(inputFileName);

    if (!inputFile) {
        std::cerr << "Error opening the file." << std::endl;
        return 1;
    }

    inputFile >> N;

    for (int i = 0; i < N + 1; ++i) {
        inputFile >> x >> y;
        xVector.push_back(x);
        yVector.push_back(y);
    }

    inputFile.close();

    Polynomial result = getPnt(xVector, yVector);

    std::ofstream outFile(outputFileName);
    if (!outFile) {
        std::cerr << "Error opening output.txt!" << std::endl;
        return 1;
    }

    result.print(outFile);
    result.print();

    return 0;
}
