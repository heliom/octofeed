module GitHubNewsFeed
  class EventParser
    @@events = []

    # Static
    def self.parse(raw_json, watched_repos)
      self.new JSON.parse(raw_json), watched_repos
      @@events
    end

    # Instance
    def initialize(events, watched_repos)
      events.each do |event_json|
        event_classname = "GitHubNewsFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }
        event = event_class.new(event_json)
        event.repo[:watched] = watched_repos.include?(event.repo[:name])
        @@events.push event
      end
    end

  end
end
