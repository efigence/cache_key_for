require 'codeclimate-test-reporter'
require 'simplecov'
require 'coveralls'

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'

# FIXME: `<top (required)>': [DEPRECATION] ::[] is deprecated. Use ::new instead.
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter,
    Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require 'spec_helper'

require 'action_controller/railtie'
require 'fake_app'
CacheKeyFor::Application.initialize!

require 'cache_key_for/railtie'
require 'rspec/rails'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
