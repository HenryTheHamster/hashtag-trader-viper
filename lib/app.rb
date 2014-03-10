require 'omniauth'
require 'omniauth-github'
require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'haml'

require_relative 'configuration'
require_relative 'routes/index'
require_relative 'routes/authorization'

class HashTagTraderApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  configuration = Configuration.new
  configure do
    set :configuration, configuration
  end

  enable :sessions

  use OmniAuth::Builder do
    configuration.omniauth_providers.each do |provider_config|
      provider *provider_config.flatten
    end
  end

  before do
    pass if request.path_info =~ /^\/auth\//

    redirect to("/auth/") unless session[:uid]
  end

  register Sinatra::Twitter::Bootstrap::Assets
  
  register HashTagTrader::Routes::Index
  register HashTagTrader::Routes::Authorization
end

