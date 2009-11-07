require File.expand_path("../merb-core/lib/merb-core/version.rb", __FILE__)

require 'fileutils'

ROOT = File.dirname(__FILE__)

merb_stack_gems = [
  { :name => 'merb-core',             :path => "#{ROOT}/merb-core"             },
  { :name => 'merb-action-args',      :path => "#{ROOT}/merb-action-args"      },
  { :name => 'merb-assets',           :path => "#{ROOT}/merb-assets"           },
  { :name => 'merb-slices',           :path => "#{ROOT}/merb-slices"           },
  { :name => 'merb-cache',            :path => "#{ROOT}/merb-cache"            },
  { :name => 'merb-gen',              :path => "#{ROOT}/merb-gen"              },
  { :name => 'merb-haml',             :path => "#{ROOT}/merb-haml"             },
  { :name => 'merb-helpers',          :path => "#{ROOT}/merb-helpers"          },
  { :name => 'merb-mailer',           :path => "#{ROOT}/merb-mailer"           },
  { :name => 'merb-param-protection', :path => "#{ROOT}/merb-param-protection" },
  { :name => 'merb-exceptions',       :path => "#{ROOT}/merb-exceptions"       },
  { :name => 'merb-auth',             :path => "#{ROOT}/../merb-auth"          },
  { :name => 'merb_datamapper',       :path => "#{ROOT}/../merb_datamapper"    },
  { :name => 'merb',                  :path => "#{ROOT}/merb"                  }
]


def gem_command(command)
  sh "#{RUBY} -S #{(ENV['JEWELER_INSTALL_COMMAND'] || 'gem')} #{command}"
end

def rake_command(command)
  sh "#{RUBY} -S rake #{command}"
end


desc "Install all merb stack gems"
task :install do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "install" }
  end
end

desc "Uninstall all merb stack gems"
task :uninstall do
  merb_stack_gems.each do |gem_info|
    gem_command "uninstall #{gem_info[:name]} --version=#{Merb::VERSION}"
  end
end

desc "Build all merb stack gems"
task :build do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "build" }
  end
end

desc "Generate gemspecs for all merb stack gems"
task :gemspec do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "gemspec" }
  end
end

desc "Run specs for all merb stack gems"
task :spec do
  # Omit the merb metagem, no specs there
  merb_stack_gems[0..-2].each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "spec" }
  end
end

task :default => 'spec'
