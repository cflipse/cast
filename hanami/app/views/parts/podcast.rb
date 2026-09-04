# auto_register: false
# frozen_string_literal: true

module Cast
  module Views
    module Parts
      class Podcast < Cast::Views::Part
        include Uploaders::CoverUploader::Attachment(:image)
      end
    end
  end
end
