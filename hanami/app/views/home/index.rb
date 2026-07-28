# frozen_string_literal: true

module Cast
  module Views
    module Home
      class Index < Cast::View
        include Deps["relations.podcasts"]

        expose :podcasts do
          podcasts.to_a
        end
      end
    end
  end
end
