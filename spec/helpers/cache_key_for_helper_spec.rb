require 'rails_helper'

describe CacheKeyForHelper, type: :helper do
  # stub Rails.env.production?
  let(:string_inquirer) { ActiveSupport::StringInquirer.new('production') }
  let(:time_now) { Time.new(2016,4,1,12,0) }

  before(:each) do
    allow(Rails).to receive(:env).and_return(string_inquirer)
    allow(Time).to receive(:now).and_return(time_now)
  end

  describe "#cache_key_for" do
    let(:record_template) { Struct.new(:id, :updated_at, :cache_key) }
    let(:fake_record1) { record_template.new(1, time_now - 1.day) }
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
          it { is_expected.to eq('en/fake_records/014ddaafffda1a12a17cfdd68a022b213b3859eb/other_key/2016-04-01') }
        end
        context 'when `request.params` include utm parameters (key should not change)' do
          let(:request) { double('request', path: '/some-path', params: { a: '1', b: '1', c: [1, 2, 3], utm_medium: 'cpc' }, subdomains: ['www']) }

          before  { allow(helper).to receive(:request).and_return(request) }

          subject do
            helper.cache_key_for(*optional_properties)
          end
          it { is_expected.to eq('en/fake_records/014ddaafffda1a12a17cfdd68a022b213b3859eb/other_key/2016-04-01') }
        end
      end
      context 'when `whitelist_params` is not empty' do
        let(:whitelist_params) { [:c] }
        let(:request) { double('request', path: '/some-path', params: { a: '1', b: '1', c: [1, 2, 3] }, subdomains: ['www']) }

        before  { allow(helper).to receive(:request).and_return(request) }

        subject do
          properties = optional_properties.push(whitelist_params)
          helper.cache_key_for(*properties)
        end
        it { is_expected.not_to eq('en/fake_records/014ddaafffda1a12a17cfdd68a022b213b3859eb/other_key/2016-04-01') }
      end
    end
  end
end
