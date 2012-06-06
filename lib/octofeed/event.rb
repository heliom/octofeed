module OctoFeed
  class Event
    attr_accessor :id, :type, :actor, :repo, :object, :created_at, :group

    def initialize(json, opts)
      # Event
      @id = json['id']
      @type = json['type']
      @created_at = json['created_at']
      @group = ''
      @user = opts[:user]

      # Actor
      @actor = {
        :id => json['actor']['id'],
        :username => json['actor']['login'],
        :avatar => json['actor']['avatar_url']
      }

      # Repo
      @repo = {
        :id => json['repo']['id'],
        :name => json['repo']['name'],
        :watched => false
      }
    end

    def set_group(watched_repo)
      @repo[:watched] = watched_repo
      @group = case watched_repo
               when true then set_repo_group
               else set_user_group
               end
    end

    def is_new?
      is_new = is_more_recent? && has_never_been_printed
      @user.add_event(@id) if is_new

      is_new
    end

    def is_more_recent?
      Time.parse(@created_at) > @user.created_at
    end

    def has_never_been_printed
      !@user.events.include?(@id)
    end

    private
    def set_user_group(opts={})
      {
        :type => opts[:type] || 'user-group',
        :id => opts[:id] || @actor[:username],
        :icon => opts[:icon] || @actor[:avatar],
        :title => opts[:title] || @actor[:username],
        :name => opts[:name] || @actor[:username]
      }
    end

    def set_repo_group(opts={})
      {
        :type => opts[:type] || 'repo-group',
        :id => opts[:id] || @repo[:name],
        :icon => opts[:icon] || '/images/repo-default.png',
        :title => opts[:title] || @repo[:name],
        :name => opts[:name] || @repo[:name]
      }
    end

    def print(msg)
      body = msg[:body] && msg[:body].length > 0 ? %(<div class="body">#{msg[:body]}</div>) : ''
      time_ago = msg[:time_ago] || time_ago_in_words(Time.parse(@created_at))

      %(
        <div class="title">
          <img width="30" height="30" src="#{@actor[:avatar]}">
          #{msg[:title]} #{time_ago}
        </div>
        #{body}
       )
    end

  end
end
