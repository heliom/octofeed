require File.expand_path('../boot', __FILE__)

module OctoFeed
  class App < Sinatra::Base
    use OmniAuth::Strategies::GitHubPublic, ENV['GITHUB_PUBLIC_APP_KEY'], ENV['GITHUB_PUBLIC_APP_SECRET']
    use OmniAuth::Strategies::GitHubPrivate, ENV['GITHUB_PRIVATE_APP_KEY'], ENV['GITHUB_PRIVATE_APP_SECRET'], :scope => 'repo'

    set :sessions, true
    set :session_secret, "BFDPII5fTVbYcCA0dcQdS5YFDTLWqiC8a1Xaxc0miPmUTW5FdMHAPZ2eWtJsBcb"
    set :root, File.expand_path('../../app',  __FILE__)
    set :public_folder, File.expand_path('../../public',  __FILE__)
    set :erb, :layout => :'layouts/application'

    before do
      cache_control :public, :must_revalidate, :max_age => 60
    end

    ['/', '/page/:page_number'].each do |path|
      get path do
        @user = session[:user]
        @event_groups = []
        @page_number = (params[:page_number] || 1).to_i
        @is_xhr = request.xhr?

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

          # Map database user to an Object
          # Then set token variable. Not saving it in db
          user = OctoFeed::User.find_or_create(session[:user][:username])
          user.token = session[:user][:token]

          # Parse events
          event_parser = OctoFeed::EventParser.new(response.body, watched_repos, user)
          @event_groups = event_parser.groups
        end

        if @is_xhr
          erb :_events, :layout => false
        else
          erb :index
        end
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
