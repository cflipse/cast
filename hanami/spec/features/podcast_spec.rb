require "pry"

RSpec.feature "/podcasts/:id" do

  let(:podcasts) { Cast::App["repos.podcast_repo"] }

  before do
    Factory[:podcast, name: "Bone, Stone & Obsidian"]
  end

  it "loads the podcast" do
    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_text(/Bone, Stone & Obsidian/)

    # TODO and show it's most recent episodes, once that's linked in
  end
end
