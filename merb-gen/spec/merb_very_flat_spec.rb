require 'spec_helper'

describe Merb::Generators::MerbVeryFlatGenerator do
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::MerbVeryFlatGenerator.new('/tmp', {}, 'testing')
    end

    it_should_behave_like "named generator"
    it_should_behave_like "app generator"

    it "should create an Gemfile" do
      @generator.should create('/tmp/testing/Gemfile')
    end

    it "should create an bin/merb" do
      @generator.should create('/tmp/testing/bin/merb')
    end
    
    it "should create a number of views"
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end
    
  end
  
end
