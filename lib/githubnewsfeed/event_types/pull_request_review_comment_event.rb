module GitHubNewsFeed
  class PullRequestReviewCommentEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :id => json['payload']['comment']['id'],
        :body => json['payload']['comment']['body'],
        :commit => json['payload']['comment']['commit_id'],
        :path => json['payload']['comment']['path'],
        :url => json['payload']['comment']['_links']['html']['href'],
        :number => json['payload']['comment']['_links']['pull_request']['href'].split('/').last
      }
    end

    def print
      "#{gh_link @actor[:username]}
      commented on
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago
      <ul>
        <li>Comment in <a href=\"#{@object[:url]}\">#{@object[:path]}</a> in <a href=\"#{@object[:url].split('#').first}\">pull request #{@object[:number]}</a></li>
      </ul>"
    end

  end
end
