require_relative 'lib/data_science/calculations.rb'

if __FILE__ == $0
  json_data = File.read("source_data.json")
  calculations = Calculations.new(json_data)
  puts "Total sample size #{calculations.sample_size}"
  puts "Conversions for Cohort A: #{calculations.conversions("A")}"
  puts "Percentage of conversion for Cohort A: #{calculations.percent_conversion("A")}"
  puts "Confidence interval for Cohort A: #{calculations.confidence_interval("A")}"
  puts "Conversions for Cohort B: #{calculations.conversions("B")}"
  puts "Percentage of conversion for Cohort B: #{calculations.percent_conversion("B")}"
  puts "Confidence interval for Cohort B: #{calculations.confidence_interval("B")}"
  puts "Confidence level that the current leader #{calculations.current_leader} is "\
    "better than a random selection is #{calculations.confidence_level}"
end
