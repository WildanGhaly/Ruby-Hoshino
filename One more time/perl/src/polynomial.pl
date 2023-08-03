use strict;
use warnings;

package Polynomial;

sub new {
    my ($class, $coefficients) = @_;
    my $self = { coeffs => $coefficients };
    bless $self, $class;
    return $self;
}

sub degree {
    my ($self) = @_;
    return scalar(@{ $self->{coeffs} }) - 1;
}

sub getCoefficients {
    my ($self) = @_;
    return $self->{coeffs};
}

sub getCoefficient {
    my ($self, $idx) = @_;
    return $self->{coeffs}[$idx];
}

sub setCoefficient {
    my ($self, $idx, $value) = @_;
    $self->{coeffs}[$idx] = $value;
}

sub add {
    my ($self, $other) = @_;
    my $maxSize = scalar(@{ $self->{coeffs} }) > scalar(@{ $other->{coeffs} })
        ? scalar(@{ $self->{coeffs} })
        : scalar(@{ $other->{coeffs} });
    my @resultCoeffs = (0) x $maxSize;

    for my $i (0 .. scalar(@{ $self->{coeffs} }) - 1) {
        $resultCoeffs[$i] += $self->{coeffs}[$i];
    }

    for my $i (0 .. scalar(@{ $other->{coeffs} }) - 1) {
        $resultCoeffs[$i] += $other->{coeffs}[$i];
    }

    return Polynomial->new(\@resultCoeffs);
}

sub addScalar {
    my ($self, $scalar) = @_;
    my @resultCoeffs = @{ $self->{coeffs} };
    $resultCoeffs[0] += $scalar;
    return Polynomial->new(\@resultCoeffs);
}

sub subtract {
    my ($self, $other) = @_;
    my $maxSize = scalar(@{ $self->{coeffs} }) > scalar(@{ $other->{coeffs} })
        ? scalar(@{ $self->{coeffs} })
        : scalar(@{ $other->{coeffs} });
    my @resultCoeffs = (0) x $maxSize;

    for my $i (0 .. scalar(@{ $self->{coeffs} }) - 1) {
        $resultCoeffs[$i] += $self->{coeffs}[$i];
    }

    for my $i (0 .. scalar(@{ $other->{coeffs} }) - 1) {
        $resultCoeffs[$i] -= $other->{coeffs}[$i];
    }

    return Polynomial->new(\@resultCoeffs);
}

sub subtractScalar {
    my ($self, $scalar) = @_;
    my @resultCoeffs = @{ $self->{coeffs} };
    $resultCoeffs[0] -= $scalar;
    return Polynomial->new(\@resultCoeffs);
}

sub multiply {
    my ($self, $other) = @_;
    my $resultSize = scalar(@{ $self->{coeffs} }) + scalar(@{ $other->{coeffs} }) - 1;
    my @resultCoeffs = (0) x $resultSize;

    for my $i (0 .. scalar(@{ $self->{coeffs} }) - 1) {
        for my $j (0 .. scalar(@{ $other->{coeffs} }) - 1) {
            $resultCoeffs[$i + $j] += $self->{coeffs}[$i] * $other->{coeffs}[$j];
        }
    }

    return Polynomial->new(\@resultCoeffs);
}

sub multiplyScalar {
    my ($self, $scalar) = @_;
    my @resultCoeffs = map { $_ * $scalar } @{ $self->{coeffs} };
    return Polynomial->new(\@resultCoeffs);
}

sub divideScalar {
    my ($self, $scalar) = @_;
    my @resultCoeffs = map { $_ / $scalar } @{ $self->{coeffs} };
    return Polynomial->new(\@resultCoeffs);
}

sub print {
    my ($self) = @_;
    my $nearlyZero = 1e-10;
    my $isFirst = 1;

    for (my $i = scalar(@{ $self->{coeffs} }) - 1; $i >= 0; --$i) {
        if (!$isFirst && $self->{coeffs}[$i] > $nearlyZero) {
            print " + ";
        } elsif ($self->{coeffs}[$i] < -$nearlyZero) {
            print " - ";
        } elsif ($self->{coeffs}[$i] < $nearlyZero && $self->{coeffs}[$i] > -$nearlyZero) {
            next;
        }

        if ($i == 0 && ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero)) {
            print $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] : -$self->{coeffs}[$i];
        } elsif ($i == 1 && ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero)) {
            print $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] . "x" : -$self->{coeffs}[$i] . "x";
            $isFirst = 0;
        } elsif ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero) {
            print $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] . "x^" . $i : -$self->{coeffs}[$i] . "x^" . $i;
            $isFirst = 0;
        }
    }
    print "\n";
}

sub writeToTextFile {
    my ($self, $filename) = @_;
    my $nearlyZero = 1e-10;
    my $isFirst = 1;

    open my $fileHandle, '>', $filename or die $!;
    for (my $i = scalar(@{ $self->{coeffs} }) - 1; $i >= 0; --$i) {
        if (!$isFirst && $self->{coeffs}[$i] > $nearlyZero) {
            print $fileHandle " + ";
        } elsif ($self->{coeffs}[$i] < -$nearlyZero) {
            print $fileHandle " - ";
        } elsif ($self->{coeffs}[$i] < $nearlyZero && $self->{coeffs}[$i] > -$nearlyZero) {
            next;
        }

        if ($i == 0 && ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero)) {
            print $fileHandle $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] : -$self->{coeffs}[$i];
        } elsif ($i == 1 && ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero)) {
            print $fileHandle $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] . "x" : -$self->{coeffs}[$i] . "x";
            $isFirst = 0;
        } elsif ($self->{coeffs}[$i] < -$nearlyZero || $self->{coeffs}[$i] > $nearlyZero) {
            print $fileHandle $self->{coeffs}[$i] > 0 ? $self->{coeffs}[$i] . "x^" . $i : -$self->{coeffs}[$i] . "x^" . $i;
            $isFirst = 0;
        }
    }
    print $fileHandle "\n";
    close $fileHandle;
}

sub getLkt {
    my ($k, $xi) = @_;
    my $symbolPoint = [0, 1];
    my $symbolPoint2 = [1];
    my $xSymbol = Polynomial->new($symbolPoint);
    my $result = Polynomial->new($symbolPoint2);

    for (my $i = 0; $i < scalar(@$xi); ++$i) {
        if ($i != $k) {
            my $temp = $xSymbol->subtractScalar($xi->[$i])->divideScalar($xi->[$k] - $xi->[$i]);
            $result = $result->multiply($temp);
        }
    }

    return $result;
}

sub getPnt {
    my ($xi, $yi) = @_;
    my $symbolPoint = [0];
    my $result = Polynomial->new($symbolPoint);

    for (my $i = 0; $i < scalar(@$xi); ++$i) {
        my $temp = getLkt($i, $xi)->multiplyScalar($yi->[$i]);
        $result = $result->add($temp);
    }
    return $result;
}

sub readPointsFromFile {
    my ($filename) = @_;
    my @xVector;
    my @yVector;

    open my $handle, '<', $filename or die $!;
    my $N = int(<$handle>);

    for (my $i = 0; $i < $N + 1; $i++) {
        my $line = <$handle>;
        chomp($line);
        my ($x, $y) = split(" ", $line);
        push @xVector, int($x);
        push @yVector, int($y);
    }

    close $handle;
    return { xVector => \@xVector, yVector => \@yVector };
}

# Main Program
my $fileInput;
my $fileOutput;

print "Enter the file input name/path: ";
chomp($fileInput = <STDIN>);

print "Enter the file output name/path: ";
chomp($fileOutput = <STDIN>);

my $result = readPointsFromFile($fileInput);
my $xVector = $result->{xVector};
my $yVector = $result->{yVector};

$result = getPnt($xVector, $yVector);
$result->print();
$result->writeToTextFile($fileOutput);
