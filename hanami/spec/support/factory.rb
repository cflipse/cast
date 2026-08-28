require "rom-factory"

Factory = ROM::Factory.configure do |config|
  config.rom = Cast::App.container["db.rom"]
end

SPEC_ROOT.glob("factories/**/*.rb").each { require it }
