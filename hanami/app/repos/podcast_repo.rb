# frozen_string_literal: true

module Cast
  module Repos
    class PodcastRepo < Cast::DB::Repo
      def by_name = root.order(:name).to_a

      def create(attributes)
        root.changeset(:create, attributes).commit
      end

      def by_slug(slug) = root.where(slug:).one
    end
  end
end
