# frozen_string_literal: true

module Cast
  module Views
    module Podcast
      class Feed < Cast::View
        include Deps[
          "feed_builder",
          "repos.podcast_repo",
          "repos.episode_repo",
        ]

        decorate :podcast do |id:|
          podcast_repo.by_slug(id)
        end

        decorate :episodes do |podcast|
          episode_repo.published(podcast_id: podcast.id)
        end

        def render(context, podcast:, episodes:)
          feed_builder.call(podcast, routes)
        end
      end
    end
  end
end
