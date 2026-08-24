require "pry"

RSpec.feature "/podcasts/:id" do

  let(:podcasts) { Cast::App["repos.podcast_repo"] }

  before do
    podcasts.create(
      name: "Bone, Stone & Obsidian",
      slug: "bso",
      explicit: false,
    )
  end

  it "loads the podcast" do
    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_text(/Bone, Stone & Obsidian/)

    # TODO and show it's most recent episodes, once that's linked in
  end
end
