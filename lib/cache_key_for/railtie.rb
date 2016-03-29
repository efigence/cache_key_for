module CacheKeyFor
  class Railtie < Rails::Railtie
    initializer 'cache_key_for.action_controller' do
      ActiveSupport.on_load(:action_controller) do
        require 'cache_key_for/controller_helpers'
        include CacheKeyFor::ControllerHelpers
      end
    end
  end
end
