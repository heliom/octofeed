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

    def print
      "#{gh_link @actor[:username]}
      #{@object[:action]}
      #{gh_link @object[:username]}
      to #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)}"
    end

  end
end
