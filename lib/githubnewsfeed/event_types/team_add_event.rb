module GitHubNewsFeed
  class TeamAddEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :team => json['payload']['team']['name'],
        :user => json['payload']['user']['login']
      }
    end

    def print
      "#{gh_link @actor[:username]}
      added
      #{gh_link @object[:user]}
      to
      <a href=\"https://github.com/#{@actor[:username]}\">#{@object[:team]}</a>
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
