# frozen_string_literal: true

module Casts
  module Relations
    class Episodes < Casts::DB::Relation
      schema :episodes, infer: true do
        attribute :audio_data, Types::Coercible::Hash.constructor { |value| JSON.dump(value) }
          .meta(read: Types::Hash.constructor { |json| JSON.parse(json) })

        attribute :slugs, Types::Array.of(Types::String)
          .meta(read: Types::Array.of(Types::String).constructor { |v| JSON.parse(v) })
      end
    end
  end
end
