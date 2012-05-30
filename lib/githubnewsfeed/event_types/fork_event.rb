module GitHubNewsFeed
  class ForkEvent < GitHubNewsFeed::Event
    attr_accessor :object

    def initialize(json)
      super json

      @object = {
        :url => json['payload']['forkee']['html_url']
      }
    end

    def print
      "#{gh_link @actor[:username]}
      forked
      #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)}"
    end

    def set_repo_group
      set_user_group
    end

  end
end
