require 'haml'

module BombApp
  module Routes
    class Inactive < Sinatra::Application
      error Models::NotFound do
        error 404
      end

      get 'inactive' do
        haml :inactive
      end
    end
  end
end
