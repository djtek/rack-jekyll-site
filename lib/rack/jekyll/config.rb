module Rack
  module Jekyll
    class Config
      # F = ::File
      JC = ::Jekyll::Configuration
      DEFAULTS = JC[JC::DEFAULTS]
      
      attr_reader :options
      def initialize(options={})
        @options = parse_options(options)
      end
      
      def method_missing(key, *rest)
        @options[key.to_s]
      end
      
      private
      def parse_options(options)
        load_config(options.delete(:config)||'_config.yml')
        override_options(options)
      end
      
      def load_config(file)
        @options = if F.exist?(file)
          DEFAULTS.deep_merge(DEFAULTS.read_config_file(file))
        else
          DEFAULTS
        end
      end
      
      def override_options(options)
        @options.deep_merge(options).stringify_keys
      end
    end
  end
end