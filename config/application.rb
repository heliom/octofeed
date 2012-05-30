require File.expand_path('../boot', __FILE__)

# Ruby
require "net/https"
require "uri"

# Gems w/ Bundle
if defined?(Bundler)
  Bundler.require(:default, ENV['RACK_ENV'])
end

# Helpers
Dir[File.expand_path('../../app/helpers/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

# Lib
Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
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

    ['/', '/page/:page_number'].each do |path|
      get path do
        @user = session[:user]
        @event_groups = []
        @page_number = (params[:page_number] || 1).to_i

        if @user
          # Repos watched
          repos_uri = URI.parse("https://api.github.com/user/watched?access_token=#{@user[:token]}")

          repos_http = Net::HTTP.new(repos_uri.host, repos_uri.port)
          repos_http.use_ssl = true
          repos_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          repos_request = Net::HTTP::Get.new(repos_uri.request_uri)
          repos_response = repos_http.request(repos_request)

          repos = JSON.parse(repos_response.body)
          watched_repos = []
          repos.each do |repo|
            watched_repos << repo['full_name']
          end

          # Events
          uri = URI.parse("https://api.github.com/users/#{@user[:username]}/received_events?access_token=#{@user[:token]}&page=#{@page_number}")

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)

          GitHubNewsFeed::EventParser.parse(response.body, watched_repos, session)
          @event_groups = GitHubNewsFeed::EventGroup.all
        end

        erb :index
      end
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
