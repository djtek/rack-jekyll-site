module Rack
  module Jekyll
    class NotFound
      def initialize(path)
        file = F.expand_path(path)
        @content = F.read(file)
        @length = F.size(file).to_s
      end

      def call(env)
        [404, {'Content-Type' => 'text/html', 'Content-Length' => @length}, [@content]]
      end
    end
  end
end
