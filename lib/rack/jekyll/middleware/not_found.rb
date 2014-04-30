module Rack
  module Jekyll
    class NotFound
      attr_reader :content
      def initialize(path)
        @content = F.read(F.expand_path(path))
      end
    end
  end
end
