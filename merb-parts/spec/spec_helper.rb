require 'rubygems'
require "merb-core"
require File.join( File.dirname(__FILE__), "..", "lib", "merb-parts" )

# Require the fixtures
Dir[File.join(File.dirname(__FILE__), "fixtures", "*/**.rb")].each{|f| require f }

Merb.start :environment => "test", :adapter => "runner"

require "merb-core/test/fake_request"
require "merb-core/test/request_helper"

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end