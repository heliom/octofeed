module GitHubNewsFeed
  class IssuesEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :number => json['payload']['issue']['number'],
        :url => json['payload']['issue']['html_url'],
        :title => json['payload']['issue']['title'],
        :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
      }
    end

  end
end
