require 'test/unit'
require 'json'

class ToArrayCommandTest < Test::Unit::TestCase


  CMD="ruby -I lib -rubygems bin/ss2json to_array"

  # Fixture helper
  def f(name); File.join( File.dirname(__FILE__), name ) ; end
  def r(path); File.read f(path); end

  def test_without_commands
    assert_equal r("output_to_array.txt"), `#{CMD} 2>&1`
  end

  def test_to_array
    output = `#{CMD} #{f "table.csv"} | python -mjson.tool`
    assert_equal r("output_to_array_table.txt"), output
  end
end

