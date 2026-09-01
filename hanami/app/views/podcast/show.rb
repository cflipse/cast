# frozen_string_literal: true

module Cast
  module Views
    module Podcast
      class Show < Cast::View
        include Deps[
          "repos.podcast_repo",
          "repos.episode_repo",
        ]

        expose :podcast do |id:|
          podcast_repo.by_slug(id)
        end

        expose :episodes do |podcast|
          episode_repo.published(podcast_id: podcast.id)
        end
      end
    end
  end
end
