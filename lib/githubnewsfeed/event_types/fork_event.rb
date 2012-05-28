module GitHubNewsFeed
  class ForkEvent < GitHubNewsFeed::Event
    attr_accessor :object

    def initialize(json)
      super json

      @object = {
        :url => json['payload']['forkee']['html_url']
      }
    end

  end
end
