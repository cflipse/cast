require "webmock/rspec"

RSpec.configure do |config|
  config.prepend_before :suite do
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
