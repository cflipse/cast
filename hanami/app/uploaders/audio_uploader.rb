require "shrine"
require "taglib"

module Cast
  module Uploaders
    class AudioUploader < Hanami.app["shrine"]
      Attacher.validate do |**opts|
        validate_mime_type_inclusion %w[audio/mpeg]
      end

      MEGABYTE = 1024 * 1024

      add_metadata :duration do |io|
        Shrine.with_file(io) do |file|
          TagLib::FileRef.open(file.path) do |audio|
            audio
              &.audio_properties
              &.length_in_seconds
          end
        end
      end

      plugin :remote_url, max_size: 800 * MEGABYTE
    end
  end
end
