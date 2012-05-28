module GitHubNewsFeed
  class PushEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      commits = []
      json['payload']['commits'].each do |commit|
        commits << {
          :message => commit['message'],
          :sha => commit['sha'],
          :author => commit['author']['name']
        }
      end

      @object = {
        :ref => json['payload']['ref'],
        :commits => commits
      }
    end

  end
end
