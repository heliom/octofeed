module OctoFeed
  class ForkEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :name => json['payload']['forkee']['name']
      }
    end

    def print
      fork_full_name = "#{@actor[:username]}/#{@object[:name]}"
      super({
        :title => "#{gh_user_link @actor[:username]} forked #{gh_link @repo[:name]}",
        :body => "Forked repository is at #{gh_link fork_full_name}"
      })
    end

    def set_repo_group
      set_user_group
    end

  end
end
