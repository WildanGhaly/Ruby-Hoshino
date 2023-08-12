# Mathematical Expression Evaluator in Zig

This Zig program provides a mathematical expression evaluator that accepts mathematical expressions as input and computes the result using bitwise operations. The program performs addition, subtraction, multiplication, division, and exponentiation operations without using traditional arithmetic operations (+, -, *, /).

## Table of Contents

- [Overview](#overview)
- [Usage](#usage)
- [Supported Operations](#supported-operations)
- [How It Works](#how-it-works)
- [Contributing](#contributing)

## Overview

This Zig program offers an interactive command-line interface (CLI) that allows users to input mathematical expressions as strings and get the computed result. The computations are performed using bitwise operations for addition, subtraction, multiplication, division, and exponentiation.

## Development Environment

The program was developed using the Zig programming language, version 0.11.0, on the Ubuntu 20.04 operating system.

Developers interested in exploring the Zig programming language and its capabilities can refer to the [Zig documentation](https://ziglang.org/documentation/0.11.0/). The combination of Zig 0.11.0 and Ubuntu 20.04 lays the foundation for a robust and efficient development experience.

Please note that using the recommended Zig version and operating system can help ensure optimal performance and compatibility when working with this program.

## Usage

1. **Build the Program:** Ensure you have the Zig compiler installed. Compile the program using the following command:
   
   ```bash
   zig build-exe calculator.zig
   ```
2. **Run the Program:** Execute the compiled program:
    ```bash
    ./calculator
    ```
3. **Input Mathematical Expression:** The program will prompt you to input a mathematical expression. Enter a valid expression, such as 10 + 5, and press Enter.
4. **View Result:** The program will display the computed result of the expression, calculated using bitwise operations.

## Supported Operations
The program supports the following operations:

- Addition (+)
- Subtraction (-)
- Multiplication (*)
- Division (/)
- Exponentiation (^)

## How It Works
The program utilizes bitwise operations to perform mathematical calculations, such as addition, subtraction, multiplication, division, and exponentiation. Instead of using traditional arithmetic operators (+, -, *, /), it employs bitwise AND, XOR, and shifts to achieve the desired results.

Here's a brief explanation of how each operation is implemented using bitwise operations:

- **Addition:** The addition function uses bitwise XOR and AND operations to perform binary addition without carries.

- **Subtraction:** The subtraction function leverages the addition function to calculate subtraction by adding the complement of the second operand and 1.

- **Multiplication:** The multiplication function employs bitwise AND, XOR, and left shifts to perform binary multiplication by repeatedly adding the multiplicand shifted according to the multiplier's bits.

- **Division:** The division function calculates division using bitwise operations, iterating through each bit of the dividend and shifting the divisor while updating the quotient.

- **Exponentiation:** The power function calculates exponentiation using bitwise operations, repeatedly multiplying the base by itself according to the bits of the exponent.

## Contributing
Contributions are welcome! If you find any issues, have ideas for improvements, or want to add new features, feel free to create a pull request.
