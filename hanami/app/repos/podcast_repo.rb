# frozen_string_literal: true

module Cast
  module Repos
    class PodcastRepo < Cast::DB::Repo
      def by_name = root.order(:name).to_a

      def create(attributes)
        defaults = {
          id: SecureRandom.uuid,
        }

        root.changeset(:create,
          defaults.merge(attributes)
        ).commit
      end
    end
  end
end
