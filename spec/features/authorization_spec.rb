require "rails_helper"

RSpec.describe "Authorizing as an admin", type: :feature do
  context "with an existing profile" do
    let(:profile) { create :profile }

    it "logs in" do
      fake_google_auth Faker::Omniauth.google email: profile.email

      visit "/login"
      click_on "Google"

      # the flash
      expect(page).to have_content(/Welcome #{profile.display_name}/)

      visit "/podcasts"

      within "#heading" do
        # and verify that we are still logged in by header display
        expect(page).to have_content(profile.display_name)
      end
    end

    it "lets you log out" do
      fake_google_auth Faker::Omniauth.google email: profile.email

      visit "/login"
      click_on "Google"

      within "#heading" do
        click_on "Log out"
      end

      expect(page).to have_content("logged out")
      within("#heading") do
        expect(page).to have_no_content(profile.display_name)
      end
    end
  end
end
