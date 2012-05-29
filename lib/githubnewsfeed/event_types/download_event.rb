module GitHubNewsFeed
  class DownloadEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      @object = {
        :name => json['payload']['download']['name'],
        :url => json['payload']['download']['html_url'],
        :description => CGI::escapeHTML(json['payload']['download']['description'])
      }
    end

    def print
      "#{gh_link @actor[:username]}
      uploaded a file to
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago
      <ul>
        <li>\"#{@object[:name]}\" is at <a href=\"#{@object[:url]}\">#{@repo[:name]}/downloads</a></li>
      </ul>"
    end

  end
end
