module GitHubNewsFeed
  class GistEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :id => json['payload']['gist']['id'],
        :url => json['payload']['gist']['html_url'],
        :description => json['payload']['gist']['description']
      }
    end

  end
end
