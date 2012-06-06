module OctoFeed
  class User
    attr_accessor :id, :username, :events, :token, :created_at

    # Static
    def self.find_or_create(username)
      data = self.find(username) || self.create(username)
      self.new data
    end

    def self.find(username)
      $mongo_db['users'].find_one('username' => username)
    end

    def self.create(username)
      id = $mongo_db['users'].insert({
        'username' => username,
        'events' => [],
        'created_at' => Time.now
      })

      $mongo_db['users'].find_one(id)
    end

    def self.update(username, query)
      $mongo_db['users'].update({'username' => username}, query, :upsert => true, :safe => true)
    end

    # Instance
    def initialize(data)
      @id = data['_id']
      @username = data['username']
      @events = data['events']
      @token = nil
      @created_at = data['created_at']
    end

    def add_event(event_id)
      OctoFeed::User.update @username, {'$push' => {'events' => event_id}}
    end

  end
end
