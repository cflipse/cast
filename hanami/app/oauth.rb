module Cast
  class OAuth < Dry::Operation
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

    def call(params, state:)
      step match_states(state, params[:state])
      token = step fetch_tokens(params[:code])

      step profile(token)
    end

    private

    def api_uri = "https://googleapis.com"

    def match_states(initial, received)
      initial == received ? Success() : Failure[:invalid_state]
    end

    def fetch_tokens(code)
      payload = {
        client_id: settings.google_client_id,
        client_secret: settings.google_client_secret,
        redirect_uri: settings.oauth_redirect_uri,
        grant_type: "authorization_code",
        code: code,
      }

      resp = http.post_form(api_uri, payload)

      case resp
      when Net::HTTPSuccess
        Success JSON.parse(resp.body)["access_token"]
      else
        Failure[:http, resp]
      end
    end

    def profile(token)
      resp = http.get(api_uri, { "Authorization" => "Bearer #{token}" })

      case resp
      when Net::HTTPSuccess
        Success JSON.parse(resp.body)
      else
        Failure[:profile_fech, resp]
      end
    end
  end
end
