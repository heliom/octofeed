module GitHubNewsFeed
  class IssuesEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :number => json['payload']['issue']['number'],
        :url => json['payload']['issue']['html_url'],
        :title => CGI::escapeHTML(json['payload']['issue']['title']),
        :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
      }
    end

    def url
      %(<a href="#{@object[:url]}">issue #{@object[:number]}</a>)
    end

    def print
      "#{gh_link @actor[:username]}
      #{@object[:action]}
      #{url}
      on #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago"
    end

    def set_repo_group
      type = @object[:is_pull] ? 'pullrequest' : 'issue'
      hash = {
        :id => "#{@repo[:name]}-#{type}-#{@object[:number]}",
        :title => "#{@repo[:name]} #{url}"
      }
      super hash
    end

  end
end
