require "rails_helper"

RSpec.describe "authorizations", type: :request do
  describe "POST /auth/:google_oauth2/" do
    context "when no profile exists" do
      it "redirects with a warning" do
        fake_google_auth Faker::Omniauth.google
        get "/auth/google_oauth2/callback"

        expect(response).to redirect_to "/"
        follow_redirect!

        expect(response.body).to match(/Unknown user/)
      end
    end

    context "when a given admin profile exists" do
      let(:profile) { create :profile, :admin }

      before do
        fake_google_auth Faker::Omniauth.google email: profile.email
      end

      it "authorizes as the profile user" do
        get "/auth/google_oauth2/callback"
        follow_redirect!

        expect(response.body).to match(/Welcome #{profile.display_name}/)
      end
    end
  end
end
