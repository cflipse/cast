# frozen_string_literal: true

module Auth
  module Actions
    class Callback < Auth::Action
      include Deps["oauth"]

      def handle(request, response)
        state = response.session.delete(:oauth_state)
        result = oauth.call(request.params.to_h, state:, base_url: request.base_url)

        response.render view, result: result
      end
    end
  end
end
