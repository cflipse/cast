# frozen_string_literal: true

module Cast
  module Actions
    module Podcast
      class Show < Cast::Action
        config.formats.accept :html, :rss

        include Deps[
          view: "views.podcast.show",
          feed: "views.feed.show",
        ]

        def handle(request, response)
          case response.format
          when :html then response.render(view, id: request.params[:id])
          when :rss  then response.render(feed, id: request.params[:id])
          end
        end
      end
    end
  end
end
