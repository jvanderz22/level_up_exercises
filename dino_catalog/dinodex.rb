require 'csv'
require 'json'
require_relative 'dino.rb'
require_relative 'african_hash.rb'
require_relative 'dinodex_hash.rb'

class Dinodex
  PARSERS = [AfricanHash, DinodexHash]
  def initialize(*csv_files)
    @dinos = {}
    read_csvs(csv_files)
  end

  #searches all entries based on a set of parameters and prints and returns them
  #the following are examples of valid search options:
  #{:diet => carnivore/herbivore/piscivor/insectivore}
  #{:continent => continents}
  #{:walking => biped/quadruped}
  #{:weight => {:gt => 2000}} / {:weight => {:lt => 2000}} / {:weight => {:et => 2000}}
  #{:diet => carnivore, weight => {:gt => 4000}}
  def search(options)
    matching_dinos = []
    @dinos.each do |_, dino|
      matching_dinos <<  dino if dino.matches_search?(options)
    end
   matching_dinos.each { |dino| puts dino.to_s }
  end

  def print_dino(dino_name)
    validate_dino(dino_name)
    @dinos[dino_name.to_sym].to_s
  end

  def validate_dino(dino_name)
    raise "#{dino_name} not found in database" if @dinos[dino_name.to_sym] == nil
  end

  def export_to_JSON(file_name)
    File.open(file_name, 'w') do |file|
      file.write(JSON.pretty_generate(self))
    end
  end

  def to_json(*a)
    self.to_hash.to_json(*a)
  end

  def to_hash
    dinos_hash = {}
    @dinos.each do |name, dino|
      dinos_hash[name] = dino.to_hash
    end
    dinos_hash
  end

  private

  def read_csvs(file_names)
    file_names.each do |file_name|
      csv_file = CSV.read(file_name, headers:true)
      validate_file(csv_file.headers)
      create_dinos_from_file(csv_file)
    end
  end

  def create_dinos_from_file(csv_file)
    parser = get_parser(csv_file.headers)
    csv_file.each do |row|
      dino_hash = parser.new(row)
      @dinos[dino_hash.hash[:name]] = Dino.new(dino_hash.hash) unless dino_hash.nil?
    end
  end

  def get_parser(csv_header)
    parser = PARSERS.find { |parser| parser.matches?(csv_header) }
  end

  def validate_file(header)
    unless get_parser(header)
      raise "Invalid file type."
    end
  end
end
