require 'test/unit'
require 'json'

class ToConstantsCommandTest < Test::Unit::TestCase
  CMD="ruby -I lib -rubygems bin/ss2json constants"

  # Fixture helper
  def f(name); File.join( File.dirname(__FILE__), name ) ; end
  def r(path); File.read f(path); end

  def test_without_commands
    assert_equal r("output_constants.txt"), `#{CMD} 2>&1`
  end

  def test_to_constants
    output = `#{CMD} #{f "table.csv"} | python -mjson.tool`
    assert_equal r("output_constants_table.txt"), output
  end
end

