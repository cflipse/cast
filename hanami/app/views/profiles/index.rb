# frozen_string_literal: true

module Cast
  module Views
    module Profiles
      class Index < Cast::View

        include Deps[
          "repos.profiles_repo",
        ]

        expose :profiles do
          profiles_repo.all
        end
      end
    end
  end
end
