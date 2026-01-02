require "shrine"

module Casts
  class AudioUploader < Hanami.app["shrine"]
    TYPES = %w[audio/mpeg audio/ogg audio/flac].freeze
    MAX_SIZE = 800 * 1024 * 1024 # 800 MB

    Attacher.validate do
      validate_mime_type AudioUploader::TYPES
    end

    add_metadata :duration do |io|
      Shrine.with_file(io) do |file|
        Taglib::FileRef.open(file.path) do |audio|
          audio
            &.audio_properties
            &.length_in_seconds.to_i
        end
      end
    end

    plugin :remote_url, max_size: MAX_SIZE
  end
end
