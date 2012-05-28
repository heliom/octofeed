module GitHubNewsFeed
  class PublicEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json
    end
    
  end
end
