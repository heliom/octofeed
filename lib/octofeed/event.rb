# The OctoFeed::Event is a superclass
# All event_types extends this class
module OctoFeed
  class Event
    attr_accessor :id, :type, :actor, :repo, :object, :created_at, :group

    def initialize(json, opts)
      # Event
      @id = json['id']
      @type = json['type']
      @created_at = json['created_at']
      @group = ''
      @user = opts[:user]

      # Actor
      @actor = {
        :id => json['actor']['id'],
        :username => json['actor']['login'],
        :avatar => json['actor']['avatar_url']
      }

      # Repo
      @repo = {
        :id => json['repo']['id'],
        :name => json['repo']['name'],
        :watched => false
      }
    end

    # Public method
    # Set the event group depending on if the repo is being watched or not
    # This will create a `user-group` or `repo-group` event type
    # Each event_types class has (or not) its own set_repo_group and set_user_group methods
    # These methods set a hash of options and call `super`
    def set_group(watched_repo)
      @repo[:watched] = watched_repo
      @group = case watched_repo
               when true then set_repo_group
               else set_user_group
               end
    end

    # Public method
    # If both are true, the event is added to the database
    def is_new?
      is_new = is_more_recent? && has_never_been_printed?
      @user.add_event(@id) if is_new

      is_new
    end

    # Public method
    # Test if an event is more recent than the created_at value of a user
    # No need to add older events in the database, for they will never be flagged `new`
    def is_more_recent?
      Time.parse(@created_at) > @user.created_at
    end

    # Public method
    # Test if an event has never been printed before
    def has_never_been_printed?
      !@user.events.include?(@id)
    end

    private
    # Helper that wraps extra/meta group data into a span
    # Extras are for example: pull request and issue number, branch of the group, etc.
    def extra(msg)
      %(<span class="extra">#{msg}</span>)
    end

    # This is almost always called by child classes
    # Will create a 'user-group' type event
    # This hash is accessible via `@group`
    # The id of an `event.group` is used to group said events
    def set_user_group(opts={})
      {
        :type => opts[:type] || 'user-group',
        :id => opts[:id] || @actor[:username],
        :icon => opts[:icon] || @actor[:avatar],
        :title => opts[:title] || gh_link(@actor[:username]),
        :name => opts[:name] || @actor[:username],
        :data => opts[:data] || nil
      }
    end

    def set_repo_group(opts={})
      {
        :type => opts[:type] || 'repo-group',
        :id => opts[:id] || @repo[:name],
        :icon => opts[:icon] || '/images/repo-default.png',
        :title => opts[:title] || gh_user_repo_link(@repo[:name]),
        :name => opts[:name] || @repo[:name]
      }
    end

    # Protected print method
    # Each event types has a public print method that calls super(hash)
    # Easier to maintain / update events html
    def print(msg)
      body = msg[:body] && msg[:body].length > 0 ? %(<div class="body">#{msg[:body]}</div>) : ''
      time_ago = msg[:time_ago] || time_ago_in_words(Time.parse(@created_at))

      %(
        <div class="title">
          <img width="30" height="30" src="#{@actor[:avatar]}">
          #{msg[:title]} #{time_ago}
        </div>
        #{body}
       )
    end

  end
end
