# frozen_string_literal: true

module Auth
  module Views
    class Check < Auth::View
      include Deps["oauth"]

      expose :oauth_url do |oauth_state:, base_url:|
        oauth.authorization_uri(state: oauth_state, base_url:)
      end
    end
  end
end
