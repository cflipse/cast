# frozen_string_literal: true

module Casts
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool

    setting :s3_bucket, constructor: Types::String
    setting :s3_region, constructor: Types::String
    setting :s3_access_key_id, constructor: Types::String
    setting :s3_secret_access_key, constructor: Types::String
    setting :s3_endpoint, constructor: Types::String

    setting :spaces_host, constructor: Types::String
  end
end
