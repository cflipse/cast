# frozen_string_literal: true

module Cast
  module Actions
    module Health
      class Show < Cast::Action
        include Deps["relations.podcasts"]

        def handle(request, response)
          podcasts.first

          response.status = 200
        end
      end
    end
  end
end
