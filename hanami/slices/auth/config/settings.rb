module Auth
  class Settings < Hanami::Settings
    setting :google_client_id, constructor: Types::String, default: ""
    setting :google_client_secret, constructor: Types::String, default: ""
    setting :oauth_redirect_uri, default: "/oauth"
  end
end
