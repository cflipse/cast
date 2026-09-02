# frozen_string_literal: true

module Cast
  module Repos
    class EpisodeRepo < Cast::DB::Repo
      def for_cast(podcast) 
        root.where(podcast_id: podcast[:id])
      end

      def published(podcast_id:)
        root.published.where(podcast_id:).to_a
      end

      def find(id)
        root.where(uuid: id).one!
      end
    end
  end
end
