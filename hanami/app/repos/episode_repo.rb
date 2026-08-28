# frozen_string_literal: true

module Cast
  module Repos
    class EpisodeRepo < Cast::DB::Repo
      def for_cast(podcast) 
        root.where(podcast_id: podcast[:id])
      end
    end
  end
end
