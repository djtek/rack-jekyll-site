module Rack
  module Jekyll
    class Site
      attr_reader :config
      def initialize(options={})
        @config = Config.new(options)
      end
      
      def call(env)
        @resource = Resource.new(config, env)
        @resource.response.finish
      end
    end
  end
end
