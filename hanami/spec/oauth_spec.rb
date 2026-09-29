RSpec.describe Cast::OAuth do
  let(:http) { class_double "Net::Http", :post_form }

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

  describe "#call" do
    let(:state) { "abc123" }
    let(:params) { Hash[
      state: "abc123",
      code: "sekret-squirrel",
    ]}

    let(:body) { Hash[] }
    let(:profile) { Hash[] }
    let(:token_resp) { Net::HTTPSuccess.new('1.1', "200", "OK") }
    let(:profile_resp) { Net::HTTPSuccess.new('1.1', "200", "OK") }

    before do
      allow(http).to receive(:post_form).and_return(token_resp)
      allow(token_resp).to receive(:body) { JSON.dump(body) }

      allow(http).to receive(:get).and_return(profile_resp)
      allow(profile_resp).to receive(:body) { JSON.dump(profile) }
    end

    context "when state does not match" do
      it "is a failure" do
        res = oauth.call(params, state: "other")

        expect(res).to be_failure
      end
    end

    it "posts to the googleAPI path" do
      res = oauth.call(params, state:)
      expect(http).to have_received(:post_form)
        .with("https://googleapis.com", anything)
    end

    context "failed call" do
      let(:token_resp) { Net::HTTPResponse.new("1.1", "400", "bad request") }

      it "is a failure" do
        res = oauth.call(params, state:)

        expect(res).to be_failure
      end
    end

    it "returns the access token" do
      body["access_token"] = "access/12345"

      oauth.call(params, state:)

      expect(http).to have_received(:get).with("https://googleapis.com", hash_including("Authorization" => "Bearer access/12345"))
    end

    it "extracts the profile from the response" do
      profile["email"] = "j@doe.com"

      resp = oauth.call(params, state:)
      expect(resp.value!).to match("email" => "j@doe.com")
    end
  end
end
