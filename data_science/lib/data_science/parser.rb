require 'json'
require 'pry'

class Parser
  attr_reader :data
  def initialize(json)
    @data = parsed_json(json)
  end

  def parsed_json(json)
    raise TypeError unless is_valid_json?(json)
    JSON.parse(json).select { |elem| is_valid_hash?(elem) }
  end

  def is_valid_json?(json_string)
    begin
      JSON.parse(json_string)
      true
    rescue
      false
    end
  end

  def is_valid_hash?(hash)
    return false unless hash.is_a?(Hash)
    (["date", "cohort", "result"] - hash.keys).empty?
  end

end

