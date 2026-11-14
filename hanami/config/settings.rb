# frozen_string_literal: true

module Cast
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool

    # Storage settings for Spaces / Shrinerb
    setting :spaces_access_key_id, constructor: Types::String
    setting :spaces_secret_access_key, constructor: Types::String
    setting :spaces_endpoint, constructor: Types::String

    setting :spaces_bucket, constructor: Types::String, default: "casts"
    setting :spaces_region, constructor: Types::String, default: "nyc3"
    setting :spaces_host, constructor: Types::String.optional
    setting :spaces_force_path_style, constructor: Types::Params::Bool, default: false

    setting :session_secret, constructor: Types::String

    setting :google_client_id, constructor: Types::String, default: ""
    setting :google_client_secret, constructor: Types::String, default: ""
    setting :oauth_redirect_uri, default: "/oauth"
  end
end
