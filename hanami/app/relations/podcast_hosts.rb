# frozen_string_literal: true

module Casts
  module Relations
    class PodcastHosts < Casts::DB::Relation
      schema :podcast_hosts, infer: true do
        associations do
          belongs_to :podcast
          belongs_to :profile, as: :host
        end
      end
    end
  end
end
