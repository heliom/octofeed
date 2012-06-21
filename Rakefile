ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default)
end

# App version
require './lib/octofeed/version'

# `bundle exec rake deploy`
# * Compile and commit assets
# * Bump version
# * Create a new tag and push it
# * Push to Heroku
desc 'deploy app to heroku'
task :deploy => [:bump, :'assets:compile', :'assets:commit', :tag] do
  puts "Pushing to heroku"
  `git push -f heroku master`
  puts "=> Successfully pushed to heroku"
end

# `bundle exec rake bump`
# * Bump version
#   => increment the version patch (Major.Minor.Patch)
desc 'bump version'
task :bump do
  puts "Bumping version"
  version = OctoFeed::VERSION.split('.')
  major = version[0]
  minor = version[1]
  patch = version[2].to_i
  patch += 1
  new_version = "#{major}.#{minor}.#{patch}"

  puts "New version will be #{new_version}. Is that alright? (y||x.y.z)"
  answer = STDIN.gets.chomp
  @new_version = answer == 'y' || answer == '' ? new_version : answer

  if @new_version.match(/^[0-9]+.[0-9]+.[0-9]+$/) == nil
    puts "=> Invalid version #{@new_version}"
    puts '=> Aborting'
    exit
  end

  content = "module OctoFeed\n\s\sVERSION = '#{@new_version}'\nend"
  `echo "#{content}" > lib/octofeed/version.rb`
  puts "=> Successfully bumped version to #{@new_version}"
end

# `bundle exec rake tag`
# * Create a new tag and push it
desc 'create a new version tag'
task :tag do
  version = @new_version || OctoFeed::VERSION
  `git add lib/octofeed/version.rb && git commit -m "Bump version to #{version}"`
  `git tag v#{version} && git push --tags`
end

namespace :assets do
  # `bundle exec rake assets:compile`
  # * Compile stylesheets and javascripts
  desc 'compile assets'
  task :compile => [:compile_css, :compile_js] do
  end

  # `bundle exec rake assets:compile_css`
  # IN  => /app/assets/stylesheets/styles.styl
  # OUT => /public/css/styles.min.css
  desc 'compile css assets'
  task :compile_css do
    puts "Compiling stylesheets"
    version = @new_version || OctoFeed::VERSION

    sprockets = Sprockets::Environment.new
    sprockets.append_path 'app/assets/stylesheets'
    Stylus.setup sprockets
    Stylus.compress = true
    Stylus.use :nib

    asset = sprockets['styles.styl']
    outpath = File.join('public', 'css')
    outfile = Pathname.new(outpath).join("styles-#{version}.min.css")

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "=> Successfully compiled css assets"
  end

  # `bundle exec rake assets:compile_js`
  # IN  => /app/assets/javascripts/scripts.coffee
  # OUT => /public/js/scripts.min.js
  desc 'compile javascript assets'
  task :compile_js do
    puts "Compiling javascripts"
    version = @new_version || OctoFeed::VERSION

    sprockets = Sprockets::Environment.new
    sprockets.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
    sprockets.append_path 'app/assets/javascripts'

    asset     = sprockets['scripts.coffee']
    outpath   = File.join('public', 'js')
    outfile   = Pathname.new(outpath).join("scripts-#{version}.min.js")

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "=> Successfully compiled js assets"
  end

  # `bundle exec rake assets:commit`
  # => Commit compiled assets if there are modifications
  desc 'commit compiled assets'
  task :commit do
    puts "Removing #{OctoFeed::VERSION} assets"

    js_remove_path = "public/js/scripts-#{OctoFeed::VERSION}.min.js"
    css_remove_path = "public/css/styles-#{OctoFeed::VERSION}.min.css"
    `git rm #{js_remove_path} #{css_remove_path}`

    puts "Commiting compiled assets"
    `git add public/css public/js`
    `git commit -m "Update compiled assets"`
    puts "=> Successfully commited static assets"
  end
end
