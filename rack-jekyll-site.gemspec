# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/jekyll/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-jekyll-site"
  spec.version       = Rack::Jekyll::VERSION
  spec.authors       = ["Luciano P. Altube"]
  spec.email         = ["laltube@gmail.com"]
  spec.description   = %q{Rackup a jekyll site}
  spec.summary       = %q{rack-jekyll-site}
  spec.homepage      = "https://github.com/djtek/rack-jekyll-site"
  spec.license       = "MIT"

  spec.files         = spec.files = Dir['README.md', 'LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'jekyll'
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
end
