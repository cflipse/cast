# frozen_string_literal: true

module Cast
  module Actions
    module Podcast
      class Show < Cast::Action
        config.formats.accept :html, :rss

        include Deps[
          "feed_builder",
          view: "views.podcast.show",
          repo: "repos.podcast_repo",
        ]

        def handle(request, response)
          case response.format
          when :html then response.render(view, id: request.params[:id])
          when :rss  then
            podcast = repo.by_slug(request.params[:id])
            feed_builder.call(podcast, routes)
          end
        end
      end
    end
  end
end
