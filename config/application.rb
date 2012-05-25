require File.expand_path('../boot', __FILE__)

if defined?(Bundler)
  Bundler.require(:default, ENV['RACK_ENV'])
end

module GitHubNewsFeed
  class App < Sinatra::Base
    set :sessions, true
    set :root, File.expand_path('../../app',  __FILE__)
    set :erb, :layout => :'layouts/application'

    get '/' do
      erb :index
    end
  end
end
