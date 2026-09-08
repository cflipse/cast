# frozen_string_literal: true

module Cast
  module Relations
    class Profiles < Cast::DB::Relation

      serialized = Types::String.constructor(&:to_json)
      unpack = lambda { |values| (String === values) ? JSON.parse(values) : values }

      schema :profiles, infer: true do
        attribute :roles, serialized.optional,
          read: Types.Array(Types::String).constructor(&unpack).optional

        associations do
          has_many :podcast_hosts
          has_many :podcasts, through: :podcast_hosts
        end
      end
    end
  end
end
