module OctoFeed
  class PullRequestReviewCommentEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :id => json['payload']['comment']['id'],
        :body => CGI::escapeHTML(json['payload']['comment']['body']),
        :commit => json['payload']['comment']['commit_id'],
        :path => json['payload']['comment']['path'],
        :url => json['payload']['comment']['_links']['html']['href'],
        :number => json['payload']['comment']['_links']['pull_request']['href'].split('/').last
      }
    end

    def print
      message = truncate @object[:body]
      message = md_renderer(message)
      path_link = %(<a href="#{@object[:url]}">#{@object[:path]}</a>)
      pull_request_link = %(<a href="#{@object[:url].split('#').first}">pull request #{@object[:number]}</a>)

      super({
        :title => "#{gh_user_link @actor[:username]} commented on #{gh_link @repo[:name]}",
        :body => %(Comment on #{path_link} in #{pull_request_link}: <blockquote title="#{@object[:body]}">#{message}</blockquote>)
      })
    end

    def set_repo_group
      link_opts = { :is_pull => true }

      super({
        :id => "#{@repo[:name]}-pullrequest-#{@object[:number]}",
        :title => "#{gh_user_repo_link @repo[:name]} #{extra(gh_issue_link @repo[:name], @object[:number], link_opts)}"
      })
    end

  end
end
