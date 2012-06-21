module OctoFeed
  class WatchEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :action => json['payload']['action']
      }
    end

    def print
      super({
        :title => "#{gh_user_link @actor[:username]} #{@object[:action]} watching #{gh_link @repo[:name]}"
      })
    end

  end
end
