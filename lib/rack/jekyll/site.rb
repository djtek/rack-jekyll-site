module Rack
  module Jekyll
    class Site
      attr_reader :config, :request, :response, :files
      def initialize(options={})
        @config = Config.new(options)
        @files = read_files
      end
      
      def call(env)
        @request = Request.new(env)
        if found = @files[@request.path_info]
          headers = { 'Last-Modified'  => found[:mtime] }
          
          if !expired?(found[:mtime])
            [304, headers, []]
          else
            headers.update({ 
              'Content-length' => found[:size].to_s, 
              'Content-Type'   => Mime.mime_type(found[:extname])
            })
            
            [200, headers, [read_file(found[:realpath])]]
          end
        else
          if not_found = files[@config.not_found]||files["/404.html"]
            NotFound.new(not_found[:realpath]).call(env)
          else
            [404,{},["404 Not Found"]]
          end
        end
      end
      
      private
      def expired?(mtime)
        mtime != @request.env['HTTP_IF_MODIFIED_SINCE']
      end
      
      def read_file(filename)
        F.open(filename, 'r') {|f| f.read}
      end
      
      def read_files
        map = {}
        Dir.chdir(@config.destination) do |path|
          entries = Dir[ F.join('**', '*')].reject { |p| F.directory? p }
          entries.each do |url|
            path = F.join(@config.destination, url)
            map[F.join('/', url)] = { url_path: F.join('/', url), 
              realpath: F.realpath(path), dirname: F.dirname(path), 
              basename: F.basename(path), mtime: F.mtime(path).httpdate, 
              size: F.size(path), extname: F.extname(path) }
          end
        end
        map
      end
    end
  end
end
