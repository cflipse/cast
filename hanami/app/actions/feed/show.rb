# frozen_string_literal: true

module Cast
  module Actions
    module Feed
      class Show < Cast::Action
        config.formats.accept :rss, :html

        include Deps[
          "feed_builder",
          "repos.podcast_repo",
        ]

        def handle(request, response)
          podcast = podcast_repo.by_slug(request.params[:id])

          response.format = :rss
          response.body = feed_builder.call(podcast, routes)
        end
      end
    end
  end
end
