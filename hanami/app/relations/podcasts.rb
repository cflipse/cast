# frozen_string_literal: true

module Casts
  module Relations
    class Podcasts < Casts::DB::Relation
      schema :podcasts, infer: true do
        attribute :image_data, ROM::Types::Coercible::JSON
      end
    end
  end
end
