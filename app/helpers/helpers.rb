def https_request(url)
  uri = URI.parse(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)
  http.request(request)
end

# http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-time_ago_in_words
def time_ago_in_words(from_time, opts={})
  if opts[:html] == false
    distance_of_time_in_words(from_time, Time.now, false)
  else
    %(<time datetime="#{from_time}" title="#{from_time.to_s.split(/\s/)[0..1].join(' ')}">#{distance_of_time_in_words(from_time, Time.now, false)} ago</time>)
  end
end

# http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-distance_of_time_in_words
def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
  from_time = from_time.to_time if from_time.respond_to?(:to_time)
  to_time = to_time.to_time if to_time.respond_to?(:to_time)
  distance_in_minutes = (((to_time - from_time).abs)/60).round
  distance_in_seconds = ((to_time - from_time).abs).round

  case distance_in_minutes
    when 0..1
      return distance_in_minutes == 0 ?
             "less than a minute" :
             "#{distance_in_minutes} minutes" unless include_seconds

      case distance_in_seconds
        when 0..4   then "less than 5 seconds"
        when 5..9   then "less than 10 seconds"
        when 10..19 then "less than 20 seconds"
        when 20..39 then "half a minute"
        when 40..59 then "less than a minute"
        else             "a minute"
      end

    when 2..44           then "#{distance_in_minutes} minutes"
    when 45..89          then "an hour"
    when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} hours"
    when 1440..2519      then "a day"
    when 2520..43199     then "#{(distance_in_minutes.to_f / 1440.0).round} days"
    when 43200..86399    then "a month"
    when 86400..525599   then "#{(distance_in_minutes.to_f / 43200.0).round} months"
    else
      fyear = from_time.year
      fyear += 1 if from_time.month >= 3
      tyear = to_time.year
      tyear -= 1 if to_time.month < 3
      leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
      minute_offset_for_leap_year = leap_years * 1440
      # Discount the leap year days when calculating year distance.
      # e.g. if there are 20 leap year days between 2 dates having the same day
      # and month then the based on 365 days calculation
      # the distance in years will come out to over 80 years when in written
      # english it would read better as about 80 years.
      minutes_with_offset         = distance_in_minutes - minute_offset_for_leap_year
      remainder                   = (minutes_with_offset % 525600)
      distance_in_years           = (minutes_with_offset / 525600)
      if remainder < 131400
        if distance_in_years == 1
          "about a year"
        else
          "about #{distance_in_years} years"
        end
      elsif remainder < 394200
        if distance_in_years == 1
          "over a year"
        else
          "over #{distance_in_years} years"
        end
      else
        if distance_in_years + 1 == 1
          "almost a year"
        else
          "almost #{distance_in_years} years"
        end
      end
  end
end

# Assets tag helper
# Uses sprockets in development and local precompiled files in production
def javascript_include_tag(file_name)
  path_prefix = development? ? '/assets/' : '/js/'
  min_suffix = development? ? '' : '.min'
  %(<script src="#{path_prefix}#{file_name}#{min_suffix}.js"></script>)
end

def stylesheet_include_tag(file_name)
  path_prefix = development? ? '/assets/' : '/css/'
  min_suffix = development? ? '' : '.min'
  %(<link rel="stylesheet" href="#{path_prefix}#{file_name}#{min_suffix}.css">)
end

# Little-tiny-homemade Markdown parser
# => Remove images ![alt](http://example.org/image.png)
# => Convert [link](http://example.org) into a link
# => Convert SHAs into a link
def md_renderer(content, repo)
  content = content.gsub /\!\[([^\]]+)\]\(([^)]+)\)/, ''
  content = content.gsub /\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>'
  content.gsub(/\b([0-9a-f]{40})\b/) { gh_sha_link(repo, $1) }
end

# Long message/comment truncate helper
def truncate(content, opts={})
  length = opts[:length] || 150
  length_in_chars = opts[:length_in_chars] || true

  HTML_Truncator.truncate content, length, :length_in_chars => length_in_chars
end

# Link to `https://github.com/path`
def gh_link(path, opts={})
  link_class = opts[:class] ? %(class="#{opts[:class]}") : ''
  link_label = opts[:label] || path
  link_url = opts[:url] || "https://github.com/#{path}"

  %(<a #{link_class} href="#{link_url}">#{link_label}</a>)
end

# Link to a user
def gh_user_link(username, opts={})
  opts[:class] = opts[:class] || 'username'
  gh_link username, opts
end

# Link to a repo
def gh_repo_link(repo, opts={})
  opts[:class] = opts[:class] || 'repo'
  gh_link repo, opts
end

# Convert a full repo name (user/repo) into 2 links
def gh_user_repo_link(repo, opts={})
  repo_split = repo.split('/')
  repo_user = repo_split[0]
  repo_name = repo_split[1]

  "#{gh_link repo_user} / #{gh_repo_link repo, :label => repo_name}"
end

# Link to an issue/pull request
def gh_issue_link(repo, number, opts={})
  type = opts[:is_pull] ? 'pull' : 'issues'
  label = opts[:is_pull] ? 'pull request' : 'issue'

  opts[:label] = "#{label} #{number}"
  gh_link "#{repo}/#{type}/#{number}", opts
end

# Link to an issue/pull request comment
def gh_issue_comment_link(url, comment_id, issue_number, opts={})
  type = 'issue'
  if opts[:is_pull]
    url = url.gsub('/issues/', '/pull/')
    type = 'pull request'
  end

  opts[:label] = "#{type} #{issue_number}"
  opts[:url] = "#{url}#issuecomment-#{comment_id}"

  gh_link nil, opts
end

# Link to a gist
def gh_gist_link(id, url, opts={})
  opts[:label] = "gist: #{id}"
  opts[:url] = url

  gh_link nil, opts
end

# Link to a sha
def gh_sha_link(repo, sha)
  path = "#{repo}/commit/#{sha}"
  label = sha[0..6]

  gh_link path, :label => label
end

# Link to a branch/tag
def gh_tree_link(repo, tree_node)
  path = "#{repo}/tree/#{tree_node}"
  gh_link path, :label => tree_node
end

# Link to a file comment
def gh_commit_comment_link(repo, comment_id, commit_id)
  path = "#{repo}/commit/#{commit_id}#commitcomment-#{comment_id}"
  label = commit_id[0..9]

  gh_link path, :label => label
end
