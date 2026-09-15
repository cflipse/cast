# frozen_string_literal: true

module Cast
  module Views
    module Podcast
      class Feed < Cast::View
        include Deps[
          "feed_builder",
          "repos.podcast_repo",
        ]

        decorate :podcast do |id:|
          podcast_repo.by_slug(id)
        end

        def render(context, podcast:)
          feed_builder.call(podcast, routes)
        end
      end
    end
  end
end
