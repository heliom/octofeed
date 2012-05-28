module GitHubNewsFeed
  class TeamAddEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :team => json['payload']['team']['name'],
        :user => json['payload']['user']['login']
      }
    end

  end
end
