# frozen_string_literal: true
require "tzinfo"

module Cast
  module Relations
    class Episodes < Cast::DB::Relation
      include Deps["clock"]


      unpack = lambda { |values| (String === values) ? JSON.parse(values) : values }

      serialized = Types::String.constructor(&:to_json)

      schema :episodes, infer: true do
        attribute :uuid, Types::String.default { SecureRandom.uuid }
        attribute :audio_data, serialized.optional, read: Types::Hash.constructor(&unpack).optional
        attribute :slugs, serialized.optional, read: Types.Array(Types::String).constructor(&unpack).optional

        associations do
          belongs_to :podcast
        end
      end

      def published 
        cutoff = clock.cutoff
        where { (published <= cutoff.utc) & deleted_at.is(nil) }
      end

      def by_uuid_or_slug(identifier)
        where {
          uuid.is(identifier) |
          Sequel.lit("EXISTS (SELECT 1 FROM json_each(slugs) WHERE value = ?)", identifier)
        }
      end
    end
  end
end
