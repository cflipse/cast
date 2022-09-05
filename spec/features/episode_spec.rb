require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  let(:podcast) { create :podcast }

  scenario "Create a new episode" do
    visit podcast_path(podcast)

    click_on "New Episode"

    fill_in "Name", with: "Defilers are bad, mkay?"
    fill_in "Number", with: 4
    fill_in "Published", with: "2021-10-30"

    attach_file "Audio", Rails.root.join("spec/fixtures/bso001-templars.mp3")

    expect {
      click_on "Create Episode"
    }.to change(Episode, :count).by 1

    expect(page).to have_content("Episode 4: Defilers are bad, mkay?")
  end
end
