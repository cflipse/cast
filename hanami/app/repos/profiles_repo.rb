module Cast
  module Repos
    class ProfilesRepo < Cast::DB::Repo

      def all = profiles.to_a
    end
  end
end
