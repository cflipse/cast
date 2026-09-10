# frozen_string_literal: true

module Cast
  module Views
    module Feed
      class Show < Cast::View
        include Deps[
          "repos.podcast_repo",
        ]

        expose :podcast do |id:|
          podcast_repo.by_slug(id)
        end
      end
    end
  end
end
