require "pry"

RSpec.feature "/podcasts/:id" do

  let(:podcasts) { Cast::App["repos.podcast_repo"] }

  it "loads the podcast" do
    Factory[:podcast, name: "Bone, Stone & Obsidian"]
    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_text(/Bone, Stone & Obsidian/)

    # TODO and show it's most recent episodes, once that's linked in
  end

  it "provides a list of all published episodes" do
    day = 60 * 60 * 24  # seconds in a day
    podcast = Factory[:podcast, name: "Bone, Stone & Obsidian"]

    7.times { Factory[:episode, podcast:] }
    Factory[:episode, podcast:, deleted_at: Time.now - (3*day)]
    Factory[:episode, podcast:, published: Time.now + (1*day)]

    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_selector(".podcast-episodes article", count: 7)
    # click_on "Feed", visible: :any
    # feed = Nokogiri.parse(page.body)
    #
    # expect(feed.search("item title").count).to eq 7
  end


end
