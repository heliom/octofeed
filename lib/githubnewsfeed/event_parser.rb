module GitHubNewsFeed
  class EventParser

    # Static
    def self.parse(raw_json, watched_repos)
      self.new JSON.parse(raw_json), watched_repos
    end

    # Instance
    def initialize(events, watched_repos)
      events.each do |event_json|
        event_classname = "GitHubNewsFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }
        event = event_class.new(event_json)
        event.set_group watched_repos.include?(event.repo[:name])

        group = GitHubNewsFeed::EventGroup.find_or_create(event.group)
        group.add_event event
      end
    end

  end
end
