# frozen_string_literal: true

module Cast
  module Views
    module Home
      class Index < Cast::View
        include Deps["repos.podcast_repo"]

        decorate :podcasts do
          podcast_repo.index
        end
      end
    end
  end
end
