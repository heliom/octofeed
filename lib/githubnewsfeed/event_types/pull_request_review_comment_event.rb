module GitHubNewsFeed
  class PullRequestReviewCommentEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :id => json['payload']['comment']['id'],
        :body => json['payload']['comment']['body'],
        :commit => json['payload']['comment']['commit_id'],
        :path => json['payload']['comment']['path']
      }
    end

  end
end
