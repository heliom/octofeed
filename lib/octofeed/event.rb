module OctoFeed
  class Event
    attr_accessor :id, :type, :actor, :repo, :object, :created_at, :group

    def initialize(json)
      # Event
      @id = json['id']
      @type = json['type']
      @created_at = json['created_at']
      @group = ''

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

    def set_user_group(opts={})
      {
        :type => 'user-group',
        :id => opts[:id] || @actor[:username],
        :icon => opts[:icon] || @actor[:avatar],
        :title => opts[:title] || @actor[:username]
      }
    end

    def set_repo_group(opts={})
      {
        :type => 'repo-group',
        :id => opts[:id] || @repo[:name],
        :icon => opts[:icon] || nil,
        :title => opts[:title] || @repo[:name]
      }
    end

    def print(msg)
      body = msg[:body] && msg[:body].length > 0 ? %(<div class="body">#{msg[:body]}</div>) : ''
      %(
        <div class="title">
          <img width="24" height="24" src="#{@actor[:avatar]}">
          #{msg[:title]} #{time_ago_in_words Time.parse(@created_at)}
        </div>
        #{body}
       )
    end

  end
end
