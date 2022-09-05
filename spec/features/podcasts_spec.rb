require "rails_helper"

RSpec.describe "Podcasts" do
  scenario "Create a new podcast" do
    visit "/"
    click_on "New Podcast"

    fill_in "Name", with: "Adventures in the Wastes"
    fill_in "Description", with: "Travel with us, through the wastelands. An actual play."

    check "Contains explicit content"

    attach_file "podcast_image", Rails.root.join("spec/fixtures/bso-logo.jpg")

    expect {
      click_on "Create Podcast"
    }.to change(Podcast, :count).by 1

    expect(page).to have_content("Successfully added Adventures in the Wastes")
    expect(page).to have_content("Travel with us, through the wastelands. An actual play.")
  end
end
