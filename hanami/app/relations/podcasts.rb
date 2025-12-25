# frozen_string_literal: true

module Casts
  module Relations
    class Podcasts < Casts::DB::Relation
      # JSON_HASH = Types.define(Hash) do
      #   input { |value| JSON.dump(value) }
      #   output { |jsonb| JSON.parse(jsonb) }
      # end

      schema :podcasts, infer: true do
        attribute :image_data, Types::Coercible::Hash.constructor { |value| JSON.dump(value) }
          .meta(read: Types::Hash.constructor { |json| JSON.parse(json) })
      end
    end
  end
end
