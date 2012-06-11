module OctoFeed
  class DeleteEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :type => json['payload']['ref_type'],
        :ref => json['payload']['ref']
      }
    end

    def ref(with_repo=true)
      case @object[:type]
      when 'branch', 'tag'
        if with_repo
          "#{@object[:ref]} at #{gh_link @repo[:name]}"
        else
          %(<a>#{@object[:ref]}</a>)
        end
      else "#{gh_link @repo[:name]}"
      end
    end

    def print
      super({
        :title => "#{gh_user_link @actor[:username]} deleted #{@object[:type]} #{ref}"
      })
    end

    def set_repo_group
      super({
        :id => "#{@repo[:name]}-commits-#{@object[:ref]}",
        :title => "#{gh_user_repo_link @repo[:name]} #{extra(ref false)}"
      })
    end

  end
end
