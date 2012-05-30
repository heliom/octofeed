module GitHubNewsFeed
  class CommitCommentEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :id => json['payload']['comment']['id'],
        :commit => json['payload']['comment']['commit_id'],
        :body => CGI::escapeHTML(json['payload']['comment']['body']),
        :url => json['payload']['comment']['html_url']
      }
    end

    def print
      "#{gh_link @actor[:username]}
      commented on
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago
      <ul>
        <li>Comment in #{gh_commit_comment_link @repo[:name], @object[:id], @object[:commit]}</li>
      </ul>"
    end

    def set_repo_group
      hash = {
        :id => "#{@repo[:name]}-commitcomment-#{@object[:commit]}",
        :title => %(#{@repo[:name]} <a href="https://github.com/#{@repo[:name]}/commit/#{@object[:commit]}">commit #{@object[:commit][0..9]}</a>)
      }
      super hash
    end

  end
end
