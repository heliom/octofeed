require File.expand_path('../boot', __FILE__)

# Ruby
require "net/https"
require "uri"

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
    use OmniAuth::Strategies::GitHub, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => 'repo'

    set :sessions, true
    set :session_secret, "BFDPII5fTVbYcCA0dcQdS5YFDTLWqiC8a1Xaxc0miPmUTW5FdMHAPZ2eWtJsBcb"
    set :root, File.expand_path('../../app',  __FILE__)
    set :erb, :layout => :'layouts/application'

    get '/' do
      @user = session[:user]

      if @user
        uri = URI.parse("https://api.github.com/users/#{@user[:username]}/received_events?access_token=#{@user[:token]}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        @data = JSON.parse(response.body)
      end

      erb :index
    end

    get '/auth/:provider/callback' do
      user = request.env['omniauth.auth']
      session[:user] = {
        :username => user.info.nickname,
        :token => user.credentials.token
      }

      redirect '/'
    end

    get '/logout' do
      session.clear
      redirect '/'
    end

  end
end
