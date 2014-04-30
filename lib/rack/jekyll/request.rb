module Rack
  module Jekyll
    class Request < Rack::Request
      # custom request
      
      def if_modified_since
        @env['HTTP_IF_MODIFIED_SINCE']
      end
    end
  end
end