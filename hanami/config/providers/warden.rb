Hanami.app.register_provider(:warden) do
  prepare do
    require "warden"
  end

  start do
    slice.start(:db)

    Warden::Strategies.add(:oauth) do
      def valid? = params["oauth_token"].to_s != ""

      def authenticate!
        repo = Hanami.app["repos.profile_repo"]

        resp = Auth::Slice["oauth"]
          .call(params, state: session[:oauth_state], base_url: request.base_url)

        if resp.success?
          email = resp.value!["email"]
          if email
            success! repo.profiles.by_email(email)
          else
            fail! "missing email"
          end
        else
          fail! "nope"
        end
      end
    end

    Warden::Manager.serialize_into_session { |profile| profile.id }
    Warden::Manager.serialize_from_session { |id| slice["repos.profiles_repo"].by_pk(id).one }
  end
end
