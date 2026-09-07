# frozen_string_literal: true

module Cast
  module Relations
    class Podcasts < Cast::DB::Relation
      unpack = lambda { |values| (String === values) ? JSON.parse(values) : values }
      serialized = Types::String.constructor(&:to_json)

      schema :podcasts, infer: true do
        attribute :image_data, serialized.optional, read: Types::Hash.constructor(&unpack).optional

        associations do
          has_many :episodes
        end
      end
    end
  end
end
