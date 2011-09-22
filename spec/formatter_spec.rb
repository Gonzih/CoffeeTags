require './lib/CoffeeTags'

describe 'CoffeeTags::Formatter' do
  before :each do
    @tree = YAML::load_file './spec/fixtures/tree.yaml'
  end

  it "works!" do
    lambda { Coffeetags::Formatter.new 'lol.coffee' }.should_not raise_exception
  end

  before :each do
    @instance = Coffeetags::Formatter.new 'test.coffee', @tree
  end

  it "generates a line for method definition" do
    exp = 'constructor	test.coffee	/^  constructor: (api_key, host) ->$/;"	f	lineno:7	object:Campfire	type:function'
    @instance.parse_tree.first.should == exp
  end

  it "generates line for second class" do
    exp = 'bump	test.coffee	/^  bump : ->$/;"	f	lineno:45	object:Test	type:function'
    @instance.parse_tree.last.should == exp
  end

end
