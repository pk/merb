require 'spec_helper'

describe Merb::Generators::MerbCoreGenerator do
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::MerbCoreGenerator.new('/tmp', {}, 'testing')
    end

    it_should_behave_like "named generator"
    it_should_behave_like "app generator"

    it "should create an Gemfile" do
      @generator.should create('/tmp/testing/Gemfile')
    end
    
    it "should create an bin/merb" do
      @generator.should create('/tmp/testing/bin/merb')
    end

    it "should create an init.rb" do
      @generator.should create('/tmp/testing/config/init.rb')
    end
    
    it "should have an application controller" do
      @generator.should create('/tmp/testing/app/controllers/application.rb')
    end
    
    it "should have an exceptions controller" do
      @generator.should create('/tmp/testing/app/controllers/exceptions.rb')
    end

    it "should have a gitignore file" do
      @generator.should create('/tmp/testing/.gitignore')
    end
    
    it "should create a number of views"
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end

    it "should have an empty lib/tasks directory" do
      @generator.should create('/tmp/testing/lib/tasks')
    end

    
  end
  
end
