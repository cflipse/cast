# auto_register: false
# frozen_string_literal: true

module Cast
  module Views
    class Context < Hanami::View::Context

      # Define your view context here. See https://hanakai.org/learn/hanami/views/context/ for details.
      def current_user = request.env["warden"]&.user
    end
  end
end
