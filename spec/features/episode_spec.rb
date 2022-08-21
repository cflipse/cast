require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  scenario "Create a new episode" do
    pending "check correctness"

    visit "/"
    click_on "New Episode"

    fill_in "Title", with: "Defilers are bad, mkay?"
    fill_in "Published", with: "2021-10-30"

    expect {
      click_on "Create Episode"
    }.to change(Episode, count).by 1
  end
end
