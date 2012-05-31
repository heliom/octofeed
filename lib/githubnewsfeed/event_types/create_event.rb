# encoding: utf-8

module GitHubNewsFeed
  class CreateEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :type => json['payload']['ref_type'],
        :ref => json['payload']['ref'],
        :description => json['payload']['description']
      }
    end

    def print
      link = case @object[:type]
             when 'branch', 'tag' then "#{gh_tree_link @repo[:name], @object[:ref]} at #{gh_link @repo[:name]}"
             else gh_link @repo[:name]
             end

      body = case @object[:type]
             when 'repository' then @object[:description]
             when 'branch' then gh_link "#{@repo[:name]}/compare/#{@object[:ref]}", "Compare #{@object[:ref]} branch with master »"
             else ''
             end

      super({
        :title => "#{gh_link @actor[:username]} created #{@object[:type]} #{link}",
        :body => body
      })
    end

  end
end
