# Ruby requirements
require 'net/https'

# Set up gems listed in the Gemfile
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default, ENV['RACK_ENV'])
end

# Require app version first
require "#{File.expand_path('lib/octofeed/version.rb')}"

# Require helper files
Dir[File.expand_path('../../app/helpers/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

# Require lib files
# Make sure Event super class is loaded first
require "#{File.expand_path('lib/octofeed/event.rb')}"
Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

# Environment settings
# The `environment.rb` is not being versionned
# ENV constants have to be manually set in production (ie. Heroku)
if File.exists?(File.expand_path('../environment.rb', __FILE__))
  require File.expand_path('../environment', __FILE__)
end

# Database
# MongoDB without any ORM
# Using the ruby wraper for the few requests
uri = URI.parse(ENV['DATABASE_URI'])
conn = Mongo::Connection.from_uri(ENV['DATABASE_URI'])
$mongo_db = conn.db(uri.path.gsub(/^\//, ''))
