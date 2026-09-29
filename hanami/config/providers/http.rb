Hanami.app.register_provider(:http) do
  prepare do
    require "net/http"
    require "uri"
    require "json"
  end

  start do
    register "http", Net::HTTP
  end
end
