require 'sinatra'
#require_relative 'lib/overlord/bomb.rb'
require 'haml'


get '/' do

  haml :home
end
