RSpec.describe Auth::OAuth, :http do
  let(:settings) {
    double("Auth::Settings",
      google_client_id: "my client",
      google_client_secret: "sooper sekret",
      oauth_redirect_path: "/oauth",
    )
  }

  let(:token_url) { "https://oauth2.googleapis.com/token" }
  let(:userinfo_url) { "https://www.googleapis.com/oauth2/v2/userinfo" }
  let(:base_url) { "https://test.example.com" }

  before do
  end

  subject(:oauth) { described_class.new(settings:, base_url:) }

  describe "authorization_uri" do
    let(:state) { "abc123" }

    it "interpolates the given state" do
      expect(oauth.authorization_uri(state:, base_url:)).to match(/state=abc123/)
    end

    it "includes client_id" do
      expect(oauth.authorization_uri(state:, base_url:)).to match(/client_id=my\+client/)
    end

    it "includes the redirect_uri" do
      expect(oauth.authorization_uri(state:, base_url:)).to match(/redirect_uri=#{CGI.escape('https://test.example.com/oauth')}/)
    end
  end

  describe "#call" do
    let(:state) { "abc123" }
    let(:params) { Hash[
      state: "abc123",
      code: "sekret-squirrel",
    ]}

    let(:body) { Hash["access_token" => "access"] }
    let(:profile) { Hash[] }
    let(:token_resp) { Net::HTTPSuccess.new('1.1', "200", "OK") }
    let(:profile_resp) { Net::HTTPSuccess.new('1.1', "200", "OK") }

    before do
      stub_request(:post, token_url)
        .to_return(body: ->(_){ JSON.dump(body) }, status: 200)

      stub_request(:get, userinfo_url)
        .to_return(body: ->(_){ JSON.dump(profile) }, status: 200)
    end

    context "when state does not match" do
      it "is a failure" do
        res = oauth.call(params, state: "other", base_url:)

        expect(res).to be_failure
      end
    end

    it "posts to the googleAPI path" do
      oauth.call(params, state:, base_url:)

      expect(WebMock).to have_requested(:post, token_url)
    end

    context "failed call" do
      before do
        stub_request(:post, token_url).to_return status: 400
      end

      it "is a failure" do
        res = oauth.call(params, state:, base_url:)

        expect(res).to be_failure
      end
    end

    it "returns the access token" do
      body["access_token"] = "access/12345"

      oauth.call(params, state:, base_url:)

      expect(WebMock).to have_requested(:get, userinfo_url)
        .with(headers: {"Authorization" => "Bearer access/12345"})
    end

    it "fails when the access token is missing" do
      body["access_token"] = nil

      expect(oauth.call(params, state:, base_url:)).to be_failure
    end

    it "extracts the profile from the response" do
      profile["email"] = "j@doe.com"

      resp = oauth.call(params, state:, base_url:)
      expect(resp.value!).to match("email" => "j@doe.com")
    end
  end
end
