# encoding: utf-8

module OctoFeed
  class PushEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      commits = []
      json['payload']['commits'].each do |commit|
        commits << {
          :message => CGI::escapeHTML(commit['message']),
          :sha => commit['sha'],
          :author => {
            :name => commit['author']['name'],
            :email => commit['author']['email']
          }
        }
      end

      @object = {
        :ref => json['payload']['ref'],
        :commits => commits.reverse
      }
    end

    def ref
      ref_name = @object[:ref].gsub('refs/heads/', '')
      return ref_name if ref_name == 'master'
      gh_tree_link @repo[:name], ref_name
    end

    def print
      commits_content = ''
      @object[:commits].take(3).each do |commit|
        email = Digest::MD5.hexdigest(commit[:author][:email])
        default = CGI::escape('https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-140.png')
        avatar = "http://www.gravatar.com/avatar/#{email}?d=#{default}&s=40"
        message = truncate commit[:message].split(/\n\n/).first, :length => 70

        commits_content << %(
          <li>
            <img width="20" height="20" src="#{avatar}">
            <code>#{gh_sha_link @repo[:name], commit[:sha]}</code>
            <blockquote title="#{commit[:message]}">#{md_renderer message, @repo[:name]}</blockquote>
          </li>
        )
      end

      commit_count = @object[:commits].length
      if commit_count >= 2
        first_commit_sha = @object[:commits].first[:sha]
        last_commit_sha = @object[:commits].last[:sha]
        uri = URI.parse("https://api.github.com/repos/#{@repo[:name]}/git/commits/#{last_commit_sha}?access_token=#{@user.token}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        last_commit = JSON.parse(response.body)
        previous_commit_sha = last_commit['parents'][0]['sha']
        link_url = "#{@repo[:name]}/compare/#{previous_commit_sha[0..9]}...#{first_commit_sha[0..9]}"

        if commit_count > 3
          difference = commit_count - 3
          plural = difference == 1 ? '' : 's'

          link_label = "#{difference} more commit#{plural} »"
          link = gh_link link_url, :label => link_label

          commits_content << "<li>#{link}</li>"
        else
          link_label = "View comparison for these #{commit_count} commits »"
          link = gh_link link_url, :label => link_label

          commits_content << "<li>#{link}</li>"
        end
      end

      super({
        :title => "#{gh_user_link @actor[:username]} pushed to #{ref} at #{gh_link @repo[:name]}",
        :body => "<ul>#{commits_content}</ul>"
      })
    end

    def get_group_hash
      { :id => "#{@repo[:name]}-commits-#{ref}" }
    end

    def set_user_group
      hash = get_group_hash
      hash[:title] = "#{gh_link @actor[:username]} => #{gh_repo_link @repo[:name]}"
      super hash
    end

    def set_repo_group
      hash = get_group_hash
      super hash
    end

  end
end
