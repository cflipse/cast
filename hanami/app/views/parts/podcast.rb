# auto_register: false
# frozen_string_literal: true

require "kramdown"

module Cast
  module Views
    module Parts
      class Podcast < Cast::Views::Part
        include Uploaders::CoverUploader::Attachment(:image)

        def description
          helpers.escape_html(super)
            .then { |md| Kramdown::Document.new md }
            .then { |md| helpers.raw md.to_html }
        end
      end
    end
  end
end
