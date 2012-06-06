module OctoFeed
  class IssuesEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

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
      title = truncate @object[:title]
      title = md_renderer(title)

      super({
        :title => "#{gh_user_link @actor[:username]} #{@object[:action]} #{url} on #{gh_link @repo[:name]}",
        :body => %(<blockquote title="#{@object[:title]}">#{title}</blockquote>)
      })
    end

    def set_repo_group
      type = @object[:is_pull] ? 'pullrequest' : 'issue'
      super({
        :id => "#{@repo[:name]}-#{type}-#{@object[:number]}",
        :title => "#{gh_user_repo_link @repo[:name]} #{extra(url)}"
      })
    end

  end
end
