require_relative 'dinodex.rb'

if __FILE__ == $PROGRAM_NAME
  dino_data = Dinodex.new("african_dinosaur_export.csv", "dinodex.csv")
  #dinoData.print("Abrictosaurus")
  dino_data.export_to_JSON("new_dino.json")

  #dino_data.search({:walking => "Biped"})
  puts "Searching for dinos from the cretaceous period"
  dino_data.search({:period => "Cretaceous"})
  puts "Searching animals that weigh more than 2000 lbs"
  dino_data.search({:weight => {:gt => 2000}})
   puts "Searching for herbivores weight less than 2000 lbs"
  dino_data.search({ :diet => "herbivore", :weight => { :lt => 2000 } } )
  puts "Searching for biped carnivores from the cretaceous period"
  dino_data.search( { :period => "Cretaceous", :walking => "biped", :diet => "carnivore" } )
end

