require "yaml"
require "jekyll"

module Rack
  module Jekyll
    F = ::File
    autoload :VERSION,  "rack/jekyll/version"
    autoload :Config,   "rack/jekyll/config"
    autoload :Site,     "rack/jekyll/site"
    autoload :Request,  "rack/jekyll/request"
    autoload :NotFound, "rack/jekyll/middleware/not_found"
  end
end