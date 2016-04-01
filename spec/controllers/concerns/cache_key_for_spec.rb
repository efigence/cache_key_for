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
=begin
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


=end

# This is an example spec that uses the ControllerConcernHelper module
require "rails_helper"
require 'ostruct'
require 'rails'
require_relative '../../../lib/cache_key_for/controller_helpers'

# https://gist.github.com/penman/00a9b834db160fe71866
describe CacheKeyFor::ControllerHelpers, type: :controller_concern do
  controller do
    #include AbstractController::Callbacks
    include AbstractController::Rendering

    #before_action :authenticate

    def test_action
      person = OpenStruct.new
      person.id = 1
      person.name = 'John'
      person.cache_key = '1-john'

      cc = cache_key_for([person], 'datacenters')
      render text: cc
    end
  end

  context "when no authentication is supplied" do
    it "responds with 401 Unauthorized" do
      #expect_any_instance_of(CacheKeyFor::ControllerHelpers).to receive(:cache_key_for).and_return('1-john')
      expect(request.get("/").status).to eq 200
    end
  end
=begin
  context "when correct authentication is supplied" do
    let!(:secret) { SecureRandom.uuid }
    let!(:device) { create(:device, secret: secret) }
    let!(:response) { request.get("/", authenticate(device.id, secret)) }

    it "responds with 200 OK" do
      expect(response.status).to eq 200
    end

    it "finds device ID" do
      expect(response.body.chomp).to eq device.id
    end
  end

  context "when incorrect authentication is supplied" do
    it "responds with 401 Unauthorized" do
      authentication = cache_key_for(SecureRandom.uuid, SecureRandom.uuid)
      response = request.get("/", authentication)
      expect(response.status).to eq 401
    end
  end
=end
end