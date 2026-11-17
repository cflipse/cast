module Auth
  class OAuth < Dry::Operation
    include Deps["http", "settings"]

    def authorization_uri(state:)
      scopes = %w[userinfo.email userinfo.profile]
        .map { |scope| "https://www.googleapis.com/auth/#{scope}" }

      params = URI.encode_www_form(
        client_id: settings.google_client_id,
        redirect_uri: settings.oauth_redirect_uri,
        response_type: "code",
        scope: scopes.join(" "),
        prompt: "select_account",
        state:,
      )

      "https://accounts.google.com/o/oauth2/v2/auth?#{params}"
    end

    def call(params, state:)
      step match_states(state, params[:state])
      token = step fetch_tokens(params[:code])

      step profile(token)
    end

    private

    def match_states(initial, received)
      initial && (initial == received) ? Success() : Failure[:invalid_state]
    end

    def fetch_tokens(code)
      payload = {
        client_id: settings.google_client_id,
        client_secret: settings.google_client_secret,
        redirect_uri: settings.oauth_redirect_uri,
        grant_type: "authorization_code",
        code: code,
      }

      url = URI("https://oauth2.googleapis.com/token")

      resp = http.post_form(url, payload)

      case resp
      when Net::HTTPSuccess
        access_token = JSON.parse(resp.body)["access_token"]

        access_token.to_s != "" ? Success(access_token) : Failure[:missing_token, resp]
      else
        Failure[:http, resp]
      end
    end

    def profile(token)
      url = URI("https://www.googleapis.com/oauth2/v2/userinfo")

      resp = http.get_response(url, { "Authorization" => "Bearer #{token}" })

      case resp
      when Net::HTTPSuccess
        Success JSON.parse(resp.body)
      else
        Failure[:profile_fetch, resp]
      end
    end
  end
end
