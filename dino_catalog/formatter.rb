require_relative 'dinodex_config'

class InvalidFormatError < RuntimeError; end

class Formatter
  def self.identify_format(body)
    case body.lines.first
    when /genus,period,carnivore,weight,walking/i then AfricanFormatter.new
    when /name,period,continent,diet,weight_in_lbs,walking,description/i then DinodexFormatter.new
    else raise InvalidFormatError, "Invalid CSV format"
    end
  end
end

class DinodexFormatter < Formatter
  def format(hash_array)
    hash_array
  end
end

class AfricanFormatter < Formatter
  def format(hash_array)
    new_hash = hash_array.map { |h| reformat(h) }
  end

  private
  def reformat(hash)
    hash[:continent] = "africa"
    hash[:carnivore] = get_diet(hash[:carnivore])

    Hash[hash.map { |k, v| [AFRICAN_HEADER_MAPPINGS[k] || k, v] }]
  end

  def get_diet(is_carnivore)
    case is_carnivore
    when "yes" then "carnivore"
    when "no" then "herbivore"
    else nil
    end
  end
end
