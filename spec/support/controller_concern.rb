module ControllerConcernHelper
  module ClassMethods
    def controller(&block)
      before { controller(&block) }
    end
  end

  def controller(&block)
    @controller ||= begin
      concern = described_class
      Class.new(ActionController::Metal) do
        include concern
      end
    end
    @controller.class_eval(&block) if block
    @controller
  end

  def app
    @controller.action(:test_action)
  end

  def request
    Rack::MockRequest.new(app)
  end
end

RSpec.configure do |config|
  config.include ControllerConcernHelper, type: :controller_concern
  config.extend ControllerConcernHelper::ClassMethods, type: :controller_concern
end
