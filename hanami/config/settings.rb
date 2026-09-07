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
    setting :spaces_bucket, constructor: Types::String
    setting :spaces_region, constructor: Types::String
    setting :spaces_host, constructor: Types::String.optional
    setting :spaces_force_path_style, constructor: Types::Params::Bool, default: false
  end
end
