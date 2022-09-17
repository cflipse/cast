require "taglib"

class AudioUploader < Shrine
  Attacher.validate do |**options|
    validate_mime_type_inclusion %w[audio/mpeg]
  end

  add_metadata :duration do |io|
    Shrine.with_file(io) do |file|
      TagLib::FileRef.open(file.path) do |audio|
        audio
          &.audio_properties
          &.length_in_seconds
      end
    end
  end

  plugin :remote_url, max_size: 200.megabytes
end
