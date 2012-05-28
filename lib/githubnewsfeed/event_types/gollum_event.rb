module GitHubNewsFeed
  class GollumEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      pages = []
      json['payload']['pages'].each do |page|
        pages << {
          :name => page['name'],
          :action => page['action'],
          :url => page['url']
        }
      end

      @object = {
        :pages => pages
      }
    end

  end
end
