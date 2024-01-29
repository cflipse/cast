OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, Rails.application.credentials.google_client_id,
    Rails.application.credentials.google_client_secret,
    redirect_uri: "https://cast.athas.org/auth/google_oauth2/callback"

end
