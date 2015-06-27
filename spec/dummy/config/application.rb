require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
  end
end
