

require 'ss2json'
require 'test/unit'

class Ss2Json::RowConverterTest < Test::Unit::TestCase

  def test_class
    nested_hash = Ss2Json::RowConverter.new({})
    nested_hash.is_a?(Hash)
  end

  def test_ignored_values_option
    options = {:ignored_values => ["???"]}
    new_hash = Ss2Json::RowConverter.new({"adsf" => '???'},options)
    assert_equal({}, new_hash)
    new_hash = Ss2Json::RowConverter.new({"asdf" => 'asdf'}, options)
    assert_equal({"asdf" => 'asdf' }, new_hash)
  end

  def test_show_null_option
    initial_hash = {"asdf" => nil}
    new_hash = Ss2Json::RowConverter.new(initial_hash,{:show_null => false})
    assert_equal({}, new_hash)

    new_hash = Ss2Json::RowConverter.new(initial_hash,{:show_null => true})
    assert_equal({"asdf" => nil}, new_hash)
  end

  def test_dont_convert_option
    initial_hash = { "asdf" => 3.0 }

    new_hash = Ss2Json::RowConverter.new(initial_hash, {:dont_convert => true})
    assert_equal(initial_hash, new_hash)

    new_hash = Ss2Json::RowConverter.new(initial_hash, {:dont_convert => false})
    assert_equal(initial_hash, { "asdf" => 3 })
  end

  def test_downcase_first_letter
    initial_hash = { "Asdf.pepe" => 3, "asdf.Jose" => 5 }

    new_hash = Ss2Json::RowConverter.new(initial_hash, {:downcase_first_letter => false})
    assert_equal({"Asdf"=>{"pepe"=>3}, "asdf"=>{"Jose"=>5}}, new_hash)

    new_hash = Ss2Json::RowConverter.new(initial_hash, {:downcase_first_letter => true})
    assert_equal({"asdf" => {"pepe" => 3, "jose" => 5}}, new_hash)
  end

  def test_it_ignore_ignored_fields
    initial_hash = { "i.asdf" => 5}

    new_hash = Ss2Json::RowConverter.new(initial_hash)
    assert_equal({}, new_hash)

    initial_hash = { "name.i" => 5}

    new_hash = Ss2Json::RowConverter.new(initial_hash)
    assert_equal({"name" => {"i" => 5}}, new_hash)
  end
end
