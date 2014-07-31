class NumberUtils
  attr_accessor :prime_factors, :largest_value

  def initialize(largest_value = 1_000)
    @prime_factors = {}
    @largest_value = largest_value
    calc_all_prime_factors
  end

  def calc_all_prime_factors
    1.upto(@largest_value) do |num|
      @prime_factors[num] = calc_prime_factors_for(num)
    end
  end

  def calc_prime_factors_for(num)
    cur_max_factor = num
    factors_array = []
    2.upto(num) do |possible_factor|
      while (cur_max_factor % possible_factor).zero?
        factors_array << possible_factor
        cur_max_factor = cur_max_factor / possible_factor
      end
    end
    factors_array
  end

  def get_values(num)
    raise 'Value too high!' unless num <= @largest_value
    @prime_factors[num]
  end

  def all
    @prime_factors
  end
end


u = NumberUtils.new(100)
puts u.all
