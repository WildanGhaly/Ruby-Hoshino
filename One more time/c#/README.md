# Interpolation Polynomial with C#

This C# script performs interpolation using a polynomial fitting method and saves the result to an output file. The code uses the [Lagrange Polynomial](https://en.wikipedia.org/wiki/Lagrange_polynomial) method to perform interpolation. The Lagrange Polynomial method is a type of [polynomial interpolation](https://en.wikipedia.org/wiki/Polynomial_interpolation).


## How to Use
1. Input File:
Prepare a text file containing the set of points you want to use for interpolation. The format of the file should be as follows:
```bash
<Total Number of Points - 1>
<x1> <y1>
<x2> <y2>
...
<xn> <yn>
<xn+1> <yn+1>

```
The first line specifies the total number of points - 1, and each subsequent line contains the x and y coordinates separated by spaces.
for example:
```bash
3
1 1
2 4
3 9
4 10
```

2. Running the Script:
- Ensure you have dotnet installed on your system.
- Download or clone the repository to your local machine.
- Open your terminal or command prompt.
- Navigate to the directory where you have placed the script files.
- Run the script using the following command:
```bash
cd PolynomialInterpolation
dotnet run
```
- Enter the path and name of the input file.
- Enter the path and name of the output file.

3. Output file:
The script will create the output file specified by the user and save the interpolated polynomial result in it.

4. Output console:
The script will print the interpolated polynomial result.

## Requirements
- [dotnet 7.x](https://dotnet.microsoft.com/download)
