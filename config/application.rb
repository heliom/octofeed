require File.expand_path('../boot', __FILE__)

# Gems w/ Bundle
if defined?(Bundler)
  Bundler.require(:default, ENV['RACK_ENV'])
end

# Env settings
if File.exists?(File.expand_path('../environment.rb', __FILE__))
  require File.expand_path('../environment', __FILE__)
end

module GitHubNewsFeed
  class App < Sinatra::Base
    use OmniAuth::Strategies::GitHub, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']

    set :sessions, true
    set :session_secret, "BFDPII5fTVbYcCA0dcQdS5YFDTLWqiC8a1Xaxc0miPmUTW5FdMHAPZ2eWtJsBcb"
    set :root, File.expand_path('../../app',  __FILE__)
    set :erb, :layout => :'layouts/application'

    get '/' do
      @user = session[:user]
      erb :index
    end

    get '/auth/:provider/callback' do
      session[:user] = request.env['omniauth.auth'].credentials.token
      redirect '/'
    end

    get '/logout' do
      session.clear
      redirect '/'
    end

  end
end
