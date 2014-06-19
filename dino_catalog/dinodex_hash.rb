class DinodexHash
  attr_reader :hash
  def initialize(data_string)
    @hash = create_dinodex_hash(data_string)
  end

  private
  def create_dinodex_hash(data_string)
    dino_hash =  data_string.to_hash
    dino_hash.each_with_object({}){ |(k,v), h| h[k.downcase.to_sym] = v }
  end
end