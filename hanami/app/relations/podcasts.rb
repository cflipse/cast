# frozen_string_literal: true

module Cast
  module Relations
    class Podcasts < Cast::DB::Relation
      schema :podcasts, infer: true do
        attribute :image_data, Types::Hash
      end
    end
  end
end
