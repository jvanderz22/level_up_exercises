require 'spec_helper'
require 'json'

describe Parser do
  let(:json) { [ { date:"2014-03-20", cohort:"B", result:0 },
                 { date:"2014-03-20", cohort:"B", result:0 } ].to_json }
  let(:valid_result) { [ {"date" => "2014-03-20", "cohort" => "B", "result" => 0 },
                  {"date" => "2014-03-20", "cohort" => "B", "result" => 0} ] }
  let (:parser) { Parser.new(json) }
  let (:invalid_hash) {  { "date" => "2014-03-20", "cohort" => "B", "not_result" => 1 } }
  let (:invalid_array) { [invalid_hash] }

  describe "#parsed_json" do
    it "should raise an exception given an invalid json" do
      expect { parser.parsed_json("a") }.to raise_exception
    end

    it "should return a parsed JSON object as an array of hashes" do
      expect(parser.parsed_json(json)).to eq(valid_result)
    end

    it "should only return the hashes that have all of the keys 'date', 'cohort',
      and 'result" do
        json_with_invalid = [ { date:"2014-03-20", cohort:"B", result:0 },
                              { date:"2014-03-20", cohort:"B", result:0},
                              { date:"2014-03-20", not_cohort:"1", result: 0 }].to_json
        expect(parser.parsed_json(json_with_invalid)).to eq(valid_result)
    end
  end

  describe "#is_valid_json?" do
    it "should return true if passed data in a valid JSON format" do
      expect(parser.is_valid_json?(json)).to eq(true)
    end

    it "should return false if passed data that isn't valid JSON" do
      expect(parser.is_valid_json?("a")).to eq(false)
    end
  end

  describe "#is_valid_hash?" do
    it "should return true if the passed hash contains the keys
      'date', 'cohort', and 'result'" do
        valid_hash = { "date" => "2014-03-20", "cohort" => "B", "result" => 0 }
        expect(parser.is_valid_hash?(valid_hash)).to eq(true)
    end

    it "should return false if the passed hash doesn't contain at least
     one of the keys 'date', 'cohort', and 'result'" do
      expect(parser.is_valid_hash?(invalid_hash)).to eq(false)
    end
  end
end
