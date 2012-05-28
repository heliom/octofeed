module GitHubNewsFeed
  class FollowEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :id => json['payload']['target']['id'],
        :username => json['payload']['target']['login'],
        :avatar => json['payload']['target']['avatar_url'],
        :repos => json['payload']['target']['public_repos'],
        :followers => json['payload']['target']['followers']
      }
    end

    def print
      "#{gh_link @actor[:username]}
      started following
      #{gh_link @object[:username]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
