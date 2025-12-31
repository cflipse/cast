require "uploaders/cover_uploader"

module Casts
  module Structs
    class Podcast < ROM::Struct
      include CoverUploader::Attachment(:image)

      attr_writer :image_data
    end
  end
end
