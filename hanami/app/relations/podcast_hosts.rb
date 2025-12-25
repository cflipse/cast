# frozen_string_literal: true

module Casts
  module Relations
    class PodcastHosts < Casts::DB::Relation
      schema :podcast_hosts, infer: true
    end
  end
end
