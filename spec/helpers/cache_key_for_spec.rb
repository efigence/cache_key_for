=begin
require 'rails_helper'

class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include CacheKeyFor::ControllerHelpers
end

describe ApplicationController, :type => :helper do
  # stub Rails.env.production?
  let(:string_inquirer) { ActiveSupport::StringInquirer.new('production') }

  before(:each) do
    allow(Rails).to receive(:env).and_return(string_inquirer)
  end

  describe "#cache_key_for" do
    let(:record_template) { Struct.new(:id, :updated_at, :cache_key) }
    let(:fake_record1) { record_template.new(1, Time.current - 1.day) }
    let(:fake_record2) { record_template.new(1, Time.current) }
    let(:fake_related_record) { record_template.new(1, Time.current, 'other_key') }

    let(:scoped_collection) { [fake_record1, fake_record2] }
    let(:collection_prefix) { 'fake_records' }
    let(:cache_owner_cache_key) { fake_related_record.cache_key }
    let(:suffix) { Time.now.utc.to_date.to_s }

    let(:required_properties) { [scoped_collection, collection_prefix] }
    let(:optional_properties) { [scoped_collection, collection_prefix, cache_owner_cache_key, suffix] }

    context 'when `cache_owner_cache_key` and `suffix` are empty' do
      subject { helper.cache_key_for(*required_properties) }
      it { is_expected.to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/\/\z/) }
    end

    context 'when `cache_owner_cache_key` and `suffix` are not empty' do
      subject { helper.cache_key_for(*optional_properties) }
      it { is_expected.to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/other_key\/\d{,4}-\d{,2}-\d{,2}\z/) }
    end
  end
end
=end