require 'spec_helper'
require 'pry'
require 'Statistics2'

describe Calculations do

  let(:converted) {  [ { "date" => "2014-03-20", "cohort" => "A", "result" => 0 },
                       { "date" => "2014-03-20", "cohort" => "A", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "A", "result" => 0 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 0 }  ] }
   let(:cohort_A_converted) { converted.count do |hash|
        hash["result"] == 1 && hash["cohort"] == "A"
   end }

   let (:cohort_A_attempted) { converted.count do |hash|
     hash["cohort"] == "A"
   end }

  let(:json) { converted.to_json }
  subject(:calculations) { Calculations.new(json) }

  describe "#initialize" do
    it "should accept json, convert it to an array of hashes and set it equal to data" do
      expect(calculations.data).to eq(converted)
    end
  end

  describe "#sample_size" do
    it "should return the number of items in the array" do
      expect(calculations.sample_size).to eq(converted.length)
    end
  end

  describe "#percent_conversions" do
    it "should return the percentage of conversions as a decimal for the passed in cohort" do
      percent_converted = (cohort_A_converted.to_f/cohort_A_attempted)
      expect(calculations.percent_conversion("A")).to be_within(0.01).of(percent_converted)
    end
  end

  describe "#standard_error" do
    it "should return the standard error of the mean for the passed in cohort: sqrt((p * 1-p)/n)" do
      expect(calculations.standard_error("A")).to be_within(0.005).of(0.2722)
    end
  end

  describe "#confidence_interval" do
    it "should calculate the confidence interval for the passed in cohort
      and return it as an array of 2 elements: the first being the lower bound
      and the second as the upper bound" do
        lower_bound, upper_bound = calculations.confidence_interval("A")
        expect(lower_bound).to be_within(0.005).of(-0.2001)
        expect(upper_bound).to be_within(0.005).of(0.8668)
    end
  end

  describe "#current_leader" do
    it "should determine which method is converting people at higher rate" do
      expect(calculations.current_leader).to eq("B")
    end
  end

  describe "#chi_square" do
    it "should determine the chi square value for the passed in cohort" do
      expect(calculations.chi_square("B")).to be_within(0.01).of(0.66)
    end
  end

  describe "#confidence_level" do
    it "should determine the confidence level that the more successful test
      is better than randomly choosing one" do
        expect(calculations.confidence_level).to eq(Statistics2.chi2_x(1, 54.0/81))
    end
  end
end
