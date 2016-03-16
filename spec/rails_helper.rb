# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require "spec_helper"

require "action_controller/railtie"
require "fake_app"
CacheKeyFor::Application.initialize!

require "cache_key_for/railtie"
require "rspec/rails"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
