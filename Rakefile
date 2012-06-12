ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default)
end
require './lib/octofeed/version'

desc 'deploy app to heroku'
task :deploy => [:'assets:compile', :'assets:commit', :bump] do
  puts "Pushing to heroku"
  `git push -f heroku master`
  puts "=> Successfully pushed to heroku"
end

desc 'bump version'
task :bump do
  puts "Bumping version"
  version = OctoFeed::VERSION.split('.')
  major = version[0]
  minor = version[1]
  patch = version[2].to_i
  patch += 1
  new_version = "#{major}.#{minor}.#{patch}"
  content = "module OctoFeed\n\s\sVERSION = '#{new_version}'\nend"

  `echo "#{content}" > lib/octofeed/version.rb`
  `git add lib/octofeed/version.rb && git commit -m "bump version -> #{new_version}"`
  `git tag v#{new_version} && git push --tags`
  puts "=> Successfully bumped version"
end

namespace :assets do
  desc 'compile assets'
  task :compile => [:compile_js, :compile_css] do
  end

  desc 'compile css assets'
  task :compile_css do
    puts "Compiling stylesheets"
    sprockets = Sprockets::Environment.new
    sprockets.append_path 'app/assets/stylesheets'
    Stylus.setup sprockets
    Stylus.compress = true
    Stylus.use :nib

    asset = sprockets['styles.styl']
    outpath = File.join('public', 'css')
    outfile = Pathname.new(outpath).join('styles.min.css')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "=> Successfully compiled css assets"
  end

  desc 'compile javascript assets'
  task :compile_js do
    puts "Compiling javascripts"
    sprockets = Sprockets::Environment.new
    sprockets.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
    sprockets.append_path 'app/assets/javascripts'

    asset     = sprockets['scripts.coffee']
    outpath   = File.join('public', 'js')
    outfile   = Pathname.new(outpath).join('scripts.min.js')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "=> Successfully compiled js assets"
  end

  desc 'commit compiled assets'
  task :commit do
    puts "Commiting compiled assets"
    `git add public/css public/js`
    `git commit -m "update compiled assets"`
    puts "=> Successfully commited static assets"
  end
end
