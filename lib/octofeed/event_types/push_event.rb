# encoding: utf-8

module OctoFeed
  class PushEvent < OctoFeed::Event

    def initialize(json)
      super json

      commits = []
      json['payload']['commits'].each do |commit|
        commits << {
          :message => CGI::escapeHTML(commit['message']),
          :sha => commit['sha'],
          :author => commit['author']['name']
        }
      end

      @object = {
        :ref => json['payload']['ref'],
        :commits => commits
      }
    end

    def ref
      ref_name = @object[:ref].gsub('refs/heads/', '')
      return ref_name if ref_name == 'master'
      gh_tree_link @repo[:name], ref_name
    end

    def print
      commits_content = ''
      @object[:commits].reverse.each do |commit|
        commits_content << %(
          <li>
            <code>#{gh_sha_link @repo[:name], commit[:sha]}</code>
            <blockquote title="#{commit[:message]}">#{md_renderer commit[:message].split(/\n\n/).first}</blockquote>
          </li>
        )
      end

      super({
        :title => "#{gh_link @actor[:username]} pushed to #{ref} at #{gh_link @repo[:name]}",
        :body => "<ul>#{commits_content}</ul>"
      })
    end

    def get_group_hash
      { :id => "#{@repo[:name]}-commits-#{ref}" }
    end

    def set_user_group
      hash = get_group_hash
      hash[:title] = "#{@actor[:username]} pushed to #{ref} at #{gh_link @repo[:name]}"
      super hash
    end

    def set_repo_group
      hash = get_group_hash
      hash[:title] = "#{@repo[:name]} — fresh new code"
      super hash
    end

  end
end
