module Rack
  module Jekyll
    class Request < ::Rack::Request
      def path_info
        sanitized(super)
      end
      
      private
      def sanitized(path)
        # None specified, or permalink: date
        # /2009/04/29/slap-chop.html
        # permalink: pretty
        # /2009/04/29/slap-chop/index.html
        # permalink: /:month-:day-:year/:title.html
        # /04-29-2009/slap-chop.html
        # permalink: /blog/:year/:month/:day/:title
        # /blog/2009/04/29/slap-chop/index.html
        return path unless ::File.extname(path).empty?
        F.join(path, 'index.html')
      end
    end
  end
end