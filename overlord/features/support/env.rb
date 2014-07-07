require 'capybara'
require 'capybara/cucumber'
require 'rspec/expectations'
require 'overlord'
require_relative '../../bomb_app.rb'
$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

#Capybara.app_host = ENV["host"]
#Capybara.default_driver = :selenium

World do
  Capybara.app = BombApp
  #include Capybara::DSL
  #include RSpec::Matchers
end
