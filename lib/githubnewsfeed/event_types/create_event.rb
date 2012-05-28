module GitHubNewsFeed
  class CreateEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :type => json['payload']['ref_type'],
        :ref => json['payload']['ref']
      }
    end

  end
end
