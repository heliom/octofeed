module GitHubNewsFeed
  class Event
    attr_accessor :id, :type, :actor, :repo, :object, :created_at

    def initialize(json)
      # Event
      @id = json['id']
      @type = json['type']
      @created_at = json['created_at']

      # Actor
      @actor = {
        :id => json['actor']['id'],
        :username => json['actor']['login'],
        :avatar => json['actor']['avatar_url']
      }

      # Repo
      @repo = {
        :id => json['repo']['id'],
        :name => json['repo']['name']
      }
    end

  end
end
