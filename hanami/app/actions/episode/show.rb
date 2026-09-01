# frozen_string_literal: true

module Cast
  module Actions
    module Episode
      class Show < Cast::Action
        config.handle_exception "ROM::TupleCountMismatchError" => 404

        def handle(request, response)
          response.render view, id: request.params[:id], podcast_id: request.params[:podcast_id]
        end
      end
    end
  end
end
