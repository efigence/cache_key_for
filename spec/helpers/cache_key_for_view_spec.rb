#require 'rails_helper'

#class ApplicationController < ActionController::Base
  #include ActionController::Helpers
  #include CacheKeyFor::ControllerHelpers
#end
=begin
describe ApplicationController, :type => :helper do
  # stub Rails.env.production?
  let(:string_inquirer) { ActiveSupport::StringInquirer.new('production') }
  let(:rails_root) { '/home/me/my_app' }
  let(:file) { rails_root + '/app/views/fake_records/index.html.haml' }

  before(:each) do
    allow(Rails).to receive(:env).and_return(string_inquirer)
    allow(Rails).to receive(:root).and_return(rails_root)
  end

  describe "#cache_key_for_view" do
    let(:record_template) { Struct.new(:id, :updated_at, :cache_key) }
    let(:fake_record1) { record_template.new(1, Time.current - 1.day) }
    let(:fake_record2) { record_template.new(1, Time.current) }
    let(:fake_related_record) { record_template.new(1, Time.current, 'dbe13b0b975c7ce95665f019aa2ba0d77eb0f2c8') }

    let(:scoped_collection) { [fake_record1, fake_record2] }
    let(:collection_prefix) { 'fake_records' }
    let(:cache_owner_cache_key) { fake_related_record.cache_key }
    let(:suffix) { Time.now.utc.to_date.to_s }

    let(:required_properties) { [file, scoped_collection, collection_prefix] }
    let(:optional_properties) { [file, scoped_collection, collection_prefix, cache_owner_cache_key, suffix] }

    context "when `cache_key_for_view` is used with a normal controller" do
      before do
        controller = double('controller', controller_path: 'some_controller', action_name: 'some_action')
        allow(helper).to receive(:controller).and_return(controller)
      end
      it "should return the correct names" do
        expect(helper.cache_key_for_view(*required_properties)).to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/\/\/app\/views\/fake_records\/index\.html\.haml\z/)
      end
    end

    context "when `cache_key_for_view` is used with a nested controller" do
      before do
        controller = double('controller', controller_path: 'some_module/some_controller', action_name: 'some_action')
        allow(helper).to receive(:controller).and_return(controller)
      end
      it "should return the correct names" do
        expect(helper.cache_key_for_view(*required_properties)).to match(/\Aen\/fake_records\/([a-zA-Z0-9]+)\/\/\/app\/views\/fake_records\/index\.html\.haml\z/)
      end
    end
  end
end
=end