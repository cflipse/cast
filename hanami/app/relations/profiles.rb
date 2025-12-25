# frozen_string_literal: true

module Casts
  module Relations
    class Profiles < Casts::DB::Relation
      schema :profiles, infer: true do
        attribute :roles, Types::Coercible::Array.of(Types::String)
          .meta(read: Types::Array.of(Types::String).constructor { |json| JSON.parse(json) })
      end
    end
  end
end
