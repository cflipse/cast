# frozen_string_literal: true

require "hanami"

module Casts
  class App < Hanami::App
    if Hanami.env?(:development, :test)
      # Allow loading images over HTTP in development environment
      config.actions.content_security_policy[:img_src] += " http:"
    end
  end
end
