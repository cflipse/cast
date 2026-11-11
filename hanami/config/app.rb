# frozen_string_literal: true

require "hanami"

module Cast
  class App < Hanami::App
    environment(:development) do
      require "vite_ruby" 

      config.middleware.use ViteRuby::DevServerProxy

      config.actions.content_security_policy[:img_src] += " http://localhost:*"
      config.actions.content_security_policy[:media_src] += " http://localhost:*"
      config.actions.content_security_policy[:script_src] += " 'nonce' http://localhost:*"
      config.actions.content_security_policy[:connect_src] += " http://localhost:* ws://localhost:*"
    end

    environment :test do
      require "vite_ruby" 

      ViteRuby.instance.logger.level = Logger::INFO
    end

    environment :production do
      config.middleware.use Rack::Static,
        urls: ["/vite"],
        root: config.actions.public_directory,
        header_rules: [[:all, {"cache-control" => "public, max-age=31536000, immutable"}]]
    end
  end
end
