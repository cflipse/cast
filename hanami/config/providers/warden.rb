Hanami.app.register_provider(:warden) do
  prepare do
    require "warden"
  end

  start do
    slice.start(:db)

    Warden::Strategies.add(:oauth) do
      def valid? = params["oauth_token"].present?

      def authenticate!
        repo = Hanami.app["repos.profile_repo"]

        # TODO be something real
        success!(repo.profiles.limit(1).one)
      end
    end

    Warden::Manager.serialize_into_session { |profile| profile.id }
    Warden::Manager.serialize_from_session { |id| Hanami.app["repos.profile_repo"].by_pk(id).one }
  end
end
