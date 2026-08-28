# frozen_string_literal: true

module Cast
  module Views
    module Episode
      class Show < Cast::View

        include Deps["repos.episode_repo"]

        expose :episode do |id:|
          episode_repo.find(id)
        end
      end
    end
  end
end
