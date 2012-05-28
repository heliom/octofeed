module GitHubNewsFeed
  class WatchEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action']
      }
    end

  end
end
