# frozen_string_literal: true

module Casts
  module Relations
    class Profiles < Casts::DB::Relation
      schema :profiles, infer: true do
        attribute :roles, ROM::Types::Coercible::JSON
      end
    end
  end
end
