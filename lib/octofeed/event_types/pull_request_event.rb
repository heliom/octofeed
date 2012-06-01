module OctoFeed
  class PullRequestEvent < OctoFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :number => json['payload']['number'],
        :title => CGI::escapeHTML(json['payload']['pull_request']['title']),
        :commits => json['payload']['pull_request']['commits'].to_i,
        :additions => json['payload']['pull_request']['additions'].to_i,
        :deletitions => json['payload']['pull_request']['deletitions'].to_i,
        :merged => json['payload']['pull_request']['merged'],
        :url => json['payload']['pull_request']['_links']['html']['href']
      }
    end

    def print
      action = @object[:merged] ? 'merged' : @object[:action]
      pull_request_link = %(<a href="#{@object[:url]}">pull request #{@object[:number]}</a>)

      commit = @object[:commits] > 1 ? 'commits' : 'commit'
      addition = @object[:additions] > 1 ? 'additions' : 'addition'
      deletition = @object[:deletitions] > 1 ? 'deletitions' : 'deletition'
      diff = "#{@object[:commits]} #{commit} with #{@object[:additions]} #{addition} and #{@object[:deletitions]} #{deletition}"

      description = truncate @object[:description]
      description = md_renderer(description)

      super({
        :title => "#{gh_link @actor[:username]} #{action} #{pull_request_link} on #{gh_link @repo[:name]}",
        :body => %(<blockquote title="#{@object[:description]}">#{description}</blockquote> <span>#{diff}</span>)
      })
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
