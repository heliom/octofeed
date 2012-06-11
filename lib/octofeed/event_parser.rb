module OctoFeed
  class EventParser
    attr_accessor :groups

    def initialize(raw_json, watched_repos, user)
      @groups = []
      @user = user
      @watched_repos = watched_repos
      events = JSON.parse(raw_json)

      events.each do |event_json|
        event_classname = "OctoFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }

        event = event_class.new(event_json, { :user => @user })
        event.set_group is_watching?(event.repo[:name])

        group = find_or_create_group(event.group)
        group.add_event event

        # Pushes generic data into an array
        # Only used by FollowEvent for now
        group.add_data(event.group[:data]) if event.group[:data]
      end
    end

    def is_watching?(repo_name)
      @watched_repos.include?(repo_name) || repo_name.include?(@user.username)
    end

    def find_or_create_group(group_data)
      @groups.each do |group|
        return group if group.id == group_data[:id]
      end

      new_group = OctoFeed::EventGroup.new group_data
      @groups.push new_group
      new_group
    end

  end
end
