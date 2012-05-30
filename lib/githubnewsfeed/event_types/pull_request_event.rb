module GitHubNewsFeed
  class PullRequestEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :number => json['payload']['number'],
        :title => CGI::escapeHTML(json['payload']['pull_request']['title']),
        :commits => json['payload']['pull_request']['commits'],
        :additions => json['payload']['pull_request']['additions'],
        :deletitions => json['payload']['pull_request']['deletitions'],
        :merged => json['payload']['pull_request']['merged'],
        :url => json['payload']['pull_request']['_links']['html']['href']
      }
    end

    def print
      action = @object[:merged] ? 'merged' : @object[:action]

      %(#{gh_link @actor[:username]}
      #{action}
      <a href="#{@object[:url]}">pull request #{@object[:number]}</a>
      on #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago)
    end

    def set_repo_group
      hash = {
        :id => "#{@repo[:name]}-pullrequest-#{@object[:number]}",
        :title => "#{@repo[:name]} #{gh_issue_link @repo[:name], @object[:number], true}"
      }
      super hash
    end

  end
end
