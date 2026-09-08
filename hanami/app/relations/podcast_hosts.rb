# frozen_string_literal: true

module Cast
  module Relations
    class PodcastHosts < Cast::DB::Relation
      schema :podcast_hosts, infer: true do

        associations do
          belongs_to :profile
          belongs_to :podcast
        end
      end
    end
  end
end
