require "yaml"
require "jekyll"

module Rack
  module Jekyll
    F = ::File
    autoload :VERSION,  "rack/jekyll/version"
    autoload :Config,   "rack/jekyll/config"
    autoload :Site,     "rack/jekyll/site"
    autoload :Request,  "rack/jekyll/request"
  end
end