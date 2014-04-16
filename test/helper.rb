require "test/unit"
require "rack/test"
require File.join(File.dirname(__FILE__), '../lib/rack/jekyll')

ENV["RACK_ENV"] = "test"

OUTER_APP = Rack::Builder.parse_file(File.join(File.dirname(__FILE__), 'app', 'config.ru')).first
CONFIG_FILE = File.join(File.dirname(__FILE__), "fixtures/_config.yml")
