RSpec.describe Cast::OAuth do
  let(:http) { class_double "Net::Http" }

  let(:settings) {
    double("Cast::Settings",
      google_client_id: "my client",
      google_client_secret: "sooper sekret",
      oauth_redirect_uri: "/oauth",
    )
  }

  subject(:oauth) { described_class.new(settings:, http:) }

  describe "authorization_uri" do
    let(:state) { "abc123" }

    it "interpolates the given state" do
      expect(oauth.authorization_uri(state:)).to match(/state=abc123/)
    end

    it "includes client_id" do
      expect(oauth.authorization_uri(state:)).to match(/client_id=my\+client/)
    end

    it "includes the redirect_uri" do
      expect(oauth.authorization_uri(state:)).to match(/redirect_uri=%2Foauth/)
    end
  end

end
