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
      action = case @object[:type]
               when 'branch', 'tag' then "#{@object[:ref]} at #{gh_link @repo[:name]}"
               else "#{gh_link @repo[:name]}"
               end

      "#{gh_link @actor[:username]}
      deleted #{@object[:type]}
      #{action}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
