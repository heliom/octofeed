module OctoFeed
  class ForkApplyEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      # Todo:   Have yet to find a `ForkApplyEvent` example
      #         somewhere in https://api.github.com/events
      @object = {}
    end

    def print
      super({
        :title => @type
      })
    end

  end
end
