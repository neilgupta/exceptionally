$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['RAILS_ENV'] ||= 'test'

require 'rails'
require 'active_record/errors'
require 'active_model'
require 'action_view'
require 'action_controller'
require 'dummy/config/environment'
require 'rspec/rails'

require 'exceptionally'

RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = false
  c.order = 'random'
end

class Raven
  def capture_exception(error); end
end

class Airbrake; end
