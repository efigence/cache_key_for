require 'rails_helper'
=begin
require_relative '../../../lib/cache_key_for/controller_helpers'

class ApplicationController < ActionController::Base
  include CacheKeyFor::ControllerHelpers
end

describe ApplicationController do
  after { Object.send :remove_const, :ApplicationController }
  let(:subject) { ::ApplicationController.new }

  describe 'my_method_to_test' do
    it { expect(subject).to eq('expected result') }
  end

  describe ApplicationController do
    describe 'includes CacheKeyFor::ControllerHelpers' do
      it { expect(ApplicationController.ancestors.include? CacheKeyFor::ControllerHelpers).to eq(true) }
    end

    it "should respond to cache_key_for" do
      expect(subject.respond_to?(:cache_key_for)).to be true
    end

    it "should respond to cache_key_for_view" do
      expect(subject.respond_to?(:cache_key_for_view)).to be true
    end
  end
end
=end

# spec/controllers/concerns/likable_spec.rb
require_relative '../../../lib/cache_key_for/controller_helpers'

RSpec.describe 'CacheKeyFor::ControllerHelpers', type: :controller do
  controller do
    include CacheKeyFor::ControllerHelpers
    include ActionView::Helpers
    def index
      super
      render text: ''
    end
  end

  #before { routes.draw { put 'index' => 'anonymous#index' } }

  describe 'includes CacheKeyFor::ControllerHelpers' do
    it { expect(ApplicationController.ancestors.include? CacheKeyFor::ControllerHelpers).to eq(true) }
  end

  # write test
end