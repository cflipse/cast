require "shrine"

module Casts
  class CoverUploader < Hanami.app["shrine"]
    TYPES = %w[image/jpeg image/png image/webp].freeze
    MAX_SIZE = 10 * 1024 * 1024 # 10 MB

    Attacher.validate do
      validate_mime_type CoverUploader::TYPES
    end

    plugin :remote_url, max_size: MAX_SIZE
  end
end
