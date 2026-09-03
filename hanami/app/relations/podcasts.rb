# frozen_string_literal: true

module Cast
  module Relations
    class Podcasts < Cast::DB::Relation
      schema :podcasts, infer: true do
        attribute :image_data, Types::JSON::Hash

        associations do
          has_many :episodes
        end
      end
    end
  end
end
