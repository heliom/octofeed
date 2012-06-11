require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default)
end

namespace :assets do
  desc 'compile assets'
  task :compile => [:compile_js, :compile_css] do
  end

  desc 'compile css assets'
  task :compile_css do
    sprockets = Sprockets::Environment.new
    sprockets.append_path 'app/assets/stylesheets'
    Stylus.setup sprockets
    Stylus.compress = true
    Stylus.use :nib

    asset     = sprockets['styles.styl']
    outpath   = File.join('public', 'css')
    outfile   = Pathname.new(outpath).join('styles.min.css')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "successfully compiled css assets"
  end

  desc 'compile javascript assets'
  task :compile_js do
    sprockets = Sprockets::Environment.new
    sprockets.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
    sprockets.append_path 'app/assets/javascripts'

    asset     = sprockets['scripts.coffee']
    outpath   = File.join('public', 'js')
    outfile   = Pathname.new(outpath).join('scripts.min.js')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    puts "successfully compiled js assets"
  end
end
