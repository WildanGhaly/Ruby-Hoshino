import java.io.File

class Polynomial(private val coeffs: List<Float>) {

    fun degree(): Int = coeffs.size - 1

    operator fun get(idx: Int): Float = coeffs[idx]

    operator fun plus(other: Polynomial): Polynomial {
        val maxSize = maxOf(coeffs.size, other.coeffs.size)
        val resultCoeffs = MutableList(maxSize) { 0f }

        for (i in coeffs.indices) {
            resultCoeffs[i] += coeffs[i]
        }

        for (i in other.coeffs.indices) {
            resultCoeffs[i] += other.coeffs[i]
        }

        return Polynomial(resultCoeffs)
    }

    operator fun plus(scalar: Float): Polynomial {
        val resultCoeffs = coeffs.toMutableList()

        resultCoeffs[0] += scalar

        return Polynomial(resultCoeffs)
    }

    operator fun minus(other: Polynomial): Polynomial {
        val maxSize = maxOf(coeffs.size, other.coeffs.size)
        val resultCoeffs = MutableList(maxSize) { 0f }

        for (i in coeffs.indices) {
            resultCoeffs[i] += coeffs[i]
        }

        for (i in other.coeffs.indices) {
            resultCoeffs[i] -= other.coeffs[i]
        }

        return Polynomial(resultCoeffs)
    }

    operator fun minus(scalar: Float): Polynomial {
        val resultCoeffs = coeffs.toMutableList()

        resultCoeffs[0] -= scalar

        return Polynomial(resultCoeffs)
    }

    operator fun times(other: Polynomial): Polynomial {
        val resultSize = coeffs.size + other.coeffs.size - 1
        val resultCoeffs = MutableList(resultSize) { 0f }

        for (i in coeffs.indices) {
            for (j in other.coeffs.indices) {
                resultCoeffs[i + j] += coeffs[i] * other.coeffs[j]
            }
        }

        return Polynomial(resultCoeffs)
    }

    operator fun times(scalar: Float): Polynomial {
        val resultCoeffs = coeffs.map { it * scalar }

        return Polynomial(resultCoeffs)
    }

    operator fun div(scalar: Float): Polynomial {
        val resultCoeffs = coeffs.map { it / scalar }

        return Polynomial(resultCoeffs)
    }

    fun print() {
        var isFirst = true
        for (i in coeffs.size - 1 downTo 0) {
            if (!isFirst && coeffs[i] > 0) {
                print(" + ")
            } else if (coeffs[i] < 0) {
                print(" - ")
            } else if (coeffs[i] == 0f) {
                continue
            }

            if (i == 0 && coeffs[i] != 0f) {
                print(if (coeffs[i] > 0) coeffs[i] else -coeffs[i])
            } else if (i == 1 && coeffs[i] != 0f) {
                print(if (coeffs[i] > 0) "${coeffs[i]}x" else "${-coeffs[i]}x")
                isFirst = false
            } else if (coeffs[i] != 0f) {
                print(if (coeffs[i] > 0) "${coeffs[i]}x^$i" else "${-coeffs[i]}x^$i")
                isFirst = false
            }
        }
        println()
    }
}

fun getLkt(k: Int, xi: List<Float>): Polynomial {
    val symbolPoint = listOf(0f, 1f)
    val symbolPoint2 = listOf(1f)
    val xSymbol = Polynomial(symbolPoint)
    var result = Polynomial(symbolPoint2)

    for (i in xi.indices) {
        if (i != k) {
            val temp = (xSymbol - xi[i]) / (xi[k] - xi[i])
            result *= temp
        }
    }

    return result
}

fun getPnt(xi: List<Float>, yi: List<Float>): Polynomial {
    val symbolPoint = listOf(0f)
    var result = Polynomial(symbolPoint)

    for (i in xi.indices) {
        val temp = getLkt(i, xi) * yi[i]
        result += temp
    }
    return result
}

fun main() {
    print("Enter the name/path of the input file: ")
    val inputFileName = readLine() ?: return
    print("Enter the name/path of the output file: ")
    val outputFileName = readLine() ?: return

    val file = File(inputFileName)
    val lines = file.readLines()

    val N = lines[0].toInt()
    val xVector = mutableListOf<Float>()
    val yVector = mutableListOf<Float>()

    for (i in 1..N) {
        val (x, y) = lines[i].split(" ").map { it.toFloat() }
        xVector.add(x)
        yVector.add(y)
    }

    val result = getPnt(xVector, yVector)

    val outFile = File(outputFileName)

    print(result)
//    outFile.bufferedWriter().use { writer ->
//        result.print(writer)
//    }
}
