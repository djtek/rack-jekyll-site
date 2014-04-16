require File.join(File.dirname(__FILE__), 'helper')

class TestConfig < Test::Unit::TestCase    
  def setup
    $stdout.puts # break new line
    @config = Rack::Jekyll::Config.new(permalink: "none", config: CONFIG_FILE)
  end
  
  def test_config_instance
    assert_equal @config.name, "Your New Jekyll Site"
    assert_equal @config.markdown, "redcarpet"
    assert_equal @config.pygments, true
  end
  
  def test_options_override
    assert_equal @config.permalink, "none"
  end
end
