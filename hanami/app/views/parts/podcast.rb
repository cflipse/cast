# auto_register: false
# frozen_string_literal: true


module Cast
  module Views
    module Parts
      class Podcast < Cast::Views::Part
        include Deps["markdown"]

        include Uploaders::CoverUploader::Attachment(:image)

        decorate :episodes

        def description = markdown.to_html(super)
        def episode_description = markdown.to_html(latest_episode.description)
      end
    end
  end
end
