require "dry/system/stubs"

RSpec.configure do |config|
  config.around :each, :stub do |ex|
    Hanami.app.container.enable_stubs!
    ex.call
  ensure
    Hanami.app.container.unstub
  end
end
