require 'spec_helper'
require 'pry'
require 'Statistics2'

describe Calculations do
  let(:json) { [ { date: "2014-03-20", cohort:"A", result:0 },
                 { date: "2014-03-20", cohort:"A", result:1 },
                 { date: "2014-03-20", cohort:"A", result:0 },
                 { date: "2014-03-20", cohort:"B", result:1 },
                 { date: "2014-03-20", cohort:"B", result:1 },
                 { date: "2014-03-20", cohort:"B", result:0 },
                 { date: "2014-03-20", missing_cohort: "B" } ].to_json }
  let(:converted) {  [ { "date" => "2014-03-20", "cohort" => "A", "result" => 0 },
                       { "date" => "2014-03-20", "cohort" => "A", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "A", "result" => 0 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 1 },
                       { "date" => "2014-03-20", "cohort" => "B", "result" => 0 }  ] }


  let(:calculations) { Calculations.new(json) }

  describe "#initialize" do
    it "should accept json and use a parser to convert it to an array
      of hashes, each of which has the keys 'date', 'cohort', and 'result'
      and set it equal to data" do
        expect(Calculations.new(json).data).to eq(converted)
    end
  end

  describe "#sample_size" do
    it "should return the number of items in the array" do
      expect(calculations.sample_size).to eq(6)
    end
  end

  describe "#all_conversions" do
    it "should return the total number of conversions in the data" do
      expect(calculations.all_conversions).to eq(3)
    end
  end

  describe "#conversions" do
    it "should return the number of conversions for the passed in cohort" do
      expect(calculations.conversions("A")).to eq(1)
    end
  end

  describe "#percent_conversions" do
    it "should return the percentage of conversions as a decimal for the
      passed in cohort" do
        expect(calculations.percent_conversion("A").round(2)).to eq(0.33)
    end
  end

  describe "#attempted_conversions" do
    it "should return the number of records in the database that have the
      same value as the passed-in cohort" do
        expect(calculations.attempted_conversions("A")).to eq(3)
    end
  end

  describe "#standard_error" do
    it "should return the standard error of the mean for the passed in cohort:
      sqrt((p * 1-p)/n)" do
        expect(calculations.standard_error("A").round(4)).to eq(0.2722)
    end
  end

  describe "#confidence_interval" do
    it "should calculate the confidence interval for the passed in cohort
      and return it as an array of 2 elements: the first being the lower bound
      and the second as the upper bound" do
        conf_int = calculations.confidence_interval("A")
        expect(conf_int.map! { |num| num.round(4) }).to eq([-0.2001, 0.8668])
    end
  end

  describe "#find_current_leader" do
    it "should determine which method is converting people at higher rate" do
      expect(calculations.find_current_leader).to eq("B")
    end
  end

  describe "#chi_square" do
    it "should determine the chi square value for the passed in cohort" do
      expect(calculations.chi_square("B").round(4)).to eq((54.0/81).round(4))
    end
  end

  describe "#confidence_level" do
    it "should determine the confidence level that the more successful test
      is better than randomly choosing one" do
        expect(calculations.confidence_level).to eq(Statistics2.chi2_x(1, 54.0/81))
    end
  end

  describe "#cohorts" do
    it "should return the unique cohorts in the data as an array" do
      expect(calculations.cohorts).to eq(["A", "B"])
    end
  end
end
