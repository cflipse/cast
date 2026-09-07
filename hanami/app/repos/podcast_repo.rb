# frozen_string_literal: true

module Cast
  module Repos
    class PodcastRepo < Cast::DB::Repo
      def index 
        root.order(:name)
          .combine(:latest_episode).to_a
      end

      def create(attributes)
        root.changeset(:create, attributes).commit
      end

      def by_slug(slug) = root.where(slug:).one
    end
  end
end
