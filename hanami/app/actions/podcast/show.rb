# frozen_string_literal: true

module Cast
  module Actions
    module Podcast
      class Show < Cast::Action
        before :read_format

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

        def read_format(request, response)
          return if request.params[:format].nil?

          if request.params[:format] =~ /^rss$/i
            response.format = :rss
          else
            halt 406
          end
        end
      end
    end
  end
end
