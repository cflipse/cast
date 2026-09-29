RSpec.describe "Authentication", :db, type: :request do
  let(:profile) { Factory[:profile] }

  it "succeeds" do
    login_as profile

    get "/"
    page = Capybara.string(last_response.body)
    expect(page).to have_text(profile.display_name)
  end
end
