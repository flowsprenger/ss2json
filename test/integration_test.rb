require 'test/unit'
require 'json'

class Ss2JsonIntegrationTest < Test::Unit::TestCase


  def call(cmd, args)
    `ruby -I lib -rubygems bin/#{cmd} #{args}`
  end

  def callP(cmd,args)
    JSON.parse(call(cmd,args))
  end



  # def test_vertical
  #   data = [ { "child"=>[{"name"=>"pepe", "age"=>2}, {"name"=>"Juanjo"}], "id"=>1, "name"=>{"last"=>"Alvarez", "first"=>"Guillermo"} }, { "child"=>[{"name"=>"Jr"}], "id"=>2, "name"=>{"last"=>"Luther", "first"=>"Martin"} }, {"id"=>3, "name"=>{"first"=>"Jesper"}}, {"id"=>4}, {"id"=>5}, {"id"=>6}]
  #   assert_equal data, ss2jsonP("-f test/ss2json.xls -s Test1")
  # end

  # def test_check_flag
  #   data = [{"child"=>[{"name"=>"pepe", "age"=>2}, {"name"=>"Juanjo"}], "name"=>{"last"=>"Alvarez", "first"=>"Guillermo"}, "id"=>1}, {"child"=>[{"name"=>"Jr"}], "name"=>{"last"=>"Luther", "first"=>"Martin"}, "id"=>2}, {"name"=>{"first"=>"Jesper"}, "id"=>3}]
  #   assert_equal data, ss2jsonP("-f test/ss2json.xls -s Test1 -c 'name'")
  # end

  # def test_use_key
  #   data = []
  #   assert_equal data, ss2jsonP("-f test/ss2json.xls -s Test1 -u 'uuid'")
  # end



  def test_lsss
    assert_equal "Test1\nTest2\nTest3\nTest4\n", call('lsss', 'test/ss2json.xls')
  end

  def test_catss
    expected = File.read('test/catss.fixture')
    assert_equal expected , call('catss', 'test/ss2json.xls')
  end

  def test_catss_with_sheet
    expected = File.read('test/catss2.fixture')
    assert_equal expected , call('catss', 'test/ss2json.xls Test3')
  end

  def test_ss2json_horizontal
    expected = [
      { "child"=> [ { "age"=> 2, "name"=> "pepe" }, { "name"=> "Juanjo" } ], "id"=> 1, "name"=> { "last"=> "Alvarez", "first"=> "Guillermo" } },
      { "child"=> [ { "name"=> "Jr" } ], "id"=> 2, "name"=> { "last"=> "Luther", "first"=> "Martin" } },
      { "id"=> 3, "name"=> { "first"=> "Jesper" } },
      { "id"=> 4 },
      { "id"=> 5 },
      { "id"=> 6 }
    ]
    assert_equal expected, callP('ss2json-horizontal', 'test/ss2json.xls -s Test1')
  end

  def test_ss2json_horizontal_with_check
    expected = [
      { "child"=> [ { "age"=> 2, "name"=> "pepe" }, { "name"=> "Juanjo" } ], "id"=> 1, "name"=> { "last"=> "Alvarez", "first"=> "Guillermo" } },
      { "child"=> [ { "name"=> "Jr" } ], "id"=> 2, "name"=> { "last"=> "Luther", "first"=> "Martin" } },
      { "id"=> 3, "name"=> { "first"=> "Jesper" } }
    ]
    assert_equal expected, callP('ss2json-horizontal', 'test/ss2json.xls -s Test1 -c name')
  end

  def test_ss2json_hash
    expected = [
      { "child"=> [ { "age"=> 2, "name"=> "pepe" }, { "name"=> "Juanjo" } ], "id"=> 1, "name"=> { "last"=> "Alvarez", "first"=> "Guillermo" } },
      { "child"=> [ { "name"=> "Jr" } ], "id"=> 2, "name"=> { "last"=> "Luther", "first"=> "Martin" } },
      { "id"=> 3, "name"=> { "first"=> "Jesper" } }
    ]
    assert_equal expected, callP('ss2json-horizontal-hash', 'test/ss2json.xls id -s Test1')
  end

  def test_ss2json_vertical
    expected = {}
    assert_equal expected, callP('ss2json-vertical', 'test/ss2json.xls -s Test3')
  end


# compress-json
# merge-jsons
# order-json
# ss2json-horizontal
# ss2json-horizontal-hash
# ss2json-vertical
end
