require 'test/unit'
require 'json'

class ToHashCommandTest < Test::Unit::TestCase


  CMD="ruby -I lib -rubygems bin/ss2json to_hash"

  # Fixture helper
  def f(name); File.join( File.dirname(__FILE__), name ) ; end
  def r(path); File.read f(path); end

  def test_without_commands
    assert_equal r("output_to_hash.txt"), `#{CMD} 2>&1`
  end

  def test_to_hash
    output = `#{CMD} #{f "table.csv"} id | python -mjson.tool`
    assert_equal r("output_to_hash_table.txt"), output
  end
end

