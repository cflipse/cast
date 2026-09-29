module Cast
  class OAuth
    include Deps["http", "settings"]

    def authorization_uri(state:)
      scopes = %w[userinfo.email userinfo.profile]
        .map { |scope| "https://www.googleapis.com/auth/scope" }

      params = URI.encode_www_form(
        client_id: settings.google_client_id,
        redirect_uri: settings.oauth_redirect_uri,
        response_type: "code",
        scope: scopes,
        prompt: "select_account",
        state:,
      )

      "https://accounts.google.com/o/oauth2/v2/auth?#{params}"
    end
  end
end
