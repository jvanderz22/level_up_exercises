require 'json'
require 'pry'

class Parser
  attr_reader :data
  def initialize(json)
    @data = parsed_json(json)
  end

  private

  def parsed_json(json)
    JSON.parse(json).select { |elem| is_valid_hash?(elem) }
  end

  def is_valid_hash?(data)
    data = Hash(data)
    (["date", "cohort", "result"] - data.keys).empty?
  end

end

