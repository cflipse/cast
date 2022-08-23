require "rails_helper"

RSpec.describe "RSS Feed" do
  let(:podcast) { create :podcast, name: "Bone, Stone & Obsidian", slug: "bso", hosts: hosts }
  let(:hosts) { create_list :profile, 2 }

  it "provides a list of all episodes" do
    create_list :episode, 7, podcast: podcast

    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_selector("#episodes li", count: 7)
  end
end
