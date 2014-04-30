require File.join(File.dirname(__FILE__), 'helper')

class TestApp < Test::Unit::TestCase
  F = File;
  include Rack::Test::Methods  

  def app; OUTER_APP end

  def self.inventory
    map = {}
    Dir.chdir(OUTER_APP.config.destination) do |path|
      entries = Dir[ F.join('**', '*')].reject { |p| F.directory? p }
      entries.each do |url|
        path = F.join(OUTER_APP.config.destination, url)
        map[F.join('/', url)] = { 
          # url_path: F.join('/', url), 
          realpath: F.realpath(path), 
          # dirname: F.dirname(path), 
          # basename: F.basename(path), 
          mtime: F.mtime(path).httpdate, 
          # size: F.size(path), 
          # extname: F.extname(path) 
        }
      end
    end
    map
  end
  
  def setup
    @files ||= self.class.inventory
  end
    
  inventory.each do |file|
    url, info = file[0], file[1]
    method_name = url.dup.to_s.split(/[\/\-\.]/).reject(&:empty?).join('_')

    define_method "test_#{method_name}" do
      get url
      assert last_response.ok?
      File.open(@files[url][:realpath], 'r') do |f|
        assert_equal f.read, last_response.body
      end
    end
    
    if url.match(/index\.html$/)
      define_method "test_#{method_name}_without_ext" do
        get url.gsub(File.basename(url), '')
        assert last_response.ok?
        File.open(@files[url][:realpath], 'r') do |f|
          assert_equal f.read, last_response.body
        end
      end
      
      define_method "test_#{method_name}_without_ext_and_slash" do
        get url.gsub(File.basename(url), '').chomp('/')
        assert last_response.ok?
        File.open(@files[url][:realpath], 'r') do |f|
          assert_equal f.read, last_response.body
        end
      end
      
      define_method "test_#{method_name}_304" do
        header "If-Modified-Since", @files[url][:mtime]
        get url
        assert_equal 304, last_response.status, "should send 304 when If-Modified-Since present"
        assert last_response.body.empty?
      end
    end
  end

  def test_not_found
    get "/not_found"
    assert_equal 404, last_response.status
    File.open(@files["/404.html"][:realpath], 'r') do |f|
      assert_equal f.read, last_response.body
    end
  end
  
  def test_not_found_without_ext
    get "/404"
    assert last_response.ok?
    File.open(@files["/404.html"][:realpath], 'r') do |f|
      assert_equal f.read, last_response.body
    end
  end
  
  def test_valid_ext
    get "/404/404.whatever"
    assert_equal 404, last_response.status, "should not serve sub resources with invalid ext"
    File.open(@files["/404.html"][:realpath], 'r') do |f|
      assert_equal f.read, last_response.body
    end
  end  
end