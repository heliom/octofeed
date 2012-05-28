module GitHubNewsFeed
  class IssueCommentEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object =  {
        :action => json['payload']['action'],
        :id => json['payload']['comment']['id'],
        :body => json['payload']['comment']['body'],
        :issue => {
          :number => json['payload']['issue']['number'],
          :url => json['payload']['issue']['html_url'],
          :title => json['payload']['issue']['title'],
          :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
        }
      }
    end

    def print
      "#{gh_link @actor[:username]}
      commented
      on #{gh_issue_comment_link @object[:issue][:url], @object[:id], @object[:issue][:number], @object[:issue][:is_pull]}
      on #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

  end
end
