require 'bundler/setup'
Bundler.setup

# require 'rails/all'
# require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "active_resource/railtie"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

require 'rspec/rails'
#require_relative './../lib/cache_key_for/controller_helpers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end
  config.order = :random
  config.infer_spec_type_from_file_location!
  config.include ActionView::Helpers
 # config.include ControllerHelpers, :type => :controller
  #config.include ApplicationHelper, :type => :helper
  #config.include CacheKeyFor::ControllerHelpers, :type => :controller
end
