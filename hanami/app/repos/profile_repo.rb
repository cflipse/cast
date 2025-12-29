# frozen_string_literal: true

module Casts
  module Repos
    class ProfileRepo < Casts::DB::Repo
      def create attrs
        attrs[:uuid] ||= SecureRandom.uuid
        attrs[:created_at] ||= Time.now.utc
        attrs[:updated_at] ||= Time.now.utc

        profiles.command(:create).call(attrs)
      end

      def find(id) = profiles.by_pk(id).one!
    end
  end
end
