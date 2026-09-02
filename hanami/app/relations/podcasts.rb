# frozen_string_literal: true

module Cast
  module Relations
    class Podcasts < Cast::DB::Relation
      schema :podcasts, infer: true do
        attribute :uuid, Types::String.default { SecureRandom.uuid }
        attribute :image_data, Types::Hash

        associations do
          has_many :episodes
        end
      end
    end
  end
end
