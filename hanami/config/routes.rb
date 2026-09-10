# frozen_string_literal: true

module Cast
  class Routes < Hanami::Routes
    # Add your routes here. See https://hanakai.org/learn/hanami/routing/ for details.
    root to: "home.index"

    get "/podcasts/:id.rss", to: "feed.show", as: :podcast_feed
    get "/podcasts/:id", to: "podcast.show", as: :podcast

    get "/podcasts/:podcast_id/episodes/:id", to: "episode.show", as: :episode
    get "/episode/:id", to: "episode.show"
    get "/feed/:id", to: "feed.show"
  end
end
