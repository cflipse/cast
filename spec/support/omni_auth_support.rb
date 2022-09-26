module Support
  module OmniAuthSupport
    def fake_google_auth(fake)
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(fake)
    end
  end
end
