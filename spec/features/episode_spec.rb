require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  pending "add some scenarios (or delete) #{__FILE__}"

  scenario "Create a new episode" do
    visit "/"
    click_on "New Episode"

    fill_in "Title", with: "Defilers are bad, mkay?"
    fill_in "Published", with: "2021-10-30"

    expect {
      click_on "Create Episode"
    }.to change(Episode, count).by 1
  end
end
