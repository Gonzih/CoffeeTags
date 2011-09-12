require './lib/CoffeeTags'
describe 'CoffeeTags::Parser' do
  before :all do
    @campfire_class = File.read File.expand_path('./spec/fixtures/campfire.coffee')
    @test_file = File.read File.expand_path('./spec/fixtures/test.coffee')

  end

  it "should work" do
    lambda { Coffeetags::Parser.new "\n" }.should_not raise_exception
  end


  context 'detect item level' do
    before :each do
      @parser = Coffeetags::Parser.new ''
    end

    it 'gets level from a string with no indent' do
      @parser.line_level("zooo").should == 0
    end

    it "gets level from spaces" do
      @parser.line_level("    def lol").should == 4
    end

    it "gets level from tabs" do
      @parser.line_level("\t\t\tdef lol").should == 3
    end
  end

  context 'Camfpire Class' do

    it "loads the source and parses it" do
      inst = Coffeetags::Parser.new @campfire_class
      inst.execute!

      inst.tree.length.should == 2
    end

    context 'parsing' do
      before :each do
        @instance = Coffeetags::Parser.new @campfire_class
        @instance.execute!
      end

      it "extracts the classes" do
        @instance.tree.keys.should == ['Campfire', 'Test']
      end

      it "extracts the functions and methods for CampfireClass" do
        @instance.tree['Campfire'].select{|m| m[:kind] == 'f' }.map { |m| m[:name]}.should == [
          'constructor',
          'handlers',
          'onSuccess',
          'onFailure',
          'rooms',
          'roomInfo',
          'recent',
        ]
      end

      it 'extracts the line numbers for each method' do
        @instance.tree['Campfire'].select{|m| m[:kind] == 'f' }.map { |m| m[:line]}.should == [
          7, 13, 15, 23, 28, 33, 39
        ]

      end

      it "extracts method" do
        f = @instance.tree['Campfire'].select { |e| e[:kind] == 'f'}.first
        f.should == {:parent => 'Campfire', :name => 'constructor', :line => 7, :kind => 'f'}
      end

      it "generates the tree for file" do
        @instance.tree.should == {
          'Campfire' => [
            {:parent => 'Campfire', :name => 'constructor', :line => 7, :kind => 'f'},
            {:parent => 'Campfire', :name => 'handlers', :line => 13 , :kind => 'f'},
            {:parent => 'Campfire', :name => 'onSuccess', :line => 15, :kind => 'f'},
            {:parent => 'Campfire', :name => 'onFailure', :line => 23, :kind => 'f'},
            {:parent => 'Campfire', :name => 'rooms', :line => 28, :kind => 'f'},
            {:parent => 'Campfire', :name => 'roomInfo', :line => 33, :kind => 'f'},
            {:parent => 'Campfire', :name => 'recent', :line => 39, :kind => 'f'},
          ],
          'Test' => [
            { :parent => 'Test', :name => 'bump' , :line => 45, :kind => 'f'}
          ]
        }

        @instance.tree.should == YAML::load_file('./spec/fixtures/tree.yaml')
      end
    end
  end

  context 'Test file' do
    before :each do
      @instance = Coffeetags::Parser.new @test_file
      @instance.execute!
    end

    it "generates the tree for test file" do
      @instance.tree.should == {
        '__top__' => [
          {:parent => '', :name => 'bump', :line => 1, :kind => 'f'},
#          {:parent => '', :name => 'Wat', :line => 4, :kind => 'v'},
          {:parent => '', :name => 'ho', :line => 5, :kind => 'f'},
#          {:parent => 'Wat.ho', :name => 'x', :line => 6, :kind => 'v'}
        ]
      }
    end

  end
end
