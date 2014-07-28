require 'webmachine/adapter'
require 'webmachine/adapters/rack'
require 'global'
require File.join(File.dirname(__FILE__), 'app')

Global.configure do |config|
  config.environment = "development"
  config.config_directory = "config/global"
end

run App.adapter
