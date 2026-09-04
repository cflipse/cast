require "shrine"

module Cast
  module Uploaders
    class CoverUploader < Hanami.app["shrine"]
      Attacher.validate do
        validate_mime_type %w[image/jpeg image/png image/webp]
      end

      MEGABYTES = 1024**2

      plugin :remote_url, max_size: (10 * MEGABYTES)
    end
  end
end
