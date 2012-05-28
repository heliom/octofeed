module GitHubNewsFeed
  class DownloadEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :name => json['payload']['download']['name'],
        :url => json['payload']['download']['html_url'],
        :description => json['payload']['download']['description']
      }
    end

  end
end
