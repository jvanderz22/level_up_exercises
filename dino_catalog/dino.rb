class Dino
  attr_reader :name, :period, :continent, :weight, :walking, :description, :diet

  CARNIVOROUS_DIETS = %w(carnivore piscivore insectivore)

  def initialize(data)
    @name = data[:name]
    @period = data[:period]
    @continent = data[:continent]
    @weight = data[:weight_in_lbs].to_i if  data[:weight_in_lbs]
    @walking = data[:walking]
    @description = data[:description]
    @diet = data[:diet]
  end

  def to_s
    output_vals = instance_variables.map do |var|
      value = instance_variable_get(var)
      next unless value
      pretty_var = var[1..-1]
      pretty_var.capitalize!
      "#{pretty_var}: #{value}"
    end
    output_vals.compact.join(", ")
  end

 def to_hash
   dinoHash = {
      name: @name,
      period: @period,
      continent: @continent,
      weight: @weight,
      walking: @walking,
      description: @description,
      diet: @diet
   }
 end

  def matches_search?(parameters)
    parameters.all? { |key, value| matches_search_parameter?(key, value) }
  end

  private

  def matches_search_parameter?(key, value)
    self.send("match_#{key.to_s}?".to_sym, value)
  end

  def match_period?(value)
    @period.downcase.include?(value.downcase)
  end

  def match_continent?(value)
    value.downcase == @continent.downcase
  end

  def match_walking?(value)
    value.downcase == @walking.downcase
  end

  def match_diet?(value)
    if value == "carnivore"
      CARNIVOROUS_DIETS.include?(value)
    else
      value.downcase == @diet.downcase
    end
  end

  def match_weight?(value)
    return false if @weight.nil?
    if value.include?(:gt)
      @weight > value[:gt].to_i
    elsif value.include?(:lt)
      @weight < value[:lt].to_i
    elsif value.include?(:et)
      @weight == value[:et].to_i
    else
      false
    end
  end
end
