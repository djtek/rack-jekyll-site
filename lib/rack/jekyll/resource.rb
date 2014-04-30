module Rack
  module Jekyll
    class Resource
      attr_reader :config, :request, :not_found
      def initialize(config, env)
        @config = config
        @request = Request.new(env)
        @path_info = F.join(@config.destination, @request.path_info)
        @not_found = F.join(config.destination, config.not_found||"404.html")
      end
      
      def response
        Response.new(info[:content]||[], info[:status]||200, info[:headers]||{})
      end
      
      def info
        @info ||= resource_info
      end
      
      def expired?
        last_modified_since && request.if_modified_since != last_modified_since
      end
            
      def location
        @location ||= find_resource
      end
      
      def last_modified_since
        location && F.mtime(location).httpdate
      end
      
      private
      def find_resource
        if !F.extname(@path_info).empty?
          Dir[@path_info][0]
        else
          Dir["#{@path_info}.html", F.join(@path_info, "index.html")][0]
        end
      end
      
      def resource_info
        if location
          info = {}
          if !expired?
            info[:status] = 304
          else
            info[:status] = 200
            info[:content] = F.read(location)
            info[:headers] = { 'Content-Type' => Mime.mime_type(F.extname(not_found)), 
                               'Last-Modified' => last_modified_since }
          end
          info
        else
          if F.file?(not_found)
            {
              content: NotFound.new(not_found).content, 
              status: 404, headers: {
                'Content-Type' => Mime.mime_type(F.extname(not_found))
              }
            }
          else
            { content: "Not Found", status: 404 }
          end
        end
      end
    end
  end
end