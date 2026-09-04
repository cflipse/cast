# frozen_string_literal: true

require "hanami"

module Cast
  class App < Hanami::App
    environment(:development) do
      config.actions.content_security_policy[:img_src] += " http://localhost:*"
      config.actions.content_security_policy[:media_src] += " http://localhost:*"
    end
  end
end
