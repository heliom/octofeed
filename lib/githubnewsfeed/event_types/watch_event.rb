module GitHubNewsFeed
  class WatchEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action']
      }
    end

    def print
      "#{gh_link @actor[:username]}
      #{@object[:action]} watching
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
