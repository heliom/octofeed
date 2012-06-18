# A tiny-custom-homemade ORM class
module OctoFeed
  class User
    attr_accessor :id, :username, :token, :last_updated

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
        'last_updated' => Time.now
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
      @token = nil
      @last_updated = data['last_updated']
    end

    # Set the `last_updated` value of the user to `Time.now`
    # To be able to test if an event has already been read by the user
    def update_last_updated
      OctoFeed::User.update @username, {'$set' => {'last_updated' => Time.now}}
    end

  end
end
