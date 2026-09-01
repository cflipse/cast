# frozen_string_literal: true
require "tzinfo"

module Cast
  module Relations
    class Episodes < Cast::DB::Relation
      PUBLISH_TZ = TZInfo::Timezone.get('America/New_York')

      schema :episodes, infer: true do
        attribute :audio_data, Types::Hash
        attribute :slugs, Types.Array(Types::String)

        associations do
          belongs_to :podcast
        end
      end

      def published 
        today =  PUBLISH_TZ.now.to_date
        cutoff = Time.new(today.year, today.month, today.day, 8, 0, 0, PUBLISH_TZ)

        where { (published <= cutoff) & deleted_at.is(nil) }
      end
    end
  end
end
