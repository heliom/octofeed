module OctoFeed
  class EventGroup
    attr_accessor :id, :type, :icon, :title, :name, :events

    def initialize(group_data)
      @id = group_data[:id]
      @type = group_data[:type]
      @icon = group_data[:icon]
      @title = group_data[:title]
      @name = group_data[:name]
      @events = []
    end

    def add_event(event)
      @events.push event
    end

  end
end
