# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module Cast
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    def handle(request, response)
      Hanami.app.start("warden")

      super(request, response)
    end
  end
end
