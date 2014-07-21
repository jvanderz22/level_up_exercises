require 'rails_helper'
require_relative '../helpers'

describe PaletteSet do
  let(:username) { FactoryGirl.attributes_for(:palette_set)[:source] }
  let(:image_url) { "spec/fixtures/images/image.jpg" }

  RSpec.configure do |c|
    c.include Helpers
  end
    
  before(:each) do 
    stub_info_request(username)
    stub_photos_request(username, PULL_LIMIT) 
  end

  describe "#create" do
    context "with valid params" do
      context "with successful HTTP responses from third-party API" do
        let(:palette_set) { FactoryGirl.create(:palette_set) }
        
        context "with photos to generate palettes from" do
          it "creates up to #{PULL_LIMIT} different palettes" do
            expect(palette_set.palettes.size).to be PULL_LIMIT
          end
        end

        context "without photos to generate from" do
          let(:username) { "nophotos" }
          let(:palette_set) { FactoryGirl.create(:palette_set, source: username) }

          it "is valid" do
            expect(palette_set).to be_valid
          end

          it "creates 0 palettes" do
            expect(palette_set.palettes).to be_empty
          end
        end
      end

      context "with unsuccessful HTTP responses from third-party API" do
        context "with unsuccessful client response" do
          let(:username) { "unauthorized" }
          let(:palette_set_save) { FactoryGirl.build(:palette_set, source: username).save }

          it "should not save to db" do
            expect(palette_set_save).to be false
          end
        end

        context "with unsuccessful image response" do
          let(:username) { "invalid_image_urls" }
          let(:palette_set_save) { FactoryGirl.build(:palette_set, source: username).save }
          let(:palette_set) { FactoryGirl.create(:palette_set, source: username) }

          it "saves to db" do
            expect(palette_set_save).to be true
          end

          it "does not generate a palette for the unsuccessful image read" do
            expect(palette_set.palettes).to be_empty
          end
        end
      end

      context "with any unsuccessful palette creation" do
        before(:each) do
          allow_any_instance_of(Palette).to receive(:save) { false }
        end

        it "does not generate the palette" do
          expect(FactoryGirl.create(:palette_set).palettes).to be_empty
        end
      end
    end
    
    context "with invalid params" do
      context "with no source" do
        let(:username) { nil }
        let(:palette_set_build) { FactoryGirl.build(:palette_set, source: username) }

        it "is not valid" do
          expect(palette_set_build).to_not be_valid
        end
      end

      context "with non-existent source" do
        let(:username) { "doesnotexist" }
        let(:palette_set_new) { FactoryGirl.build(:palette_set, source: username) }

        it "is not valid" do
          expect(palette_set_new).to_not be_valid
        end
      end
    end
  end
end

