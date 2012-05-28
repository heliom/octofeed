module GitHubNewsFeed
  class PublicEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json
    end

    def print
      "#{gh_link @actor[:username]}
      open sourced
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
