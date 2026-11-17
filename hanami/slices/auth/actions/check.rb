# frozen_string_literal: true

module Auth
  module Actions
    class Check < Auth::Action
      def handle(request, response)
        response[:base_url] = request.base_url
        response[:oauth_state] = response.session[:oauth_state] ||= SecureRandom.hex
      end
    end
  end
end
