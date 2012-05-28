module GitHubNewsFeed
  class MemberEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :id => json['payload']['member']['id'],
        :username => json['payload']['member']['login'],
        :avatar => json['payload']['member']['avatar_url']
      }
    end

  end
end
