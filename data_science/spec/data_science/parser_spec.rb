require 'spec_helper'
require 'json'

describe Parser do
  let(:valid_result) { [ {"date" => "2014-03-20", "cohort" => "B", "result" => 0 },
                  {"date" => "2014-03-20", "cohort" => "B", "result" => 0} ] }
  let(:json) { valid_result.to_json }
  let(:json_with_invalid) { (valid_result + [{ "invalid_param" => 1 } ]).to_json }
  let (:parser) { Parser.new(json) }
  let (:invalid_hash) {  { "date" => "2014-03-20", "cohort" => "B", "not_result" => 1 } }

  describe "#initialize" do
    it "should raise an exception given an invalid json" do
      expect { Parse.new("a").data }.to raise_exception
      expect { Parse.new(["date", "time"]).data }.to raise_exception
      expect { Parse.new(invalid_hash).data }.to raise_exception
    end

    it "should return a parsed JSON object as an array of hashes" do
      expect(Parser.new(json).data).to eq(valid_result)
    end

    it "should only return the hashes that have all of the keys 'date', 'cohort',
      and 'result" do
      expect(Parser.new(json_with_invalid).data).to eq(valid_result)
    end
  end
end
