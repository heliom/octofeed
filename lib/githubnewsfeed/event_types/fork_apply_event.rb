module GitHubNewsFeed
  class ForkApplyEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      # Todo:   Have yet to find a `ForkApplyEvent` example
      #         somewhere in https://api.github.com/events
      @object = {}
    end

    def print
      "#{@type}"
    end

  end
end
