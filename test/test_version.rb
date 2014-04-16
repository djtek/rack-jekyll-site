require File.join(File.dirname(__FILE__), 'helper')

class TestVersion < Test::Unit::TestCase
  def test_version
    assert_kind_of String, Rack::Jekyll::VERSION
  end
end
