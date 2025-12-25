# frozen_string_literal: true

module Casts
  module Relations
    class Episodes < Casts::DB::Relation
      schema :episodes, infer: true do
        attribute :audio_data, ROM::Types::Coercible::JSON
        attribute :slugs, ROM::Types::Coercible::JSON

        associations do
          belongs_to :podcast
        end
      end
    end
  end
end
