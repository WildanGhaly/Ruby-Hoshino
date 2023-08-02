package main

import (
	"fmt"
	"os"
	"bufio"
	"strconv"
	"strings"
)

type Polynomial struct {
    coeffs []float64
}

func NewPolynomial(coefficients []float64) *Polynomial {
    return &Polynomial{coeffs: coefficients}
}

// func (p *Polynomial) degree() int {
//     return len(p.coeffs) - 1
// }

func (p *Polynomial) add(other *Polynomial) *Polynomial {
   	maxSize := max(len(p.coeffs), len(other.coeffs))
   	resultCoeffs := make([]float64, maxSize)

   	for i := 0; i < len(p.coeffs); i++ {
   		resultCoeffs[i] += p.coeffs[i]
   	}

   	for i := 0; i < len(other.coeffs); i++ {
   		resultCoeffs[i] += other.coeffs[i]
   	}

   	return NewPolynomial(resultCoeffs)
}

func (p *Polynomial) subtract(other *Polynomial) *Polynomial {
   	maxSize := max(len(p.coeffs), len(other.coeffs))
   	resultCoeffs := make([]float64, maxSize)

   	for i := 0; i < len(p.coeffs); i++ {
   		resultCoeffs[i] += p.coeffs[i]
   	}

   	for i := 0; i < len(other.coeffs); i++ {
   		resultCoeffs[i] -= other.coeffs[i]
   	}

   	return NewPolynomial(resultCoeffs)
}

func (p *Polynomial) multiply(other *Polynomial) *Polynomial {
   	resultSize := len(p.coeffs) + len(other.coeffs) - 1
   	resultCoeffs := make([]float64, resultSize)

   	for i := 0; i < len(p.coeffs); i++ {
   		for j := 0; j < len(other.coeffs); j++ {
   			resultCoeffs[i+j] += p.coeffs[i] * other.coeffs[j]
   		}
   	}

   	return NewPolynomial(resultCoeffs)
}

func (p *Polynomial) multiplyScalar(scalar float64) *Polynomial {
   	resultCoeffs := make([]float64, len(p.coeffs))

   	for i := 0; i < len(p.coeffs); i++ {
   		resultCoeffs[i] = p.coeffs[i] * scalar
   	}

   	return NewPolynomial(resultCoeffs)
}

func (p *Polynomial) divideScalar(scalar float64) *Polynomial {
   	resultCoeffs := make([]float64, len(p.coeffs))

   	for i := 0; i < len(p.coeffs); i++ {
   		resultCoeffs[i] = float64(p.coeffs[i]) / float64(scalar)
   	}

   	return NewPolynomial(resultCoeffs)
}

func (p *Polynomial) String() string {
   	degree := len(p.coeffs) - 1
   	result := ""

   	for i := degree; i >= 0; i-- {
   		coeff := p.coeffs[i]
   		if coeff < 1.0e-10 && coeff > -1.0e-10 { // a very small number
   			continue
   		}

   		if i == 0 {
			if coeff >= 0 {
				result += fmt.Sprintf(" + %.5f", coeff)	
			} else {
				result += fmt.Sprintf(" - %.5f", -coeff)
			}
   		} else if i == 1 {
   			if coeff >= 0 {
   				result += fmt.Sprintf(" + %.5fx", coeff)
   			} else {
   				result += fmt.Sprintf(" - %.5fx", -coeff)
   			}
   		} else {
   			if coeff >= 0 {
   				result += fmt.Sprintf(" + %.5fx^%d", coeff, i)
   			} else {
   				result += fmt.Sprintf(" - %.5fx^%d", -coeff, i)
   			}
   		}
   	}

   	if result == "" {
   		return "0"
   	}

   	return result
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func getLkt(k int, xi []float64) *Polynomial {
    symbolPoint := []float64{0, 1}
    symbolPoint2 := []float64{1}
    xSymbol := NewPolynomial(symbolPoint)
    result := NewPolynomial(symbolPoint2)

    for i := 0; i < len(xi); i++ {
        if i != k {
            temp := xSymbol.subtract(NewPolynomial([]float64{xi[i]})).divideScalar(xi[k] - xi[i])
			result = result.multiply(temp)
        }
    }

    return result
}

func getPnt(xi, yi []float64) *Polynomial {
    symbolPoint := []float64{0}
    result := NewPolynomial(symbolPoint)

    for i := 0; i < len(xi); i++ {
        temp := getLkt(i, xi).multiplyScalar(yi[i])
        result = result.add(temp)
    }
    return result
}

func readPointsFromFile(fileName string) ([]float64, []float64, error) {
	file, err := os.Open(fileName)
	if err != nil {
		return nil, nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	if !scanner.Scan() {
		return nil, nil, fmt.Errorf("empty file")
	}

	N, err := strconv.Atoi(scanner.Text())
	if err != nil {
		return nil, nil, err
	}

	xVector := make([]float64, 0, N + 1)
	yVector := make([]float64, 0, N + 1)

	for i := 0; i < N + 1; i++ {
		if !scanner.Scan() {
			return nil, nil, fmt.Errorf("file ended prematurely")
		}

		pointLine := scanner.Text()
		pointCoords := strings.Fields(pointLine)

		if len(pointCoords) != 2 {
			return nil, nil, fmt.Errorf("invalid point format")
		}

		x, err := strconv.ParseFloat(pointCoords[0], 64)
		if err != nil {
			return nil, nil, err
		}

		y, err := strconv.ParseFloat(pointCoords[1], 64)
		if err != nil {
			return nil, nil, err
		}

		xVector = append(xVector, x)
		yVector = append(yVector, y)
	}

	return xVector, yVector, nil
}

func main() {
    var inputFileName, outputFileName string

    fmt.Print("Enter the name/path of the input file: ")
    fmt.Scan(&inputFileName)
    fmt.Print("Enter the name/path of the output file: ")
    fmt.Scan(&outputFileName)

	fileName := inputFileName
	xVectors, yVectors, err := readPointsFromFile(fileName)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	fmt.Println("xVector:", xVectors)
	fmt.Println("yVector:", yVectors)

	result := getPnt(xVectors, yVectors)

	fmt.Println("result:", result)

	outFile, err := os.Create(outputFileName)
    if err != nil {
        fmt.Println("Error opening output.txt!")
        return
    }
    defer outFile.Close()

    fmt.Fprintln(outFile, result)
}
