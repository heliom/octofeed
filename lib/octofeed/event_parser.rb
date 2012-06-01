module OctoFeed
  class EventParser

    # Static
    def self.parse(raw_json, watched_repos, session)
      self.new JSON.parse(raw_json), watched_repos, session
    end

    # Instance
    def initialize(events, watched_repos, session)
      events.each do |event_json|
        event_classname = "OctoFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }
        if event_class == OctoFeed::FollowEvent
          event = event_class.new(event_json, session)
        else
          event = event_class.new(event_json)
        end
        event.set_group watched_repos.include?(event.repo[:name])

        group = OctoFeed::EventGroup.find_or_create(event.group)
        group.add_event event
      end
    end

  end
end
