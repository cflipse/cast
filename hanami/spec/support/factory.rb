require "rom/factory"
require "faker"

Factory = ROM::Factory.configure do |config|
  config.rom = Casts::App.container["db.rom"]
end

Dir["#{File.dirname(__FILE__)}/../factories/*.rb"].each { |file| require file }
