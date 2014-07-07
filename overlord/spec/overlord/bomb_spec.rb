require 'spec_helper'

describe Bomb do
  let (:bomb) { Bomb.new }

  describe "#initialize" do
    it "creates a bomb with a status variable set to :not_booted" do
      expect(bomb.status).to eq(:not_booted)
    end
  end

  describe "#boot" do
    it "sets the bomb to an inactive state" do
      bomb.boot
      expect(bomb.status).to eq(:inactive)
    end
    it "has a default activation and deactivation code of '1234' and '0000'" do
          bomb.boot
          expect(bomb.activation_code).to eq("1234")
          expect(bomb.deactivation_code).to eq("0000")
    end
    it "accepts an argument for the activation code" do
        bomb.boot("5678", "0000")
        expect(bomb.activation_code).to eq("5678")
        expect(bomb.deactivation_code).to eq("0000")
    end
    context "does not get booted with an invalid activation code" do
      it "doesn't accept length less than 4" do
        bomb.boot("123", "0000")
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accpet length greater than 4" do
        bomb.boot("12345", "0000")
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accept integers" do
        bomb.boot(1234, "0000")
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accept strings that aren't only digts" do
        bomb.boot("12.3", "0000")
        expect(bomb.status).to eq(:not_booted)
      end
    end
    context "does not get booted with an invalid deactivation code" do
      it "doesn't accept length less than 4" do
        bomb.boot("1234", "000")
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accept length greater than 4" do
        bomb.boot("1234", "00000")
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accept integers" do
        bomb.boot("1234", 1111)
        expect(bomb.status).to eq(:not_booted)
      end
      it "doesn't accept strings that aren't only digits" do
        bomb.boot("1234", "00.0")
        expect(bomb.status).to eq(:not_booted)
      end
    end
  end

  describe "#activate" do
    context 'bomb is booted' do
      before(:each) do
        bomb.boot("1234", "0000")
      end
      it "should activate the bomb if activation code is correct" do
        bomb.activate("1234")
        expect(bomb.status).to eq(:active)
       end
      it "should not activate the bomb if the activation code isn't correct" do
        bomb.activate("5678")
        expect(bomb.status).to eq(:inactive)
      end
      it "should not activate the bomb if the bomb has exploded " do
        bomb.boot("1234", "0000")
        bomb.activate("1234")
        bomb.explode
        bomb.activate("1234")
        expect(bomb.status).not_to eq(:active)
      end
    end
    context "bomb is not booted" do
      it "should not activate the bomb if is isn't booted" do
        bomb.activate("1234")
        expect(bomb.status).not_to eq(:active)
      end
    end
  end

  describe "#deactivate" do
    before(:each) do
      bomb.boot("1234", "0000")
      bomb.activate("1234")
    end
    it "should deactivate the bomb given the correct deactivation code" do
        bomb.deactivate("0000")
        expect(bomb.status).to eq(:inactive)
    end
    it "should not deactivate the bomb given an incorrect deactivation code" do
        bomb.deactivate("1111")
        expect(bomb.status).to eq(:active)
    end
    it "should update the deactivation attempts given an incorrect deactivation code" do
        bomb.deactivate("1111")
        expect(bomb.failed_deactivation_attempts).to eq(1)
    end
    it "should reset the number of failed deactivations after a successful deactivation" do
      bomb.deactivate("1111")
      bomb.deactivate("0000")
      expect(bomb.failed_deactivation_attempts).to eq(0)
    end
    it "should explode the bomb if a non-matching argument is passed "\
      "three times" do
        3.times { bomb.deactivate("1111") }
        expect(bomb.status).to eq(:exploded)
    end
    it "should not do anything if the bomb isn't booted " do
      not_booted_bomb = Bomb.new
      not_booted_bomb.deactivate("0000")
      expect(not_booted_bomb.status).to eq(:not_booted)
    end
  end

  describe "#explode" do
    before(:each) do
      bomb.boot("1234","0000")
    end
    it "should explode the bomb if the bomb is active " do
      bomb.activate("1234")
      bomb.explode
      expect(bomb.status).to eq(:exploded)
    end
    it "should not explode the bomb if the bomb isn't active " do
      bomb.explode
      expect(bomb.status).to eq(:inactive)
    end
    it "should not explode the bomb if it is not booted " do
      not_booted_bomb = Bomb.new
      not_booted_bomb.explode
      expect(not_booted_bomb.status).to eq(:not_booted)
    end
  end

  describe "#valid_code?" do
    it "return true if the length of the code is 4" do
      expect(bomb.valid_code?("1234")).to be true
    end
    it "returns true if passed 4 digits" do
      expect(bomb.valid_code?("0123")).to be true
    end
    it "returns false if the code's length is less than 4" do
      expect(bomb.valid_code?("123")).to be false
    end
    it "returns false if passed a string with more than 5 digits" do
      expect(bomb.valid_code?("12345")).to be false
    end
    it "returns false if it is passed anything that isn't a string of an integer" do
      expect(bomb.valid_code?("12.2")).to be false
      expect(bomb.valid_code?("abcd")).to be false
      expect(bomb.valid_code?([1,2,3,4])).to be false
      expect(bomb.valid_code?(1234)).to be false
    end
  end
end
