import sympy as sp

def getLkt (x, k, xi):
    lkt = 1
    for i in range(len(xi)):
        if i != k:
            lkt *= (x - xi[i]) / (xi[k] - xi[i])
    return lkt

def getPnt (x, xi, yi):
    pnt = 0
    for i in range(len(xi)):
        pnt += getLkt(x, i, xi) * yi[i]
    return pnt

def read_points_from_file(file_path):
    arrayX = []
    arrayY = []

    with open(file_path, 'r') as file:
        total_points = int(file.readline().strip()) + 1
        for _ in range(total_points):
            x, y = map(int, file.readline().strip().split())
            arrayX.append(x)
            arrayY.append(y)

    return arrayX, arrayY

if __name__ == "__main__":

    file_path = input("Masukkan path/nama file input: ")
    output_path = input("Masukkan path/nama file output: ")
    xi, yi = read_points_from_file(file_path)
    
    x = sp.symbols('x')

    polynomResult = getPnt(x, xi, yi)
    polynomResult = sp.expand(polynomResult).evalf(n = 5)

    with open(output_path, "w") as file:
        file.write(str(polynomResult))
        
    print("Hasil interpolasi polinom: ", polynomResult)
    print("Hasil interpolasi polinom tersimpan di file: ", output_path)