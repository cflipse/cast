# frozen_string_literal: true

module Casts
  module Relations
    class Podcasts < Casts::DB::Relation
      schema :podcasts, infer: true do
        attribute :image_data, ROM::Types::Coercible::JSON
        attribute :explicit, Types::Params::Bool.default { false }

        associations do
          has_many :episodes
          has_many :profiles, through: :podcast_hosts, as: :hosts
        end
      end
    end
  end
end
