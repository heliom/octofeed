module OctoFeed
  class DownloadEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :name => json['payload']['download']['name'],
        :url => json['payload']['download']['html_url'],
        :description => CGI::escapeHTML(json['payload']['download']['description'])
      }
    end

    def print
      link = %(<a href="#{@object[:url]}">#{@repo[:name]}/downloads</a>)
      description = truncate @object[:description]
      description = md_renderer(description, @repo[:name])

      super({
        :title => "#{gh_user_link @actor[:username]} uploaded a file to #{gh_link @repo[:name]}",
        :body => %("#{@object[:name]}" is at #{link} <blockquote title="#{@object[:description]}">#{description}</blockquote>)
      })
    end

  end
end
