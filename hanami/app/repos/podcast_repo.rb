# frozen_string_literal: true

module Casts
  module Repos
    class PodcastRepo < Casts::DB::Repo
      def create(attrs)
        attrs = attrs.transform_keys(&:to_sym)

        attrs[:image_data] = JSON.dump(attrs[:image_data])
        attrs[:created_at] ||= Time.now
        attrs[:updated_at] ||= Time.now

        pp attrs
        podcasts.changeset(:create, attrs).commit
      end
    end
  end
end
