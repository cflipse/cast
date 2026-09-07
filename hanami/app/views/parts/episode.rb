# auto_register: false
# frozen_string_literal: true

module Cast
  module Views
    module Parts
      class Episode < Cast::Views::Part
        include Uploaders::AudioUploader::Attachment(:audio)
      end
    end
  end
end
