require_relative '../app'

require 'rspec_api_documentation'
require 'json_spec'
require 'json'
require 'global'

Global.configure do |config|
  config.environment = "test"
  config.config_directory = "config/global"
end

RspecApiDocumentation.configure do |config|
  config.app = Webmachine::Adapters::Rack.new(App.configuration, App.dispatcher)
end

RSpec.configure do |config|
  config.include JsonSpec::Helpers

  config.before do
  end
end
