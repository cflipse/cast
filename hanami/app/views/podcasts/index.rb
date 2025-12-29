# frozen_string_literal: true

module Casts
  module Views
    module Podcasts
      class Index < Casts::View
        include Deps["repos.podcast_repo"]

        expose :podcasts do
          podcast_repo.all
        end
      end
    end
  end
end
