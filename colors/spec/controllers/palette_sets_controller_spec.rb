require 'rails_helper'
require_relative '../helpers'

describe PaletteSetsController do
  let(:username) { "blog" }
  let(:limit) { 10 }

  RSpec.configure do |c|
    c.include Helpers
  end

  before(:each) do
    stub_photos_request(username, limit)
  end

  describe "GET show" do
    before(:each) do
      @palette_set = PaletteSet.create(source: username)
    end

    it "renders the show template" do
      id = @palette_set.id
      get :show, id: id
      expect(response).to render_template "show"
    end
  end

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template "new"
    end
  end

  describe "POST create" do
    context "with valid username" do
      it "saves the new palettes in the database"

      it "redirects to the new palettes page" do
        post :create, :palette_set => { tumblr_username: username }
        expect(response).to redirect_to assigns(:palette_set)
      end
    end

    context "with invalid username" do
      it "does not save the new palettes in the database"
      it "re-renders the :index template"
    end
  end
end

