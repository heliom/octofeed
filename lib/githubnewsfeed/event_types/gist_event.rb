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

    def print
      "#{gh_link @actor[:username]}
      #{@object[:action]}d
      #{gh_gist_link @object[:id], @object[:url]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
