const fs = require('fs');
const readline = require('readline');

class Polynomial {
    constructor(coefficients) {
        this.coeffs = coefficients;
    }

    degree() {
        return this.coeffs.length - 1;
    }

    add(other) {
        const maxSize = Math.max(this.coeffs.length, other.coeffs.length);
        const resultCoeffs = new Array(maxSize).fill(0);

        for (let i = 0; i < this.coeffs.length; i++) {
            resultCoeffs[i] += this.coeffs[i];
        }

        for (let i = 0; i < other.coeffs.length; i++) {
            resultCoeffs[i] += other.coeffs[i];
        }

        return new Polynomial(resultCoeffs);
    }

    addScalar(scalar) {
        const resultCoeffs = this.coeffs.slice();
        resultCoeffs[0] += scalar;
        return new Polynomial(resultCoeffs);
    }

    subtract(other) {
        const maxSize = Math.max(this.coeffs.length, other.coeffs.length);
        const resultCoeffs = new Array(maxSize).fill(0);

        for (let i = 0; i < this.coeffs.length; i++) {
            resultCoeffs[i] += this.coeffs[i];
        }

        for (let i = 0; i < other.coeffs.length; i++) {
            resultCoeffs[i] -= other.coeffs[i];
        }

        return new Polynomial(resultCoeffs);
    }

    subtractScalar(scalar) {
        const resultCoeffs = this.coeffs.slice();
        resultCoeffs[0] -= scalar;
        return new Polynomial(resultCoeffs);
    }

    multiply(other) {
        const resultSize = this.coeffs.length + other.coeffs.length - 1;
        const resultCoeffs = new Array(resultSize).fill(0);

        for (let i = 0; i < this.coeffs.length; i++) {
            for (let j = 0; j < other.coeffs.length; j++) {
                resultCoeffs[i + j] += this.coeffs[i] * other.coeffs[j];
            }
        }

        return new Polynomial(resultCoeffs);
    }

    multiplyScalar(scalar) {
        return new Polynomial(this.coeffs.map((coeff) => coeff * scalar));
    }

    divideScalar(scalar) {
        return new Polynomial(this.coeffs.map((coeff) => coeff / scalar));
    }

    evaluate(x) {
        let result = 0;
        for (let i = 0; i < this.coeffs.length; i++) {
            result += this.coeffs[i] * Math.pow(x, i);
        }
        return result;
    }

    print() {
        let output = '';
        let isFirst = true;
        const eps = 1e-10;
        for (let i = this.coeffs.length - 1; i >= 0; i--) {
            const coeff = this.coeffs[i];
    
            if (coeff < -eps || coeff > eps) {
                if (!isFirst && coeff > 0) {
                    output += ' + ';
                } else if (coeff < 0) {
                    output += ' - ';
                } 
    
                if (i === 0) {
                    output += Math.abs(coeff);
                } else if (i === 1) {
                    output += Math.abs(coeff) + 'x';
                    isFirst = false;
                } else {
                    output += Math.abs(coeff) + 'x^' + i;
                    isFirst = false;
                }
            }
        }
        console.log(output);
    }

    writeToFile(fileName) {
        let output = '';
        let isFirst = true;
        const eps = 1e-10;
        for (let i = this.coeffs.length - 1; i >= 0; i--) {
            const coeff = this.coeffs[i];
    
            if (coeff < -eps || coeff > eps) {
                if (!isFirst && coeff > 0) {
                    output += ' + ';
                } else if (coeff < 0) {
                    output += ' - ';
                }
    
                if (i === 0) {
                    output += Math.abs(coeff);
                } else if (i === 1) {
                    output += Math.abs(coeff) + 'x';
                    isFirst = false;
                } else {
                    output += Math.abs(coeff) + 'x^' + i;
                    isFirst = false;
                }
            }
        }
    
        fs.writeFile(fileName, output, (err) => {
            if (err) {
                console.error('Error writing to file:', err);
            } else {
                console.log('Content has been written to the file:', fileName);
            }
        });
    }
    
}

function getLkt(k, xi) {
    const symbolPoint = [0, 1];
    const symbolPoint2 = [1];
    const xSymbol = new Polynomial(symbolPoint);
    let result = new Polynomial(symbolPoint2);

    for (let i = 0; i < xi.length; i++) {
        if (i !== k) {
            const temp = xSymbol.subtractScalar(xi[i]).divideScalar(xi[k] - xi[i]);
            // console.log("Temp ", temp);
            result = result.multiply(temp);
        }
    }
    // console.log("Lkt ", result);
    return result;
}

function getPnt(xi, yi) {
    const symbolPoint = [0];
    let result = new Polynomial(symbolPoint);

    for (let i = 0; i < xi.length; i++) {
        const temp = getLkt(i, xi).multiplyScalar(yi[i]);
        result = result.add(temp);
    }

    return result;
}

function readPointsFromFile(filePath) {
    const fileContents = fs.readFileSync(filePath, 'utf-8');
    const lines = fileContents.split('\n');
    const n = parseInt(lines[0]);
    const xVector = [];
    const yVector = [];

    for (let i = 1; i < n + 2; i++) {
        const point = lines[i].trim().split(' ');
        const x = parseInt(point[0]);
        const y = parseInt(point[1]);
        xVector.push(x);
        yVector.push(y);
    }

    return { xVector, yVector };
}

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.question('Enter the path for input.txt: ', (inputFilePath) => {
    rl.question('Enter the path for output.txt: ', (outputFilePath) => {
        rl.close();

        const { xVector, yVector } = readPointsFromFile(inputFilePath);
        const result = getPnt(xVector, yVector);
        console.log('x =', xVector);
        console.log('y =', yVector);
        console.log('Result:');
        result.print();
        result.writeToFile(outputFilePath);

    });
});

// const { xVector, yVector } = readPointsFromFile("input.txt");
// const result = getPnt(xVector, yVector);
// result.writeToFile("output.txt");
