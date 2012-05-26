module GitHubNewsFeed
  class EventParser

    # Static
    def self.parse(raw_json)
      self.new JSON.parse(raw_json)
    end

    # Instance
    def initialize(events)
      events.each do |event_json|
        event = GitHubNewsFeed::Event.new event_json
      end
    end

  end
end
