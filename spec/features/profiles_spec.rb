require "rails_helper"

RSpec.describe "Profiles" do
  scenario "create a new profile" do
    visit "/"

    click_on "Add Profile"

    display_name = Faker::Internet.name

    fill_in "Display name", with: display_name
    fill_in "Login", with: Faker::Internet.username

    fill_in "Email", with: Faker::Internet.email

    fill_in "Bio", with: Faker::Lorem.paragraphs(number: 2).join("\n")

    click_on "Create Profile"

    expect(page).to have_content("Created profile for #{display_name}")
  end

  scenario "Editing profiles" do
    pending
    profile = create :profile

    visit "/"
    click_on profile.display_name

    click_on "Edit Profile"

    lorem = Faker::Lorem.paragraphs(number: 6).join("\n")

    fill_in "Bio", with: lorem

    expect {
      click_on "Update Profile"
    }.to change(profile, :bio).to lorem
  end
end
