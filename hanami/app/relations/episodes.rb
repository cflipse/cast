# frozen_string_literal: true
require "tzinfo"

module Cast
  module Relations
    class Episodes < Cast::DB::Relation
      include Deps["clock"]

      schema :episodes, infer: true do
        attribute :uuid, Types::String.default { SecureRandom.uuid }
        attribute :audio_data, Types::Hash
        attribute :slugs, Types.Array(Types::String)

        associations do
          belongs_to :podcast
        end
      end

      def published 
        cutoff = clock.cutoff
        where { (published <= cutoff.utc) & deleted_at.is(nil) }
      end
    end
  end
end
