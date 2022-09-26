require "rails_helper"

RSpec.describe "Profiles" do
  scenario "create a new profile" do
    login_as FactoryBot.create :profile, :admin

    visit "/"

    click_on "New Profile"

    display_name = Faker::Internet.name

    fill_in "Display name", with: display_name
    fill_in "Login", with: Faker::Internet.username(separators: %w[- _])

    fill_in "Email", with: Faker::Internet.email

    fill_in "Bio", with: Faker::Lorem.paragraphs(number: 2).join("\n")

    click_on "Create Profile"

    expect(page).to have_content("Created profile for #{display_name}")
  end

  scenario "Editing profiles" do
    profile = create :profile

    login_as profile

    visit "/"

    within "main" do
      click_on profile.display_name
    end

    click_on "Edit Profile"

    fill_in "Bio", with: "This is a test"

    expect {
      click_on "Update Profile"
    }.to change { profile.reload.bio }.to "This is a test"
  end
end
