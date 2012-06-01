module OctoFeed
  class IssueCommentEvent < OctoFeed::Event

    def initialize(json)
      super json

      @object =  {
        :action => json['payload']['action'],
        :id => json['payload']['comment']['id'],
        :body => CGI::escapeHTML(json['payload']['comment']['body']),
        :issue => {
          :number => json['payload']['issue']['number'],
          :url => json['payload']['issue']['html_url'],
          :title => CGI::escapeHTML(json['payload']['issue']['title']),
          :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
        }
      }
    end

    def print
      comment_link = gh_issue_comment_link @object[:issue][:url], @object[:id], @object[:issue][:number], @object[:issue][:is_pull]
      message = truncate @object[:body]
      message = md_renderer(message)

      super({
        :title => "#{gh_link @actor[:username]} commented on #{comment_link} on #{gh_link @repo[:name]}",
        :body => %(<blockquote title="#{@object[:body]}">#{message}</blockquote>)
      })
    end

    def set_repo_group
      type = @object[:issue][:is_pull] ? 'pullrequest' : 'issue'
      hash = {
        :id => "#{@repo[:name]}-#{type}-#{@object[:issue][:number]}",
        :title => "#{@repo[:name]} #{gh_issue_link @repo[:name], @object[:issue][:number], @object[:issue][:is_pull]}"
      }
      super hash
    end

  end
end
