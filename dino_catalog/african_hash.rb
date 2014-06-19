class AfricanHash
  attr_reader :hash
  def initialize(data_string)
    @hash = create_african_hash(data_string)
  end

  def self.matches?(header)
    african_dinos_header = %w(Genus Period Carnivore Weight Walking)
    header == african_dinos_header
  end

  private
  def create_african_hash(data_string)
    raw_dino_hash = data_string.to_hash
    convert_african_hash(raw_dino_hash)
  end

  def convert_african_hash(raw_dino_hash)
    converted_hash = {
      :name => raw_dino_hash["Genus"],
      :period => raw_dino_hash["Period"],
      :weight_in_lbs => raw_dino_hash["Weight"],
      :walking => raw_dino_hash["Walking"],
      :diet => get_converted_diet(raw_dino_hash["Carnivore"]),
      :continent => "Africa",
      :description =>  nil
    }
  end

  def get_converted_diet(val)
    val == "Yes"? "Carnivore" : "Herbivore"
  end
end
