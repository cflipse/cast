# auto_register: false
# frozen_string_literal: true

module Auth
  class Action < Cast::Action
    def handle(request, response)
      super(request, response)
    end
  end
end
