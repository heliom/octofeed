module GitHubNewsFeed
  class EventParser

    # Static
    def self.parse(raw_json)
      self.new JSON.parse(raw_json)
    end

    # Instance
    def initialize(events)
      events.each do |event_json|
        event_classname = "GitHubNewsFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }
        event = event_class.new event_json
      end
    end

  end
end
