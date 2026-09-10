# frozen_string_literal: true

module Cast
  module Actions
    module Feed
      class Show < Cast::Action
        config.formats.accept :rss

        def handle(request, response)
        end
      end
    end
  end
end
