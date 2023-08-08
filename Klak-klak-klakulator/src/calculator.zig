const std = @import("std");

// zig tidak dapat menerima integer sebagai boolean, 
// A ^ 0 menghasilkan 0 jika A = 0
// pada kode berikut digunakan operasi comparison sebagai gantinya
// mohon pengertiannya

fn addition(a: i32, b: i32) i32 {
    var carry: i32 = 0;
    var result: i32 = a;
    var result2: i32 = b;

    while (result2 != 0) {
        carry = result & result2;
        result = result ^ result2;
        result2 = carry << 1;
    }

    return result;
}

fn subtraction(a: i32, b: i32) i32 {
    return addition(a, addition(~b, 1));
}

fn multiplication(a: i32, b: i32) i32 {
    var result: i32 = 0;
    var mask: i32 = 1;
    var aTemp: i32 = a;

    while (mask != 0) {
        if (b & mask != 0) {
            result = addition(result, aTemp);
        }
        aTemp <<= 1;
        mask <<= 1;
    }

    return result;
}

fn division(dividend: i32, divisor: i32) i32 {
    
    const testZero: bool = (divisor ^ 0 != 0); // jika zig bisa menerima int sebagai bool maka != 0 tidak diperlukan. mohon pengertiannya
    if ((testZero)) {
        // Bukan dibagi NOL
    } else {
        // division by 0 is undefined
        // std.io.getStdOut().writeAll("Division by zero is undefined\n");
        return -2147483648; // Return error value
    }

    var quotient: i32 = 0;
    var remainder: u32 = 0;

    // Calculate the sign of the result
    var sign: i32 = 1;
    
    const minusser: i32 = addition(1, 0x7FFFFFFF);
    if (((dividend & minusser) ^ (divisor & minusser)) != 0) { // jika zig bisa menerima int sebagai bool maka != 0 tidak diperlukan. mohon pengertiannya
        sign = subtraction(0, 1);
    } else {
        // hasil positif
    }

    // Jadikan keduanya positif


    var tempDividend: i32 = 0;
    var tempDivisor: i32 = 0;

    // zig tidak bisa melakukan casting langsung dari i32 ke u32
    // maka digunakan @intCast untuk melakukan casting secara manual    
    // mohon pengertiannya
    if (dividend < 0) {  // pengecekan negatif bisa dicari dengan melakukan N & 0x80000000, tetapi hasilnya bukan bool sehingga tidak bisa di zig
        tempDividend = addition(~dividend, 1);
    } else {
        tempDividend = dividend;
    }

    if (divisor < 0) { // pengecekan negatif bisa dicari dengan melakukan N & 0x80000000, tetapi hasilnya bukan bool sehingga tidak bisa di zig
        tempDivisor = addition(~divisor, 1);
    } else {
        tempDivisor = divisor;
    }

    var u_dividend: u32 = @intCast(tempDividend);
    var u_divisor: u32 = @intCast(tempDivisor);

    var i: u5 = 31;
    var temp: i32 = 1;
    while (i > 0) {
        
        if ((u_dividend >> i) >= u_divisor) {
            remainder = u_dividend - (u_divisor << i);
            u_dividend = remainder;
            quotient |= (temp << i);
        }

        var j : i32 = subtraction(i, 1);
        var k : u5 = @intCast(j);
        i = k;
        
    }

    if ((u_dividend >> 0) >= u_divisor) {
            remainder = u_dividend - (u_divisor << 0);
            u_dividend = remainder;
            quotient |= (temp << 0);
        }

    return multiplication(quotient, sign);
}

fn power(a: i32, b: i32) i32 {
    var result: i32 = 1;
    var mask: i32 = 1;
    var aTemp: i32 = a;

    while (mask != 0) {
        if (b & mask != 0) {
            result = multiplication(result, aTemp);
        }
        aTemp = multiplication(aTemp, aTemp);
        mask <<= 1;
    }

    return result;
}

fn compute (a: i32, b: i32, operator: u8) i32 {
    switch (operator) {
        '+' => return addition(a, b),
        '-' => return subtraction(a, b),
        '*' => return multiplication(a, b),
        '/' => return division(a, b),
        '^' => return power(a, b),
        else => return 0,
    }
}

fn convertToInteger (a: []const u8) i32 {
    if (std.fmt.parseInt(i32, a, 10)) |result| {
        return result;
    } else |err| switch (err) {
        error.Overflow => return 0,
        else => return 0,
    }
}

fn ask_user() !i32 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var line_buffer = std.ArrayList(u8).init(allocator);
    defer line_buffer.deinit();


    try stdout.print("Input mathematical expression: ", .{});

    try stdout.writeAll("? ");
    stdin.readUntilDelimiterArrayList(&line_buffer, '\n', 4096) catch |err| switch (err) {
        error.EndOfStream => return 0,
        else => |e| return e,
    };

    const line = std.mem.trim(u8, line_buffer.items, "\t ");

    const token = std.mem.tokenize(u8, line, " ");


    var i: usize = 0;
    var j: usize = 0;
    var isNegative: bool = false;

    var temp: [10]u8 = undefined ;

    // The first number
    while (i < (token.buffer.len) and token.buffer[i] != 32) {
        if (token.buffer[i] >= '0' and token.buffer[i] <= '9') {
            temp[j] = token.buffer[i];
            j += 1;
        } else if (token.buffer[i] == '-') {
            temp[j] = token.buffer[i];
            isNegative = true;
        } else {
            break;
        }
        i += 1;
    }

    var currentNumber = convertToInteger(temp[0..j]);
    if (isNegative) {
        currentNumber = -currentNumber;
    }

    while (i < (token.buffer.len) and token.buffer[i] == 32) {
        i += 1;
    }

    temp = undefined; j = 0;
    var currentOperator: u8 = 0;
    var isNumber: bool = false;
    var secondaryNumber: i32 = 0;
    var notAlone: bool = false;
    isNegative = false;

    while (i < (token.buffer.len)) {
        if (token.buffer[i] >= '0' and token.buffer[i] <= '9') {
            temp[j] = token.buffer[i];
            j += 1;
            isNumber = false;
        } else if (token.buffer[i] == '-' and isNumber) {
            temp[j] = token.buffer[i];
            isNegative = true;
        } else if (token.buffer[i] == '-' or token.buffer[i] == '+' or token.buffer[i] == '*' or token.buffer[i] == '/' or token.buffer[i] == '^') {
            notAlone = true;
            if (currentOperator != 0){
                secondaryNumber = convertToInteger(temp[0..j]);
                if (isNegative) {
                    secondaryNumber = -secondaryNumber;
                    isNegative = false;
                }

                currentNumber = compute(currentNumber, secondaryNumber, currentOperator);
            } else {
                // berarti masih awal (ex. 10 +)
            }
            temp = undefined; j = 0;
            isNumber = true;
            currentOperator = token.buffer[i];
        } else if (token.buffer[i] == 32) {
            
        }
        i+=1;
    }


    var intParsed = convertToInteger(temp[0..j]);
    if (isNegative) {
        intParsed = -intParsed;
    }

    if (notAlone){
        currentNumber = compute(currentNumber, intParsed, currentOperator);
    }

    try stdout.print("Result: '{}'\n", .{currentNumber});


    return 0;
}


pub fn main() !void {
    const input = try ask_user();
    _ = input;
}