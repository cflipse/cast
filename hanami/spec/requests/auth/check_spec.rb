# frozen_string_literal: true

RSpec.describe "Auth check", type: :request do
  describe "GET /auth/check" do
    it "builds the redirect_uri from the request host" do
      get "/auth/check", {}, {"HTTP_HOST" => "cast.example.com"}

      page = Capybara.string(last_response.body)
      href = page.find_link("Sign in with Google")[:href]
      redirect = Rack::Utils.parse_query(URI(href).query)["redirect_uri"]

      expect(redirect).to eq("http://cast.example.com/auth/callback")
    end
  end
end
