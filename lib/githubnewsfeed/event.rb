module GitHubNewsFeed
  class Event
    attr_accessor :id, :type, :actor, :repo, :object, :created_at

    def initialize(json)
      # Event
      @id = json['id']
      @type = json['type']
      @created_at = json['created_at']

      # Actor
      @actor = {
        :id => json['actor']['id'],
        :username => json['actor']['login'],
        :avatar => json['actor']['avatar_url']
      }

      # Repo
      @repo = {
        :id => json['repo']['id'],
        :name => json['repo']['name']
      }

      # Object
      @object = case @type
      when 'CommitCommentEvent'
        {
          :commit => json['payload']['comment']['commit_id'],
          :body => json['payload']['comment']['body'],
          :url => json['payload']['comment']['html_url']
        }
      when 'CreateEvent', 'DeleteEvent'
        {
          :type => json['payload']['ref_type'],
          :ref => json['payload']['ref']
        }
      when 'DownloadEvent'
        {
          :name => json['payload']['download']['name'],
          :url => json['payload']['download']['html_url'],
          :description => json['payload']['download']['description']
        }
      when 'FollowEvent'
        {
          :id => json['payload']['target']['id'],
          :username => json['payload']['target']['login'],
          :avatar => json['payload']['target']['avatar_url'],
          :repos => json['payload']['target']['public_repos'],
          :followers => json['payload']['target']['followers']
        }
      when 'ForkEvent'
        {
          :url => json['payload']['forkee']['html_url']
        }
      when 'ForkApplyEvent'
        # Todo:   Have yet to find a `ForkApplyEvent` example
        #         somewhere in https://api.github.com/events
        {}
      when 'GistEvent'
        {
          :id => json['payload']['action'],
          :id => json['payload']['gist']['id'],
          :url => json['payload']['gist']['html_url'],
          :description => json['payload']['gist']['description']
        }
      when 'GollumEvent'
        pages = []
        json['payload']['pages'].each do |page|
          pages << {
            :name => page['name'],
            :action => page['action'],
            :url => page['url']
          }
        end
        pages
      when 'IssueCommentEvent'
        {
          :action => json['payload']['action'],
          :id => json['payload']['comment']['id'],
          :body => json['payload']['comment']['body'],
          :issue => {
            :number => json['payload']['issue']['number'],
            :url => json['payload']['issue']['html_url'],
            :title => json['payload']['issue']['title'],
            :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
          }
        }
      when 'IssuesEvent'
        {
          :action => json['payload']['action'],
          :number => json['payload']['issue']['number'],
          :url => json['payload']['issue']['html_url'],
          :title => json['payload']['issue']['title'],
          :is_pull => json['payload']['issue']['pull_request']['html_url'] ? true : false
        }
      when 'MemberEvent'
        {
          :action => json['payload']['action'],
          :id => json['payload']['member']['id'],
          :username => json['payload']['member']['login'],
          :avatar => json['payload']['member']['avatar_url']
        }
      when 'PublicEvent'
        # This is meant to be empty. No payload
        {}
      when 'PullRequestEvent'
        {
          :action => json['payload']['action'],
          :number => json['payload']['number'],
          :title => json['payload']['pull_request']['title'],
          :commits => json['payload']['pull_request']['commits'],
          :additions => json['payload']['pull_request']['additions'],
          :deletitions => json['payload']['pull_request']['deletitions']
        }
      when 'PullRequestReviewCommentEvent'
        {
          :id => json['payload']['comment']['id'],
          :body => json['payload']['comment']['body'],
          :commit => json['payload']['comment']['commit_id'],
          :path => json['payload']['comment']['path']
        }
      when 'PushEvent'
        commits = []
        json['payload']['commits'].each do |commit|
          commits << {
            :message => commit['message'],
            :sha => commit['sha'],
            :author => commit['author']['name']
          }
        end

        {
          :ref => json['payload']['ref'],
          :commits => commits
        }
      when 'TeamAddEvent'
        {
          :team => json['payload']['team']['name'],
          :user => json['payload']['user']['login']
        }
      when 'WatchEvent'
        {
          :action => json['payload']['action']
        }
      else
        {}
      end
    end

  end
end
