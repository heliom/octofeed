module OctoFeed
  class EventGroup
    attr_accessor :id, :icon, :title, :events
    @@instances = []

    # Static
    def self.all
      @@instances
    end

    def self.find_or_create(group_data)
      @@instances.each do |instance|
        return instance if instance.id == group_data[:id]
      end

      self.new group_data
    end

    # Instance
    def initialize(group_data)
      @id = group_data[:id]
      @icon = group_data[:icon]
      @title = group_data[:title]
      @events = []
      @@instances.push self
    end

    def add_event(event)
      @events.push event
    end

  end
end
