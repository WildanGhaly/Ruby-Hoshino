<?php

class Polynomial
{
    private $coeffs;

    public function __construct($coefficients)
    {
        $this->coeffs = $coefficients;
    }

    public function degree()
    {
        return count($this->coeffs) - 1;
    }

    public function getCoefficients()
    {
        return $this->coeffs;
    }

    public function getCoefficient($idx)
    {
        return $this->coeffs[$idx];
    }

    public function setCoefficient($idx, $value)
    {
        $this->coeffs[$idx] = $value;
    }

    public function add(Polynomial $other)
    {
        $maxSize = max(count($this->coeffs), count($other->coeffs));
        $resultCoeffs = array_fill(0, $maxSize, 0);

        for ($i = 0; $i < count($this->coeffs); ++$i) {
            $resultCoeffs[$i] += $this->coeffs[$i];
        }

        for ($i = 0; $i < count($other->coeffs); ++$i) {
            $resultCoeffs[$i] += $other->coeffs[$i];
        }

        return new Polynomial($resultCoeffs);
    }

    public function addScalar($scalar)
    {
        $resultCoeffs = $this->coeffs;
        $resultCoeffs[0] += $scalar;

        return new Polynomial($resultCoeffs);
    }

    public function subtract(Polynomial $other)
    {
        $maxSize = max(count($this->coeffs), count($other->coeffs));
        $resultCoeffs = array_fill(0, $maxSize, 0);

        for ($i = 0; $i < count($this->coeffs); ++$i) {
            $resultCoeffs[$i] += $this->coeffs[$i];
        }

        for ($i = 0; $i < count($other->coeffs); ++$i) {
            $resultCoeffs[$i] -= $other->coeffs[$i];
        }

        return new Polynomial($resultCoeffs);
    }

    public function subtractScalar($scalar)
    {
        $resultCoeffs = $this->coeffs;
        $resultCoeffs[0] -= $scalar;

        return new Polynomial($resultCoeffs);
    }

    public function multiply(Polynomial $other)
    {
        $resultSize = count($this->coeffs) + count($other->coeffs) - 1;
        $resultCoeffs = array_fill(0, $resultSize, 0);

        for ($i = 0; $i < count($this->coeffs); ++$i) {
            for ($j = 0; $j < count($other->coeffs); ++$j) {
                $resultCoeffs[$i + $j] += $this->coeffs[$i] * $other->coeffs[$j];
            }
        }

        return new Polynomial($resultCoeffs);
    }

    public function multiplyScalar($scalar)
    {
        $resultCoeffs = [];

        foreach ($this->coeffs as $coeff) {
            $resultCoeffs[] = $coeff * $scalar;
        }

        return new Polynomial($resultCoeffs);
    }

    public function divideScalar($scalar)
    {
        $resultCoeffs = [];

        foreach ($this->coeffs as $coeff) {
            $resultCoeffs[] = $coeff / $scalar;
        }

        return new Polynomial($resultCoeffs);
    }

    public function print()
    {
        $nearlyZero = 1e-10;
        $isFirst = true;
        for ($i = count($this->coeffs) - 1; $i >= 0; --$i) {
            if (!$isFirst && $this->coeffs[$i] > $nearlyZero) {
                print " + ";
            } else if ($this->coeffs[$i] < -$nearlyZero) {
                print " - ";
            } else if ($this->coeffs[$i] < $nearlyZero && $this->coeffs[$i] > -$nearlyZero) {
                continue;
            }

            if ($i == 0 && ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero)) {
                print $this->coeffs[$i] > 0 ? $this->coeffs[$i] : -$this->coeffs[$i];
            } else if ($i == 1 && ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero)) {
                print $this->coeffs[$i] > 0 ? $this->coeffs[$i] . "x" : -$this->coeffs[$i] . "x";
                $isFirst = false;
            } else if ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero) {
                print $this->coeffs[$i] > 0 ? $this->coeffs[$i] . "x^" . $i : -$this->coeffs[$i] . "x^" . $i;
                $isFirst = false;
            }
        }
        print PHP_EOL;
    }

    public function writeToTextFile($filename)
    {
        $nearlyZero = 1e-10;
        $isFirst = true;

        $fileHandle = fopen($filename, 'w');

        for ($i = count($this->coeffs) - 1; $i >= 0; --$i) {
            if (!$isFirst && $this->coeffs[$i] > $nearlyZero) {
                fwrite($fileHandle, " + ");
            } else if ($this->coeffs[$i] < -$nearlyZero) {
                fwrite($fileHandle, " - ");
            } else if ($this->coeffs[$i] < $nearlyZero && $this->coeffs[$i] > -$nearlyZero) {
                continue;
            }

            if ($i == 0 && ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero)) {
                fwrite($fileHandle, $this->coeffs[$i] > 0 ? $this->coeffs[$i] : -$this->coeffs[$i]);
            } else if ($i == 1 && ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero)) {
                fwrite($fileHandle, $this->coeffs[$i] > 0 ? $this->coeffs[$i] . "x" : -$this->coeffs[$i] . "x");
                $isFirst = false;
            } else if ($this->coeffs[$i] < -$nearlyZero || $this->coeffs[$i] > $nearlyZero) {
                fwrite($fileHandle, $this->coeffs[$i] > 0 ? $this->coeffs[$i] . "x^" . $i : -$this->coeffs[$i] . "x^" . $i);
                $isFirst = false;
            }
        }

        fwrite($fileHandle, PHP_EOL);
        fclose($fileHandle);
    }

}

function getLkt($k, $xi)
{
    $symbolPoint = [0, 1];
    $symbolPoint2 = [1];
    $xSymbol = new Polynomial($symbolPoint);
    $result = new Polynomial($symbolPoint2);

    for ($i = 0; $i < count($xi); ++$i) {
        if ($i != $k) {
            $temp = $xSymbol->subtractScalar($xi[$i])->divideScalar($xi[$k] - $xi[$i]);
            $result = $result->multiply($temp);
        }
    }

    return $result;
}

function getPnt($xi, $yi)
{
    $symbolPoint = [0];
    $result = new Polynomial($symbolPoint);

    for ($i = 0; $i < count($xi); ++$i) {
        $temp = getLkt($i, $xi)->multiplyScalar($yi[$i]);
        $result = $result->add($temp);
    }
    return $result;
}

function readPointsFromFile($filename) {
    $xVector = [];
    $yVector = [];

    if (($handle = fopen($filename, "r")) !== false) {
        // Read the first line to get the number of points
        $N = intval(trim(fgets($handle)));

        for ($i = 0; $i < $N + 1; $i++) {
            $line = trim(fgets($handle));
            list($x, $y) = explode(" ", $line);

            // Add the points to the vectors
            $xVector[] = intval($x);
            $yVector[] = intval($y);
        }

        fclose($handle);
    }

    return ['xVector' => $xVector, 'yVector' => $yVector];
}


$fileInput;

echo "Enter the file input name/path: ";
fscanf(STDIN, "%s", $fileInput);

echo "Enter the file output name/path: ";
fscanf(STDIN, "%s", $fileOutput);

$result = readPointsFromFile($fileInput);

$xVector = $result['xVector'];
$yVector = $result['yVector'];

$result = getPnt($xVector, $yVector);
$result->print();
$result->writeToTextFile($fileOutput);

?>
