# frozen_string_literal: true

module Cast
  module Views
    module Home
      class Index < Cast::View
        include Deps["repos.podcast_repo"]

        expose :podcasts do
          podcast_repo.by_name
        end
      end
    end
  end
end
