require "rubygems"

# Use current merb-core sources if running from a typical dev checkout.
lib = File.expand_path('../../../merb-core/lib', __FILE__)
$LOAD_PATH.unshift(lib) if File.directory?(lib)
require 'merb-core'

# The lib under test
require "merb-gen"

# Satisfies Autotest and anyone else not using the Rake tasks
require 'spec'

# Templater spec support
require 'templater/spec/helpers'

Merb.disable(:initfile)

Spec::Runner.configure do |config|
  config.include Templater::Spec::Helpers
end

describe "app generator", :shared => true do
  
  describe "#gems_for_orm" do
    [:activerecord, :sequel, :datamapper].each do |orm|
      it "should generate DSL for #{orm} ORM plugin" do
        @generator.gems_for_orm(orm).should == %Q{gem "merb_#{orm}"}
      end
    end

    it "should not generate DSL if we don't use ORM" do
      @generator.gems_for_orm(:none).should  == ''
    end
  end

  describe "#gems_for_template_engine" do
    [:haml, :builder].each do |engine|
      it "should generate DSL for #{engine} template engine plugin" do
        @generator.gems_for_template_engine(engine).should == %Q{gem "merb-#{engine}"}
      end
    end

    it "should generate DSL for template engine plugins other than haml and builder" do
      @generator.gems_for_template_engine(:liquid).should == 'gem "merb_liquid"'
    end

    it "should not generate DSL if we use erb" do
      @generator.gems_for_template_engine(:erb).should  == ''
    end
  end

  describe "#gems_for_testing_framework" do
    it "should generate DSL for testing framework plugin" do
      @generator.gems_for_testing_framework(:test_unit).should == 'gem "test_unit", :group => :test'
    end

    it "should not generate DSL if we use rspec" do
      @generator.gems_for_testing_framework(:rspec).should  == ''
    end
  end
end

describe "named generator", :shared => true do

  describe '#file_name' do

    it "should convert the name to snake case" do
      @generator.name = 'SomeMoreStuff'
      @generator.file_name.should == 'some_more_stuff'
    end

    it "should preserve dashes" do
      @generator.name = "project-pictures"
      @generator.file_name.should == "project-pictures"
    end

  end
  
  describe '#base_name' do

    it "should convert the name to snake case" do
      @generator.name = 'SomeMoreStuff'
      @generator.base_name.should == 'some_more_stuff'
    end

    it "should preserve dashes" do
      @generator.name = "project-pictures"
      @generator.base_name.should == "project-pictures"
    end

  end

  describe "#symbol_name" do

    it "should snakify the name" do
      @generator.name = "ProjectPictures"
      @generator.symbol_name.should == "project_pictures"
    end
    
    it "should replace dashes with underscores" do
      @generator.name = "project-pictures"
      @generator.symbol_name.should == "project_pictures"
    end

  end

  describe '#class_name' do
  
    it "should convert the name to camel case" do
      @generator.name = 'some_more_stuff'
      @generator.class_name.should == 'SomeMoreStuff'
    end
    
    it "should convert a name with dashes to camel case" do
      @generator.name = 'some-more-stuff'
      @generator.class_name.should == 'SomeMoreStuff'
    end
  
  end
  
  describe '#module_name' do
  
    it "should convert the name to camel case" do
      @generator.name = 'some_more_stuff'
      @generator.module_name.should == 'SomeMoreStuff'
    end
    
    it "should convert a name with dashes to camel case" do
      @generator.name = 'some-more-stuff'
      @generator.module_name.should == 'SomeMoreStuff'
    end
  
  end
  
  describe '#test_class_name' do
    
    it "should convert the name to camel case and append 'test'" do
      @generator.name = 'some_more_stuff'
      @generator.test_class_name.should == 'SomeMoreStuffTest'
    end
    
  end

end

shared_examples_for "namespaced generator" do

  describe "#class_name" do
    it "should camelize the name" do
      @generator.name = "project_pictures"
      @generator.class_name.should == "ProjectPictures"
    end
    
    it "should split off the last double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.class_name.should == "ProjectPictures"
    end
    
    it "should split off the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.class_name.should == "ProjectPictures"
    end
    
    it "should convert a name with dashes to camel case" do
      @generator.name = 'some-more-stuff'
      @generator.class_name.should == 'SomeMoreStuff'
    end
  end
  
  describe "#module_name" do
    it "should camelize the name" do
      @generator.name = "project_pictures"
      @generator.module_name.should == "ProjectPictures"
    end
    
    it "should split off the last double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.module_name.should == "ProjectPictures"
    end
    
    it "should split off the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.module_name.should == "ProjectPictures"
    end
    
    it "should convert a name with dashes to camel case" do
      @generator.name = 'some-more-stuff'
      @generator.module_name.should == 'SomeMoreStuff'
    end
  end
  
  describe "#modules" do
    it "should be empty if no modules are passed to the name" do
      @generator.name = "project_pictures"
      @generator.modules.should == []
    end
    
    it "should split off all but the last double colon separated chunks" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.modules.should == ["Test", "Monkey"]
    end
    
    it "should split off all but the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.modules.should == ["Test", "Monkey"]
    end
  end
  
  describe "#file_name" do
    it "should snakify the name" do
      @generator.name = "ProjectPictures"
      @generator.file_name.should == "project_pictures"
    end
    
    it "should preserve dashes" do
      @generator.name = "project-pictures"
      @generator.file_name.should == "project-pictures"
    end
    
    it "should split off the last double colon separated chunk and snakify it" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.file_name.should == "project_pictures"
    end
    
    it "should split off the last slash separated chunk and snakify it" do
      @generator.name = "test/monkey/project_pictures"
      @generator.file_name.should == "project_pictures"
    end
  end
  
  describe "#base_name" do
    it "should snakify the name" do
      @generator.name = "ProjectPictures"
      @generator.base_name.should == "project_pictures"
    end
    
    it "should preserve dashes" do
      @generator.name = "project-pictures"
      @generator.base_name.should == "project-pictures"
    end
    
    it "should split off the last double colon separated chunk and snakify it" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.base_name.should == "project_pictures"
    end
    
    it "should split off the last slash separated chunk and snakify it" do
      @generator.name = "test/monkey/project_pictures"
      @generator.base_name.should == "project_pictures"
    end
  end
  
  describe "#symbol_name" do
    it "should snakify the name and replace dashes with underscores" do
      @generator.name = "project-pictures"
      @generator.symbol_name.should == "project_pictures"
    end
    
    it "should split off the last slash separated chunk, snakify it and replace dashes with underscores" do
      @generator.name = "test/monkey/project-pictures"
      @generator.symbol_name.should == "project_pictures"
    end
  end
  
  describe "#test_class_name" do
    it "should camelize the name and append 'Test'" do
      @generator.name = "project_pictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
    
    it "should split off the last double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
    
    it "should split off the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
  end
  
  describe "#full_class_name" do
    it "should camelize the name" do
      @generator.name = "project_pictures"
      @generator.full_class_name.should == "ProjectPictures"
    end
    
    it "should camelize a name with dashes" do
      @generator.name = "project-pictures"
      @generator.full_class_name.should == "ProjectPictures"
    end
    
    it "should leave double colon separated chunks" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.full_class_name.should == "Test::Monkey::ProjectPictures"
    end
    
    it "should convert slashes to double colons and camel case" do
      @generator.name = "test/monkey/project_pictures"
      @generator.full_class_name.should == "Test::Monkey::ProjectPictures"
    end
  end
  
  describe "#base_path" do
    it "should be blank for no namespaces" do
      @generator.name = "project_pictures"
      @generator.base_path.should == ""
    end
    
    it "should snakify and join namespace for double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.base_path.should == "test/monkey"
    end
    
    it "should leave slashes but only use the namespace part" do
      @generator.name = "test/monkey/project_pictures"
      @generator.base_path.should == "test/monkey"
    end
  end

end
