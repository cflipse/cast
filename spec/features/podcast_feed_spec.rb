require "rails_helper"

RSpec.describe "RSS Feed" do
  let(:podcast) { create :podcast, name: "Bone, Stone & Obsidian", slug: "bso", hosts: hosts }
  let(:hosts) { create_list :profile, 2 }

  it "provides a list of all published episodes" do
    create_list :episode, 7, :published, podcast: podcast
    create :episode, :published, deleted_at: 3.days.ago, podcast: podcast

    visit "/"

    click_on "Bone, Stone & Obsidian"

    expect(page).to have_selector("#episodes article", count: 7)

    click_on "Feed", visible: :any
    feed = Nokogiri.parse(page.body)

    expect(feed.search("item title").count).to eq 7
  end
end
