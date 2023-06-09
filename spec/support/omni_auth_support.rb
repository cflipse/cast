module Support
  module OmniAuthSupport
    def fake_google_auth(fake)
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(fake)
    end

    def login_as profile
      fake_google_auth Faker::Omniauth.google(email: profile.email)

      visit "/login"
      click_on "Google"
    end
  end
end
