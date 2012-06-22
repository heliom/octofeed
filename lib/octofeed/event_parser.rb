module OctoFeed
  class EventParser
    attr_accessor :groups

    def initialize(raw_json, watched_repos, followed_users, user, limit=0)
      @groups = []
      @user = user
      @watched_repos = watched_repos
      @followed_users = followed_users
      events = JSON.parse(raw_json)
      events = events[0...limit] if limit > 0

      # Loop through each js object received
      # Figures out the class and instantiate a new event
      events.each do |event_json|
        event_classname = "OctoFeed::#{event_json['type']}"
        event_class = event_classname.split('::').inject(Object) { |o,c| o.const_get c }

        # Set the group type of the event depending if the user watch the event repo or not
        # Once the group is set, we have unique group ids
        # eg. reponame-pullrequest-1, reponame-issue-345, user, user-gist-123
        event = event_class.new(event_json, { :user => @user })
        event.set_group is_watching?(event.repo[:name])

        # Find or create a group with the event group data
        # Then add the event to the group
        group = find_or_create_group(event.group)
        group.add_event event

        # Pushes generic data into an array
        # Only used by FollowEvent for now
        group.add_data(event.group[:data]) if event.group[:data]
      end
    end

    # Test if repo is in the watched repos list
    # Test if the user name is in the repo name (user/repo), because your own repos aren’t in that list
    def is_watching?(repo_name)
      @watched_repos.include?(repo_name) || repo_name.include?("#{@user.username}/")
    end

    # Test if actor is in the followed users list
    def is_following?(username)
      @followed_users.include?(username)
    end

    # Loop through already created groups
    # Stop and return the group if one is found with the same id
    # Or return a new group
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
