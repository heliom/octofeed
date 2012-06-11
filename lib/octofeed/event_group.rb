module OctoFeed
  class EventGroup
    attr_accessor :id, :type, :icon, :name, :events

    def initialize(group_data)
      @id = group_data[:id]
      @type = group_data[:type]
      @icon = group_data[:icon]
      @title = group_data[:title]
      @name = group_data[:name]
      @data = []
      @events = []
    end

    def title
      if @type.include?('current-user')
        others_length = @data.length - 1
        if others_length == 1
          "#{gh_link @data[0]} and #{gh_link @data[1]} started following you"
        elsif others_length > 1
          "#{gh_link @data[0]} and #{others_length} others started following you"
        else
          "#{gh_link @data[0]} started following you"
        end
      else
        @title
      end
    end

    def add_event(event)
      @events.push event
    end

    def add_data(data)
      @data.push data
    end

  end
end
