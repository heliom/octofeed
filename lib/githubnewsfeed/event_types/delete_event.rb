module GitHubNewsFeed
  class DeleteEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :type => json['payload']['ref_type'],
        :ref => json['payload']['ref']
      }
    end

    def print
      link = case @object[:type]
             when 'branch', 'tag' then "#{@object[:ref]} at #{gh_link @repo[:name]}"
             else "#{gh_link @repo[:name]}"
             end

      super({
        :title => "#{gh_link @actor[:username]} deleted #{@object[:type]} #{link}"
      })
    end

  end
end
