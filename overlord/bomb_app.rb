require 'sinatra'
require 'sinatra/base'
require 'sinatra/cookies'
require 'sinatra/link_header'
require 'sinatra/static_assets'
require 'sprockets'
require_relative 'lib/overlord/bomb.rb'
require 'haml'


class BombApp < Sinatra::Base
  helpers Sinatra::Cookies
  helpers Sinatra::LinkHeader
  configure do
    enable :sessions
  end

  before do
    session[:failed_attempts] ||= 0
    session[:bomb] ||= Bomb.new

    @redirection_table =  {
      :not_booted => "/boot",
      :inactive => "/inactive",
      :active => "/active",
      :exploded => "/exploded"
    }
  end

  def find_current_page(current_page)
   page = @redirection_table[session[:bomb].status]
   redirect to(page) unless page == current_page
  end

  post '/reset' do
    puts "reset"
    session[:bomb] = Bomb.new
    find_current_page('/')
  end

  get '/' do
     find_current_page('/')
  end

  get '/boot' do
    find_current_page('/boot')
    haml :boot, :locals => { :status => "Not Booted" }
  end

  post '/boot' do
    puts params
    puts params["activation_code"]
    params["activation_code"] = "1234" if params["activation_code"].empty?
    params["deactivation_code"] = "0000" if params["deactivation_code"].empty?
    session[:bomb].boot(params["activation_code"], params["deactivation_code"])
    find_current_page('/')
  end

  get '/inactive' do
    find_current_page('/inactive')
    haml :inactive, :locals => { :status => "Inactive" }
  end

  post '/inactive' do
    session[:bomb].activate(params["activation_code"])
    find_current_page('/')
  end

  get '/active' do
    find_current_page('/active')
    failed_attempts = session[:bomb].failed_deactivation_attempts
    haml :active, :locals => { :status => "Active",
                               :failed_attempts => failed_attempts }
  end

  post '/active' do
    session[:bomb].deactivate(params["deactivation_code"])
    find_current_page('/')
  end

  get '/exploded' do
    find_current_page('/exploded')
    haml :exploded, :locals => { :status => "Exploded" }
  end
end


