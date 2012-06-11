# encoding: utf-8

module OctoFeed
  class CreateEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :type => json['payload']['ref_type'],
        :ref => json['payload']['ref'],
        :description => json['payload']['description']
      }
    end

    def link(only_ref=false)
      case @object[:type]
      when 'branch', 'tag'
        link = "#{gh_tree_link @repo[:name], @object[:ref]}"
        link += " at #{gh_link @repo[:name]}" if !only_ref
        link
      else gh_link @repo[:name]
      end
    end

    def print
      body = case @object[:type]
             when 'repository' then @object[:description]
             when 'branch' then gh_link "#{@repo[:name]}/compare/#{@object[:ref]}", :label => "Compare #{@object[:ref]} branch with master »"
             else ''
             end

      super({
        :title => "#{gh_user_link @actor[:username]} created #{@object[:type]} #{link}",
        :body => body
      })
    end

    def set_repo_group
      super({
        :id => "#{@repo[:name]}-commits-#{@object[:ref]}",
        :title => "#{gh_user_repo_link @repo[:name]} #{extra(link true)}"
      })
    end

  end
end
