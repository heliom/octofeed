# encoding: utf-8
require File.expand_path('../boot', __FILE__)

module OctoFeed
  class App < Sinatra::Base
    # Using custom OmniAuth sttategies to ask for different privileges
    use OmniAuth::Strategies::GitHubPublic, ENV['GITHUB_PUBLIC_APP_KEY'], ENV['GITHUB_PUBLIC_APP_SECRET']
    use OmniAuth::Strategies::GitHubPrivate, ENV['GITHUB_PRIVATE_APP_KEY'], ENV['GITHUB_PRIVATE_APP_SECRET'], :scope => 'repo'

    set :sessions, true
    set :session_secret, "BFDPII5fTVbYcCA0dcQdS5YFDTLWqiC8a1Xaxc0miPmUTW5FdMHAPZ2eWtJsBcb"
    set :root, File.expand_path('../../app',  __FILE__)
    set :public_folder, File.expand_path('../../public',  __FILE__)
    set :erb, :layout => :'layouts/application'

    before do
      cache_control :no_cache
      @user = session[:user]
      redirect request.url.gsub('http://', 'https://') unless request.ssl? || development?
    end

    ['/', '/page/:page_number'].each do |path|
      get path do
        @event_groups = []
        @page_number = (params[:page_number] || 1).to_i
        @is_xhr = request.xhr?

        if @user
          @page_title = "#{@user[:username]}’s OctoFeed"

          # Get repos being watched by the user
          # We will need that list to build a repo-group or a user-group if not watching the repo
          repos_response = https_request("https://api.github.com/user/watched?access_token=#{@user[:token]}")

          repos = JSON.parse(repos_response.body)
          watched_repos = []
          repos.each do |repo|
            watched_repos << repo['full_name']
          end

          # Get users being followed by the user
          # Used to know if you have unfollowed a user or a repo
          users_response = https_request("https://api.github.com/user/following?access_token=#{@user[:token]}")

          users = JSON.parse(users_response.body)
          followed_users = []
          users.each do |user|
            followed_users << user['login']
          end

          # Get events that a user has received
          # Will list private repos events if the user has selected the private app
          response = https_request(
            "https://api.github.com/users/#{@user[:username]}/received_events?access_token=#{@user[:token]}&page=#{@page_number}"
          )

          # Map database user to an Object
          # Then set token variable. Not saving it in db
          user = OctoFeed::User.find_or_create(session[:user][:username])
          user.token = session[:user][:token]
          @last_updated = params[:last_updated] ? Time.parse(params[:last_updated]) : user.last_updated

          # Parse events
          event_parser = OctoFeed::EventParser.new(response.body, watched_repos, followed_users, user)
          @event_groups = event_parser.groups

          # Update user `last_updated` once everything is done
          # Only if not an xhr request
          user.update_last_updated unless @is_xhr
        end

        # If the request is an xhr one (`load more` ajax button), render a partial without layout
        # Else render the index
        if @is_xhr
          response_body = erb :_events, :layout => false
        else
          response_body = erb :index
        end

        etag Digest::MD5.hexdigest(response_body)
        response_body
      end
    end

    # GitHub apps callback
    # => /auth/github_private/callback
    # => /auth/github_public/callback
    get '/auth/:provider/callback' do
      user = request.env['omniauth.auth']
      session[:user] = {
        :username => user.info.nickname,
        :token => user.credentials.token,
        :avatar => user.extra.raw_info.avatar_url
      }

      redirect '/'
    end

    # GitHub apps login failure
    get 'auth/failure' do
      redirect '/'
    end

    get '/logout' do
      session.clear
      redirect '/'
    end

    not_found do
      @page_title = 'No OctoFeed here…'

      # Get first event of the public events feed
      response = https_request("https://api.github.com/events")
      event = JSON.parse(response.body).first
      username = event['actor']['login']
      user = OctoFeed::User.new({'username' => username, 'last_updated' => Time.now})

      # Parse the event
      event_parser = OctoFeed::EventParser.new(response.body, [], [username], user, 1)
      @event_groups = event_parser.groups

      erb :'404'
    end

  end
end
