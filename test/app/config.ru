Encoding.default_external = Encoding::UTF_8

require File.join(File.dirname(__FILE__), '../../lib/rack/jekyll')

# Setup bundler
require "bundler/setup"
# require deafult and env gems
Bundler.require(:default, ENV["RACK_ENV"])
# @destination: defaults to _site
# @config: defaults to _config.yml
run Rack::Jekyll::Site.new({
  destination: File.join(File.dirname(__FILE__), '_site'), 
  config: File.join(File.dirname(__FILE__), '_config.yml')
})