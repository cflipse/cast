# frozen_string_literal: true

module Cast
  module Repos
    class EpisodeRepo < Cast::DB::Repo
      include Deps["slugger"]

      def for_cast(podcast) 
        root.where(podcast_id: podcast[:id])
      end

      def published(podcast_id:)
        root.published.latest.where(podcast_id:).to_a
      end

      def find(id)
        root.by_uuid_or_slug(id).one!
      end

      # Create a new Episode
      #
      # if not provided, derives the slugs from the name
      def create(attrs)
        data = attrs.dup
        data[:slugs] = [slugger.call(data[:name]), *data[:slugs]].uniq

        root.changeset(:create, data).commit
      end

      # Update an existing Episode
      #
      # @note Generates a new slug from the new name, if provided.
      #   if slugs are provided, will replace the _existing_ slugs.
      #   *invariant* There will always be a slug based upon the episode name
      def update(id, attrs)
        original = root.by_pk(id)

        data = original.select(:slugs, :name).one.to_h.merge(attrs)
        data[:slugs] = [slugger.call(data[:name]), *data[:slugs]].uniq

        original.changeset(:update, data).commit
      end
    end
  end
end
