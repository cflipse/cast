require "taglib"

class AudioUploader < Shrine
  add_metadata :duration do |io|
    Shrine.with_file(io) do |file|
      TagLib::FileRef.open(file.path) do |audio|
        audio
          .audio_properties
          .length_in_seconds
      end
    end
  end
end
