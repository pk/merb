# Go to http://wiki.merbivore.com/pages/init-rb

# Specify your dependencies in the Gemfile but require them explicitly
<%= "require 'merb_#{orm}'" unless orm == :none %>
use_test :<%= testing_framework %>
<%= "require 'merb-haml'" if template_engine == :haml %>
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '<%= Digest::SHA1.hexdigest(rand(100000000000).to_s).to_s %>'  # required for cookie session store
  c[:session_id_key] = '_<%= base_name  %>_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end
