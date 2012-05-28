module GitHubNewsFeed
  class PullRequestEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :number => json['payload']['number'],
        :title => json['payload']['pull_request']['title'],
        :commits => json['payload']['pull_request']['commits'],
        :additions => json['payload']['pull_request']['additions'],
        :deletitions => json['payload']['pull_request']['deletitions']
      }
    end

  end
end
