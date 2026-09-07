# auto_register: false
# frozen_string_literal: true

require "kramdown"

module Cast
  module Views
    module Parts
      class Podcast < Cast::Views::Part
        include Uploaders::CoverUploader::Attachment(:image)

        def description = format(super)
        def episode_description = format(latest_episode.description)

        private

        def format(text)
          helpers.escape_html(text)
            .then { |md| Kramdown::Document.new md }
            .then { |md| helpers.raw md.to_html }
        end
      end
    end
  end
end
