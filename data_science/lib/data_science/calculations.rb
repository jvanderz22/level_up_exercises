require_relative 'parser.rb'
require 'Statistics2'

class Calculations
  attr_reader :data, :current_leader

  def initialize(json)
    @data = Parser.new(json).data
    @current_leader = find_current_leader
  end

  def sample_size
    data.length
  end

  def percent_conversion(cohort)
    conversions(cohort).to_f/attempted_conversions(cohort)
  end

  def standard_error(cohort)
    p = percent_conversion(cohort)
    invert_p = 1 - p
    n = attempted_conversions(cohort)
    Math.sqrt((p * invert_p)/n)
  end

  def confidence_interval(cohort)
    lower_bound = percent_conversion(cohort) - (1.96 * standard_error(cohort))
    upper_bound = percent_conversion(cohort) + (1.96 * standard_error(cohort))
    [lower_bound, upper_bound]
  end

  def chi_square(cohort)
    #chi_square value calculator
    #implemented formula can be found here: http://math.hws.edu/javamath/ryan/ChiSquare.html
    quadrant_a = conversions(cohort)
    quadrant_b = attempted_conversions(cohort) - conversions(cohort)
    quadrant_c = all_conversions - conversions(cohort)
    quadrant_d = sample_size - quadrant_a - quadrant_b - quadrant_c
    chi_square_numer = (((quadrant_a * quadrant_d) - (quadrant_b * quadrant_c))**2) * sample_size
    chi_square_denom = (quadrant_a + quadrant_b) * (quadrant_c + quadrant_d) *
                       (quadrant_b + quadrant_d) * (quadrant_a + quadrant_c)
    chi_square_numer.to_f/chi_square_denom
  end

  def confidence_level
    deg_of_freedom = cohorts.count - 1
    Statistics2.chi2_x(deg_of_freedom, chi_square(current_leader))
  end

  private

  def all_conversions
    data.count do |hash|
      hash["result"] == 1
    end
  end

  def conversions(cohort)
    data.count do |hash|
      hash["cohort"] == cohort && hash["result"] == 1
    end
  end

  def attempted_conversions(cohort)
    data.count { |hash| hash["cohort"] == cohort }
  end

  def find_current_leader
    cohorts.max_by { |cohort| percent_conversion(cohort) }
  end

  def cohorts
    data.map { |hash| hash["cohort"] }.uniq
  end



end
