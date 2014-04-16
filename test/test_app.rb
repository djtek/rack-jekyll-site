require File.join(File.dirname(__FILE__), 'helper')

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods  
  def app; OUTER_APP end

  def setup
    @files ||= app.files
  end
    
  OUTER_APP.files.each do |file|
    url, info = file[0], file[1]
    method_name = url.dup.to_s.split(/[\/\-\.]/).reject(&:empty?).join('_')

    define_method "test_#{method_name}" do
      puts
      puts url
      
      get url
      assert last_response.ok?
      File.open(@files[url][:realpath], 'r') do |f|
        assert_equal f.read, last_response.body
      end
    end
    
    if url.match(/index\.html$/)
      define_method "test_#{method_name}_without_ext" do
        puts
        puts url.gsub(File.basename(url), '')
        get url.gsub(File.basename(url), '')
        assert last_response.ok?
        File.open(@files[url][:realpath], 'r') do |f|
          assert_equal f.read, last_response.body
        end
      end
      
      define_method "test_#{method_name}_without_ext_and_slash" do
        puts
        puts url.gsub(File.basename(url), '')
        get url.gsub(File.basename(url), '').chomp('/')
        assert last_response.ok?
        File.open(@files[url][:realpath], 'r') do |f|
          assert_equal f.read, last_response.body
        end
      end
      
    end
  end

  def test_not_found
    puts
    puts app.config.options
    get "/not_found"
    File.open(@files["/404.html"][:realpath], 'r') do |f|
      assert_equal f.read, last_response.body
    end
  end
end