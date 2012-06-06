module OctoFeed
  class GistEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :action => json['payload']['action'],
        :id => json['payload']['gist']['id'],
        :url => json['payload']['gist']['html_url'],
        :description => CGI::escapeHTML(json['payload']['gist']['description'])
      }
    end

    def print
      super({
        :title => "#{gh_user_link @actor[:username]} #{@object[:action]}d #{gh_gist_link @object[:id], @object[:url]}",
        :body => @object[:description]
      })
    end

    def set_user_group
      super({
        :id => "#{@actor[:username]}-gist-#{@object[:id]}",
        :title => "#{gh_link @actor[:username]} / #{gh_gist_link @object[:id], @object[:url], :class => 'repo'}"
      })
    end

  end
end
