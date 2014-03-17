module Exceptionally
  class Railtie < Rails::Railtie
    initializer "exceptionally.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include Exceptionally::Controller
      end
    end
  end
end