# frozen_string_literal: true

module Cast
  module Relations
    class Episodes < Cast::DB::Relation
      schema :episodes, infer: true do
        attribute :audio_data, Types::Hash
        attribute :slugs, Types.Array(Types::String)

        associations do
          belongs_to :podcast
        end
      end
    end
  end
end
