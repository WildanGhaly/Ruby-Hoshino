class Polynomial

  public

  def initialize(coefficients)
    @coeffs = coefficients
  end

  def degree
    @coeffs.size - 1
  end

  def [](idx)
    @coeffs[idx]
  end

  def []=(idx, value)
    @coeffs[idx] = value
  end

  def +(other)
    max_size = [@coeffs.size, other.coeffs.size].max
    result_coeffs = Array.new(max_size, 0)

    @coeffs.each_with_index do |coeff, i|
      result_coeffs[i] += coeff
    end

    other.coeffs.each_with_index do |coeff, i|
      result_coeffs[i] += coeff
    end

    Polynomial.new(result_coeffs)
  end

  def -(other)
    max_size = [@coeffs.size, other.coeffs.size].max
    result_coeffs = Array.new(max_size, 0)

    @coeffs.each_with_index do |coeff, i|
      result_coeffs[i] += coeff
    end

    other.coeffs.each_with_index do |coeff, i|
      result_coeffs[i] -= coeff
    end

    Polynomial.new(result_coeffs)
  end

  def *(other)
    result_size = @coeffs.size + other.coeffs.size - 1
    result_coeffs = Array.new(result_size, 0)

    @coeffs.each_with_index do |coeff1, i|
      other.coeffs.each_with_index do |coeff2, j|
        result_coeffs[i + j] += coeff1 * coeff2
      end
    end

    Polynomial.new(result_coeffs)
  end

  def /(scalar)
    result_coeffs = @coeffs.map { |coeff| coeff / scalar.to_f }
    Polynomial.new(result_coeffs)
  end

  # def print
  #   isFirst = true
  #   @coeffs.reverse.each_with_index do |coeff, i|
  #     next if coeff == 0

  #     if !isFirst && coeff > 0
  #       print ' + '
  #     elsif coeff < 0
  #       print ' - '
  #     end

  #     if i == 0 && coeff != 0
  #       print coeff.abs
  #     elsif i == 1 && coeff != 0
  #       print "#{coeff.abs}x"
  #       isFirst = false
  #     else
  #       print "#{coeff.abs}x^#{i}"
  #       isFirst = false
  #     end
  #   end
  #   puts
  # end

  public

  attr_reader :coeffs
end

def get_lkt(k, xi)
  symbol_point = [0, 1]
  symbol_point2 = [1]
  x_symbol = Polynomial.new(symbol_point)
  result = Polynomial.new(symbol_point2)

  xi.each_with_index do |x, i|
    next if i == k

    temp = (x_symbol - Polynomial.new([x])) / (xi[k] - x)
    result = result * temp
  end

  # puts result.coeffs.join(' ')
  result
end

def get_pnt(xi, yi)
  symbol_point = [0]
  result = Polynomial.new(symbol_point)

  xi.each_with_index do |x, i|
    temp = get_lkt(i, xi) * Polynomial.new([yi[i]])
    result += temp
  end

  result
end

def main
  puts 'Enter the name/path of the input file: '
  input_file_name = gets.chomp
  puts 'Enter the name/path of the output file: '
  output_file_name = gets.chomp

  x_vector = []
  y_vector = []

  begin
    File.foreach(input_file_name).with_index do |line, idx|
      if idx == 0
        n = line.to_i
      else
        x, y = line.split.map(&:to_i)
        x_vector.push(x)
        y_vector.push(y)
      end
    end

    result = get_pnt(x_vector, y_vector)
    puts result.coeffs.join(' ')

    File.open(output_file_name, 'w') do |file|
      file.puts result.coeffs.join(' ')
      puts 'The result was written to the file.'
    end

  rescue Errno::ENOENT
    puts 'Error opening the file.'
  end
end

main
