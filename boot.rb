require_relative 'app'
require 'global'

Global.configure do |config|
  config.environment = "development"
  config.config_directory = "config/global"
end

App.run
