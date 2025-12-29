# frozen_string_literal: true

module Casts
  module Repos
    class PodcastRepo < Casts::DB::Repo
      def create(attrs)
        attrs = attrs.transform_keys(&:to_sym)

        attrs[:uuid] ||= SecureRandom.uuid
        attrs[:created_at] ||= Time.now
        attrs[:updated_at] ||= Time.now

        podcasts.changeset(:create, attrs).commit
      end

      def by_uuid(uuid) = podcasts.where(uuid:).one!
    end
  end
end
