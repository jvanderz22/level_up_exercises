class AfricanHash
  attr_reader :hash
  def initialize(data_string)
    @hash = create_african_hash(data_string)
  end

  private
   def create_african_hash(data_string)
    african_dino_hash = data_string.to_hash
    convert_african_hash(african_dino_hash)
  end

  def convert_african_hash(unedited_dino_hash)
    converted_hash = convert_carnivore_status(unedited_dino_hash)
    converted_hash[:continent] = "Africa"
    converted_hash[:description] = nil
    mappings = { "Genus" => :name, "Period" => :period,
                "Weight" => :weight_in_lbs, "Walking" => :walking }
    Hash[converted_hash.map { |k, v| [mappings[k] || k, v] }]
  end

  def convert_carnivore_status(unedited_dino_hash)
    unedited_dino_hash[:diet] = "Carnivore" if unedited_dino_hash["Carnivore"] == "Yes"
    unedited_dino_hash[:diet] ||= "Herbivore"
    unedited_dino_hash.delete("Carnivore")
    unedited_dino_hash
  end
end