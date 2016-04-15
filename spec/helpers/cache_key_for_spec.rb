=begin
require 'rails_helper'

class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include CacheKeyFor::ControllerHelpers
end

describe ApplicationController, :type => :helper do
  # stub Rails.env.production?
  let(:string_inquirer) { ActiveSupport::StringInquirer.new('production') }
  let(:time_now) { Time.utc(2016,4,2,12,0).localtime('+05:30') }
  let(:time_yesterday) { Time.utc(2016,4,1,12,0).localtime('+05:30') }

  before(:each) do
    allow(Rails).to receive(:env).and_return(string_inquirer)
    allow(Time).to receive(:now).and_return(time_now)
  end

  describe "#cache_key_for" do
    let(:record_template) { Struct.new(:id, :updated_at, :cache_key) }
    let(:fake_record1) { record_template.new(1, time_yesterday) }
    let(:fake_record2) { record_template.new(1, time_now) }
    let(:fake_related_record) { record_template.new(1, time_now, 'other_key') }

    let(:scoped_collection) { [fake_record1, fake_record2] }
    let(:collection_prefix) { 'fake_records' }
    let(:cache_owner_cache_key) { fake_related_record.cache_key }
    let(:suffix) { time_now.utc.to_date.to_s }

    let(:required_properties) { [scoped_collection, collection_prefix] }
    let(:optional_properties) { [scoped_collection, collection_prefix, cache_owner_cache_key, suffix] }

    # TODO: write deterministic test
    context 'when `cache_owner_cache_key` and `suffix` are empty' do
      subject { helper.cache_key_for(*required_properties) }
      it { is_expected.to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/\/\z/) }
    end

    # TODO: write deterministic test
    context 'when `cache_owner_cache_key` and `suffix` are not empty' do
      subject { helper.cache_key_for(*optional_properties) }
      it { is_expected.to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/other_key\/\d{,4}-\d{,2}-\d{,2}\z/) }
    end

    context 'when there are params' do
      context 'when `whitelist_params` is empty' do
        context 'when `request.params` do not include utm parameters' do
          let(:request) { double('request', path: '/some-path', params: { a: '1', b: '1', c: [1, 2, 3] }, subdomains: ['www']) }

          before  { allow(helper).to receive(:request).and_return(request) }

          subject do
            helper.cache_key_for(*optional_properties)
          end
          it { is_expected.to eq('en/fake_records/90a09a166bd263f286bea1b830863af67549ef19/other_key/2016-04-02') }
        end
        context 'when `request.params` include utm parameters (key should not change)' do
          let(:request) { double('request', path: '/some-path', params: { a: '1', b: '1', c: [1, 2, 3], utm_medium: 'cpc' }, subdomains: ['www']) }

          before  { allow(helper).to receive(:request).and_return(request) }

          subject do
            helper.cache_key_for(*optional_properties)
          end
          it { is_expected.to eq('en/fake_records/90a09a166bd263f286bea1b830863af67549ef19/other_key/2016-04-02') }
        end
      end
      context 'when `whitelist_params` is not empty (key should change)' do
        let(:whitelist_params) { [:c] }
        let(:request) { double('request', path: '/some-path', params: { a: '1', b: '1', c: [1, 2, 3] }, subdomains: ['www']) }

        before  { allow(helper).to receive(:request).and_return(request) }

        subject do
          properties = optional_properties.push(whitelist_params)
          helper.cache_key_for(*properties)
        end
        it { is_expected.to eq('en/fake_records/4d640ca8ea873c4dbacb9472ff2f4bf620c07c63/other_key/2016-04-02') }
      end
    end
    context 'when params is empty' do
      context 'when in time zone' do
        let(:utc_offset) { '+05:30' }
        let(:time_now) { Time.utc(2016, 4, 2, 12, 0).localtime(utc_offset) }
        let(:time_yesterday) { Time.utc(2016, 4, 1, 12, 0).localtime(utc_offset) }

        let(:fake_record1) { record_template.new(1, time_yesterday) }
        let(:fake_record2) { record_template.new(1, time_now) }
        let(:fake_related_record) { record_template.new(1, time_now, 'other_key') }
        let(:scoped_collection) { [fake_record1, fake_record2] }
        let(:cache_owner_cache_key) { fake_related_record.cache_key }
        let(:suffix) { time_now.utc.to_date.to_s }
        let(:optional_properties) { [scoped_collection, collection_prefix, cache_owner_cache_key, suffix] }
        let(:request) { double('request', path: '/some-path', params: {}, subdomains: ['www']) }

        before  { allow(helper).to receive(:request).and_return(request) }

        subject do
          properties = optional_properties
          helper.cache_key_for(*properties)
        end
        it { is_expected.to eq('en/fake_records/4d640ca8ea873c4dbacb9472ff2f4bf620c07c63/other_key/2016-04-02') }
      end
      context 'when in different time zone (key should not change)' do
        let(:utc_offset) { '+02:00' }
        let(:time_now) { Time.utc(2016, 4, 2, 12, 0).localtime(utc_offset) }
        let(:time_yesterday) { Time.utc(2016, 4, 1, 12, 0).localtime(utc_offset) }

        let(:fake_record1) { record_template.new(1, time_yesterday) }
        let(:fake_record2) { record_template.new(1, time_now) }
        let(:fake_related_record) { record_template.new(1, time_now, 'other_key') }
        let(:scoped_collection) { [fake_record1, fake_record2] }
        let(:cache_owner_cache_key) { fake_related_record.cache_key }
        let(:suffix) { time_now.utc.to_date.to_s }
        let(:optional_properties) { [scoped_collection, collection_prefix, cache_owner_cache_key, suffix] }
        let(:request) { double('request', path: '/some-path', params: {}, subdomains: ['www']) }

        before  { allow(helper).to receive(:request).and_return(request) }

        subject do
          properties = optional_properties
          helper.cache_key_for(*properties)
        end
        it { is_expected.to eq('en/fake_records/4d640ca8ea873c4dbacb9472ff2f4bf620c07c63/other_key/2016-04-02') }
      end
    end
  end
end
=end