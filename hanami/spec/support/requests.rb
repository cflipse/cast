# frozen_string_literal: true

require "rack/test"
require "warden"

RSpec.shared_context "with Rack::Test" do
  # Define the app for Rack::Test requests
  let(:app) { Hanami.app }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include_context "with Rack::Test", type: :request

  config.include Warden::Test::Helpers, type: :request
  config.after(:each, type: :request) { Warden.test_reset! }
  config.before(:suite) { Hanami.app.start :warden }
end
