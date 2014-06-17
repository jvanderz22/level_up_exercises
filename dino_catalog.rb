require 'csv'
require 'json'


#holds information for a single type of dinosaur
class Dino
  attr_reader :name, :period, :continent, :weight, :walking, :description, :diet
  #accepts the following data as a hash and saves it in the object
  def initialize(**data)
    @name = data[:name]
    @period = data[:period]
    @continent = data[:continent]
    @weight = data[:weight_in_lbs]
    @walking = data[:walking]
    @description = data[:description]
    @diet = data[:diet]
  end

  #prints out all information saved for the dinosaur in a legible way
  def print
    output_string = "#{@name} info - "
    instance_variables.each do |var|
      value = instance_variable_get("#{var}")
      pretty_var = var[1..-1]
      pretty_var.capitalize!
      unless value == nil || var == :@name
        output_string <<  "#{pretty_var}: #{value}, "
      end
    end
    puts output_string[0...-2]
  end

  # returns true if the dinosaur passes all parameters passed into options or
  # otherwise returns false
  def matchesSearch?(**options)
    options.each do |key, value|
      case key
      when :period
        return false unless @period.include?(value)
      when :continent
        return false unless value.downcase == @continent.downcase
      when :walking
        return false unless value.downcase == @walking.downcase
      when :weight
        #weight can take either  greater than, less than, or equal to as a parameter
        return false unless matchesWeight?(value)
      when :diet
        return false unless matchesDiet?(value)
      end
    end
    true
  end

  def matchesWeight?(weightHash)
    return false if @weight == nil
    if weightHash.include?(:gt)
      (@weight.to_i > weightHash[:gt].to_i)? true : false
    elsif weightHash.include?(:lt)
      (@weight.to_i < weightHash[:lt].to_i)? true : false
    elsif value.include?(:et)
      (@weight.to_i == weightHash[:et].to_i)? true : false
    else
      false
    end
  end

  def matchesDiet?(dietValue)
    diet_downcase = @diet.downcase
    if dietValue.downcase == "carnivore"
      if diet_downcase != "carnivore" && diet_downcase != "piscivore" &&
        diet_downcase != "insectivore"
        false
      else
        true
      end
    else
      (diet_downcase == dietValue.downcase)? true : false
    end
  end
end

#A class that stores the data for all dinosuars in given CSV files
class DinoDex

  #takes in an array of .csv files to be interpretted
  def initialize(*csv_files)
    @dinos = Hash.new
    readInCSVs(csv_files)
  end

  private
  #takes an array of .csv files and delegates a helper function to correctly parse them
  #given how the name of the dinosaurs are saved in the first row
  #This method relies on having the format exactly the same as in the .csv files
  def readInCSVs(file_names)
    file_names.each do |file_name|
      csv_file = CSV.read(file_name, headers:true)
      validateFile(csv_file.headers)
      createDinos(csv_file)
    end
  end

  def createDinos(csv_file)
    csv_file.each do |row|
      createDinodexHash(row) if isDinodexFile?(csv_file.headers)
      createAfricanDinoHash(row) if isAfricanFile?(csv_file.headers)
    end
  end

  def validateFile(header)
    if isDinodexFile?(header) || isAfricanFile?(header)
      true
    else
      raise "Invalid file type."
    end
  end

  def isAfricanFile?(header)
     african_dinos_header = %w(Genus Period Carnivore Weight Walking)
     header == african_dinos_header ? true : false
  end

  def isDinodexFile?(header)
    dinodex_header = %w(NAME PERIOD CONTINENT DIET WEIGHT_IN_LBS WALKING DESCRIPTION)
    header == dinodex_header ? true : false
  end

  #helper function which reads in data with the following headers: "NAME", "PERIOD",
  #"CONTINENT", "WEIGHT_IN_LBS", "WALKING", "DESCRIPTION", "DIET"
  def createDinodexHash(data_row)
    dino_hash =  data_row.to_hash
    dino_hash = dino_hash.each_with_object({}){ |(k,v), h| h[k.downcase.to_sym] = v }
    @dinos[dino_hash[:name]] = Dino.new(dino_hash)
  end

  #helper function which reads in data with the following headers: "Genus", "Period",
  #"Weight", "Walking, "Carnivore". It assumes that all data points can be given the
  #continent label of Africa and that if a dinosaur is not a carnivore, it is a herbivor
  def createAfricanDinoHash(data_row)
    african_dino_hash = data_row.to_hash
    converted_hash = convertAfricanDinoHash(african_dino_hash)
    @dinos[converted_hash[:name]] = Dino.new(converted_hash)
  end

  def convertAfricanDinoHash(african_dino_hash)
    converted_hash = convertCarnivoreStatus(african_dino_hash)
    converted_hash[:continent] = "Africa"
    converted_hash[:description] = nil
    mappings = { "Genus" => :name, "Period" => :period,
                 "Weight" => :weight_in_lbs, "Walking" => :walking }
    converted_hash = Hash[converted_hash.map { |k, v| [mappings[k] || k, v] }]
  end

  def convertCarnivoreStatus(african_dino_hash)
    african_dino_hash[:diet] = "Carnivore" if african_dino_hash["Carnivore"] == "Yes"
    african_dino_hash[:diet] ||= "Herbivore"
    african_dino_hash.delete("Carnivore")
    african_dino_hash
  end

  public

  #searches all entries based on a set of parameters and prints and returns them
  #the following are examples of valid search options:
  #{:diet => carnivore/herbivore/piscivor/insectivore}
  #{:continent => continents}
  #{:walking => biped/quadruped}
  #{:weight => {:gt => 2000}} / {:weight => {:lt => 2000}} / {:weight => {:et => 2000}}
  #{:diet => carnivore, weight => {:gt => 4000}}
  def search(**options)
    matching_dinos = Array.new
    @dinos.each do |name, dino|
      matching_dinos <<  dino if dino.matchesSearch?(options)
    end
    matching_dinos.each { |dino| dino.print }
  end

  # working_set = working_set.select { |dino| dino.matches(args) } )
  #
  # dino.name
  # dino.send(:name)

  #accepts a dinosaur name and returns all data in the database for that dinosaur
  def print(dino_name)
    validateDino(dino_name)
    @dinos[dino_name.to_sym].print
  end

  def validateDino(dino_name)
    raise "#{dino_name} not found in database" if @dinos[dino_name.to_sym] == nil
  end

  #exports all data to the specified JSON file
  def exportToJSON(file_name)
    File.open(file_name, 'w') do |file|
      file.write(JSON.pretty_generate(@dino_hash))
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  dino_data = DinoDex.new("african_dinosaur_export.csv", "dinodex.csv")
  #puts dinoData.inspect
  #dinoData.print("Abrictosaurus")
  #puts dinoData.inspect
  #dinoData.exportToJSON("dino.json")
  #dino_data.search({:walking => "Biped"})
  #dino_data.search({:period => "Cretaceous"})
  #dino_data.search({:weight => {:gt => 2000}})
  puts "Searching for herbivores weighing over 2000 lbs"
  dino_data.search({:diet => "herbivore", :weight => {:gt => 2000}})
  puts "Searching for herbivores weight less than 2000 lbs"
  dino_data.search({ :diet => "herbivore", :weight => { :lt => 2000 } } )
  puts "Searching for biped carnivores from the cretaceous period"
  dino_data.search( { :period => "Cretaceous", :walking => "biped", :diet => "carnivore" } )
end

