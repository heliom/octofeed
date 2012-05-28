module GitHubNewsFeed
  class CommitCommentEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json
      
      @object = {
        :commit => json['payload']['comment']['commit_id'],
        :body => json['payload']['comment']['body'],
        :url => json['payload']['comment']['html_url']
      }
    end
    
  end
end
