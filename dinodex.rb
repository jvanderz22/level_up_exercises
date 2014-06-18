require 'csv'
require 'json'
require_relative 'dino.rb'
require_relative 'african_hash.rb'
require_relative 'dinodex_hash.rb'

class Dinodex
  def initialize(*csv_files)
    @dinos = Hash.new
    read_CSVs(csv_files)
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

  # working_set = working_set.select { |dino| dino.matches(args) } )
  #
  # dino.name
  # dino.send(:name)

 def to_s(dino_name)
    validate_dino(dino_name)
    @dinos[dino_name.to_sym].to_s
  end

  def validate_dino(dino_name)
    raise "#{dino_name} not found in database" if @dinos[dino_name.to_sym] == nil
  end

  def export_to_JSON(file_name)
    File.open(file_name, 'w') do |file|
      file.write(generate_json_string)
    end
  end

  private
  def read_CSVs(file_names)
    file_names.each do |file_name|
      csv_file = CSV.read(file_name, headers:true)
      validate_file(csv_file.headers)
      create_dinos(csv_file)
    end
  end

  def create_dinos(csv_file)
    csv_file.each do |row|
      dino_hash = AfricanHash.new(row) if is_african_file?(csv_file.headers)
      dino_hash = DinodexHash.new(row) if is_dinodex_file?(csv_file.headers)
      @dinos[dino_hash.hash[:name]] = Dino.new(dino_hash.hash) unless dino_hash.nil?
    end
  end

  def validate_file(header)
    if is_dinodex_file?(header) || is_african_file?(header)
      true
    else
      raise "Invalid file type."
    end
  end

  def is_african_file?(header)
    african_dinos_header = %w(Genus Period Carnivore Weight Walking)
    header == african_dinos_header ? true : false
  end

  def is_dinodex_file?(header)
    dinodex_header = %w(NAME PERIOD CONTINENT DIET WEIGHT_IN_LBS WALKING DESCRIPTION)
    header == dinodex_header ? true : false
  end

  def generate_json_string
    json_string = "{\n"
    json_dinos = []
    @dinos.each do |name, dino|
      json_dinos << generate_dino_json(name, dino)
    end
    json_string << json_dinos.join(",") << "}"
  end

  def generate_dino_json (name, dino)
    dino_string = "\"#{name}\": \{\n"
    attributes = dino.to_s.split(", ")
    formatted_attributes = []
    attributes.each do |attribute|
      split_attr = attribute.split(": ")
      formatted_attributes << "\"#{split_attr[0]}\": \"#{split_attr[1]}\""
    end
    dino_string << formatted_attributes.join(",\n")
    dino_string << "\n\}\n"
  end
end