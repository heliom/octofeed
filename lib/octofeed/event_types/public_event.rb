module OctoFeed
  class PublicEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts
    end

    def print
      super({
        :title => "#{gh_user_link @actor[:username]} open sourced #{gh_link @repo[:name]}"
      })
    end

  end
end
